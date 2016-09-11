package omdoc
import scala.xml.{Node}
import xml.{attr}
import utils.{log}

/* 
   DevGraph represents an OMDoc document seen as a multi-graph of theories and links.
   nodes: list of theories, unflattened
   links: list of links
   context: the original OMDoc document
   The original document must be ordered such that no theory/link/symbol/axiom is referenced before it is declared.
     (This does not prohibit mutual recursion because definitions may occur anywhere.)
   Notation: A link is an explicit map from one theory to another as given by an imports or theory-inclusion element.
      A morphism is a sequence of (paths of) composable links.
   Main interface functions:
     apply: applies a morphism to a term.
     checkHome: checks whether a term is valid (= has well-defined semantics) over a theory
   Invariant: This class is immutable except via the functions addTheory and addLink.
*/
   
// This is thrown when trying to look up a map or a path.
case class MapError(s : String) extends java.lang.Throwable(s)
case class RefError(s : String) extends java.lang.Throwable(s)

/*
  context: the document to be parsed
  base: the base reference to be used
  lib: the containing library (to which the document will add itself)
  addPresentation: callback method for presentations
*/
class DevGraph private (val lib : Library) extends presentation.Presentable {
   protected var statements : List[Statement] = Nil // the sequence of theory level statements
   protected val lookup = new scala.collection.mutable.HashMap[Path,Statement] //maps paths efficiently to their statements
   //private var context : Node = null
   protected var idVar : Path = null
   def id = idVar

   def this(context : Node, base : Path, lib : Library, addPresentation : (Node, Path) => Unit) = {
      this(lib)
      //this.context = context
      val cdbase = attr(context,"cdbase")
      idVar = if (cdbase == "") base else Parse.path(cdbase)
      //The graph must add itself to the library so that it is available during parsing
      lib.addGraph(this)
      log("processing theory graph at " + id,0)
      //in general, theories and morphisms must be processed in graph order, not in document order
      for (N <- context.child) N.label match {
         case "theory" =>
            //The theory will add itself by calling addTheory.
            //The construction will callback to the graph to apply translations etc.
            //During construction the partially constructed theory is already available, and will change incrementally.
            new Theory(N, this, id, addPresentation)
         case "view" => 
            val li = new Link(N, this, id)
            addLink(li)
         case "presentation" =>
            addPresentation(N, id)
      }
   }
   //default constructor that ignores presentation information
   def this(context : Node, base : Path, lib : Library) = this(context, base, lib, (N,P) => ())
   
   //components are the theories and views; imports are components of the containing ThDecl
   def components = statements.filter({case ImpDecl(_) => false case _ => true})
   
   //state change, call back, access and output functions
   def addTheory(th : Theory) {
      val dec = ThDecl(th)
      statements = statements ::: List(dec)
      lookup(th.id) = dec
   }
   def addLink(li : Link) {
      val dec = if (li.tp == defLink) ImpDecl(li) else VwDecl(li)
      statements = statements ::: List(dec)
      lookup(li.id) = dec
   }
   def getTheory(path : Path) : Theory =
      try {lookup(path) match {case ThDecl(th) => th}}
      catch {case _ => throw RefError("no theory " + path.toString + " found")}
   def getLink(path : Path) : Link =
      try {lookup(path) match {case ImpDecl(li) => li case VwDecl(li) => li}}
      catch {case _ => throw RefError("no link " + path.toString + " found")}

   def getStatements = statements
   //looks up a statement via the method of the containing theory
   def getStatement(p : Path) : Statement =
      lib.getTheory(p/^).getStatement(p)
      
   //checks if meta is irreflexively and transitively a meta-theory of th
   def isMeta(meta : Path, th : Path) : boolean = {
      val m = lib.getTheory(th).meta
      m != xml.omdocBase && (meta == m || isMeta(meta, m))
   }
   
   //domain and codomain of a morphism
   def domain(via : Morphism, th : Path) : Path =
      if (via.isIdentity)
         th
      else
         lib.getLink(via.head).from
   def codomain(via : Morphism, th : Path) : Path =
      if (via.isIdentity)
        th
      else
         lib.getLink(via.last).to

   def toNode : Node = scala.xml.Utility.trim(
      <omdoc>
      {for (dec <- statements) yield dec match {
         case ThDecl(th) if ! th.subth =>
            //subtheories are printed by printed by their supertheory
            th.toNode
         case VwDecl(li) => 
            //definitional links are printed by the theories
            li.toNode
      }
      }</omdoc>
   )
   
   
   /* 
      The following are methods used for normalization, validation, and working with theory morphism.
      They constitute the core intelligence of theory graphs.
   */

   //checks if a path refers to an existing entity
   def validPath(p : Path) : boolean = {
      try {lib.getTheory(p); true} //p is a theory
      catch {case _ =>
         try {
            lib.getTheory(p/^).isDecl(p.name) // p is declaration within some theory (or not)
         }
         catch {case _ => false} //p is neither
      }
   }
   
   //Note: These methods are supposed to be called during parsing only. Therefore, it is not necessary to worry about a meta-theory not being a TheoryFull
   //combines a base path bs and a suffix suf in different ways to find a valid path
   def getPath(bs : Path, suf : String) : Option[Path] = {
      val p = bs/# suf
      if (validPath(p))
         //first choice: the natural bs/suf (This includes the case where suf is an absolute path.)
         return Some(p)
      //second (and recursively the n-th) choice: take the meta-theory of bs and try again
      //This means that names in a theory may shadow names of the meta-theory.
      val mth = try {lib.getTheory(bs).meta}
                catch {case _ => return None}
      if (mth != null)
         return getPath(mth, suf)
      //give up
      None
   }
   //checks whether path is a key symbol
   //to do: keys need to be normalized so that equality check succeeds when checking presence of attribution during presentation
   def validKey(path : Path) : boolean = {
      System.out.println("Warning: method validKey not implemented yet")
      true
   }
   
   //applies the identity to normalize
   def normalize(O : OMel) : OMel = {
      log("normalize: " + O.toString,1)
      apply(O,Identity)
   }
   
   //global view: applies a morphism, i.e., a path in the graph, to a term
   //local view: pushes a list of morphisms to the inside of a term collecting all OMMs on the way without resolving them;
   //            if an OMS is reached, resolve is called to eliminate the morphisms.
   //mutually recursive with resolve
   def apply(O : OMel, ref : Path) : OMel = apply(O, Morphism(List(ref)))
   def apply(O : OMel, via : Morphism) : OMel = {
      log("apply: " + via.toString + " to " + O.toNode.toString,1)
      val O2 = O match {
         case OMM(via2,arg) => 
            //collect morphisms while recursing
            apply(arg, via2 * via)
         case OMS(_) =>
            //wrap symbol in collected morphisms
            resolve(OMM(via,O))
         case OMA(f,args) => OMA(apply(f,via),args.map(apply(_,via)))
         case OME(e,args) => OMA(apply(e,via),args.map(apply(_,via)))
         case OMBIND(bi,vs,co,bo) => OMBIND(apply(bi,via),vs.map(apply(_,via).asInstanceOf[OMV]),apply(co,via),apply(bo,via))
         case OMV(_) | OMFOREIGN(_) | OMConst(_) => O
         case OMNone() => OMNone
      }
      val oldatts = O.getAttributions
      val newatts = oldatts.map({case (k,v) => applyToAttr(OMS(k),v,via)})
      //O2 has no attributions at this point
      O2.addAttributions(newatts)
   }
   
   private def applyToAttr(key : OMS, value : OMel, via : Morphism) : (Path,OMel) = {
      //check if attribution key is known to the theory graph, if not the attribution is not translated
      if (via != Identity && checkHome(lib.getLink(via.head).from,key)) {
         val newkey = apply(key,via)
         if (! newkey.isInstanceOf[OMS])
            throw (new Error("key " + key.toNode.toString + " not translated to symbol by " + via.toString))
         (newkey.asInstanceOf[OMS].path, apply(value,via))
      }
      else
         (key.path,value)
   }
      
   //global view: resolves the morphism in an OMM (defLink references are only resolved if necessary)
   //local view: finds the innermost thmLink and tries to apply it; if not possible, the outermost possible defLink (to the inside of the found thmLink)
   //            is resolved; if none can be resolved, Error is thrown
   //mutually recursive with apply
   //Note on complexity: Worst-case (= leading to the Error) number of lookups of a map for one call of resolve is quadratic in the number of DefLinks
   //                     to the inside of the innermost thmLink (linear here, and every linear in mapSuffix)
   def resolve(O : OMM) : OMel = {
      log("resolve: " + O.toNode.toString,1)
      val via = O.via
      val arg = O.arg
      //for now we only normalize terms, in particular arg is not supposed to be an import
      if (! getStatement(arg.asInstanceOf[OMS].path).isSymbolic)
         throw new MapError("is not a term: " + O)
      //get rid of special case
      if (via.isIdentity)
         return arg
      //check if the first link is applied to a meta-language symbol ... --- this part is still unclear
      val m = lib.getLink(via.head)
      if (checkHome(lib.getTheory(m.from).meta,arg)) {
         //... if so, replace it with its meta-morphism
         return resolve(OMM(m.meta * O.via.tail, arg))
      }
      //find the innermost thmLink, i.e., defLs ::: rest == via, nur definitional links in defLs, rest.head theorem link
      val (d,r) = via.refs.span(lib.getLink(_).tp != thmLink)
      var defLs = Morphism(d)
      var rest = Morphism(r)
      if (rest.isIdentity)
         //no thmLinks left, defLinks are kept even if they could be resolved
         OMMtoOMS(O)
      else {
         //invariant: O = OMM(rest,OMM(defLs,arg)); defLs ::: rest = via
         //simplification by applying the inner OMM (= the found thmLink)
         val errorMsg = "no map found when applying " + rest.head + " to " + O.toNode.toString
         var M : Option[Object] = None
         while (M.isEmpty) {
            //try to apply rest.head to OMM(defLs,arg)
            M = lib.getLink(rest.head).map(OMMtoOMS(OMM(defLs,arg)).path)
            if (M.isEmpty) {
                //if no map was found, the defLinks in defLs must be resolved
                //to keep as many unresolved as possible, this is done one at a time
                //starting at the outside of the term
                if (! defLs.isIdentity) {
                    //the outermost defLink in defLs is moved to the head of rest
                    //if this iteration tried to apply m to OMM(Morphism("m1 m2"),arg), the next one tries to apply m2 to OMM(Morphism("m1"),arg)
                    rest = new Morphism(defLs.last) * rest
                    defLs = defLs.init
                } else
                    // if there are no defLinks left, the found thmLink is not total
                    throw (new MapError(errorMsg))
            }
         }
         //now we have O = OMM(rest.head * rest.tail, OMM(defLs, arg.get)) = OMM(rest.tail, M.get)
         //simplification continues by calling apply again
         //cast succeeds because arg is guaranteed to be a term
         apply(M.get.asInstanceOf[OMel], rest.tail)
      }
   }
   //rewrites OMM(t_1#i_1 ... t_n#i_n, OMS(t#s)) into OMS(t_n#i_n/.../i_1/s)
   private def OMMtoOMS(O : OMM) : OMS = {
      O match {
         case OMM(Identity, OMS(p)) => OMS(p)
         case OMM(Morphism(via), OMS(p)) => OMS((via.last/^) /+ via.reverse.flatMap(_.flatname) /+ p.flatname)
         case _ => throw new MapError(O + " is not symbolic")
      }
   }
   
   //checks if N is a term over thid in context (= free variables) vars
   def checkHome(thid : Path, N : OMel) : boolean = checkHome(thid,N,Nil)
   def checkHome(thid : Path, N : OMel, vars : List[String]) : boolean = {
      //to do: this is just a hack to have omdocBase hardcoded
      if (thid == xml.omdocBase)
         return N == OMS(xml.omdocBase/#"presentation")
      log("checkHome: " + thid + " |- " + N.toNode.toString,1)
      val th = lib.getTheory(thid)
      //check value of those attributions of N for which key is known
      N.getAttributions.forall({case (key,value) => ! checkHome(thid,OMS(key),vars) || checkHome(thid,value,vars)}) &&
      //and check N itself
      (N match {
         case OMS(path) =>
             //a symbol is valid if it is defined in th or in a metatheory of th
             //if th is a subtheory, the declaration is th.meta after th are invalid
             th.isDecl(path.name) ||
             (th.subth && checkHome(th.meta, N, vars) && lib.getTheory(th.meta).isDeclBefore(path.name,thid.name))
             (! th.subth && checkHome(th.meta, N, vars))
         case OMV(name) =>
             //check if variable is in context
             vars.exists(_ == name)
         case OMM(Identity,arg) =>
            checkHome(thid, arg, vars)
         case OMM(via,null) =>
            //recurse over links in via, starting from the codomain
            val m = lib.getLink(via.last)
            //mValid means that m is link into th
            val mValid =
               //codomain of m must be thid
               m.to == thid
            //mValidMeta means that m is link into thid or a meta-theory of thid
            val meta = lib.getTheory(th.meta)
            val mValidMeta = mValid ||
               //th is a subtheory, and the last link in via is an import into th.meta declared before th
               (th.subth && lib.getLink(via.last).tp == defLink && meta.isDeclBefore(via.last.name, thid.name) && checkHome(meta.id, N, vars)) ||
               (! th.subth && checkHome(meta.id, N, vars))
            //if mValidMeta, also check that the rest of via is valid over the domain of m
            mValidMeta && checkHome(m.from, OMM(via.init,null), vars)
         case OMM(via,arg) =>
            //recurse over links in via, starting from the codomain
            val m = lib.getLink(via.last)
            //m must be a link into th && the rest of N must be valid over the domain of m
            checkHome(thid, OMM(new Morphism(m.id),null), vars) && checkHome(m.from, OMM(via.init,arg), vars)
            //Note: if, e.g., m0: T0 -> T1, m1: T1' -> T2, and T1 meta-language of T1', then m0, m1 composable (and T1 terms are also T1' terms)
         case OMA(f,a) =>
            //check all children
            (f::a).forall(checkHome(thid,_,vars))
         case OME(f,a) =>
            //check all children
            (f::a).forall(checkHome(thid,_,vars))
         case OMBIND(bi,bvs,co,bo) =>
            //local function for recursion over list of bound variables
            def step(l : List[OMV], ctx : List[String]) : boolean = l match {
               case Nil =>
                  //check condition and body (with all bound variables now in the context)
                  checkHome(thid,co,ctx) && checkHome(thid,bo,ctx)
               case hd :: tl => 
                 //check first variable, and then check rest with first variable moved to the context
                 checkHome(thid,hd,ctx) && step(tl, ctx ::: List(hd.name))
            }
            //check binder and then recurse over variables
            checkHome(thid,bi,vars) && step(bvs, vars)
         case _ => true //OMConst and OMFOREIGN
      })
   }
} //end DevGraph

