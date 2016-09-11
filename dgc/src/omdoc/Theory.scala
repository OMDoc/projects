package omdoc
import scala.xml.{Node}
import xml.{attr}
import utils.{log}
import scala.collection.mutable.{HashMap}

/*
  Classes for the theory-constitutive statements.
*/
abstract class Statement(val path : Path) extends presentation.Presentable {
   def components : List[presentation.Presentable] = List(path)
   def isSymbolic : boolean = false
   def isDeclarative : boolean = false
}
case class SymDecl(override val path : Path, tp : OMel, var defin : OMel) extends Statement(path) {
   override def components = super.components ::: List(tp, defin)
   override def isSymbolic = true
   override def isDeclarative = true
}
case class AssDecl(override val path : Path, formula : OMel, var proof : OMel) extends Statement(path) {
   override def components = super.components ::: List(formula, proof)
   override def isSymbolic = true
   override def isDeclarative = true
}
case class SymDef(override val path : Path) extends Statement(path) {}
case class AssDef(override val path : Path) extends Statement(path) {}
case class ImpDecl(link : Link) extends Statement(link.id) {
   override def components = super.components ::: List(link.from, link.meta) ::: link.getMaps
   override def isDeclarative = true
}
case class VwDecl(link : Link) extends Statement(link.id) {
   override def components = super.components ::: List(link.from, link.to, link.meta) ::: link.getMaps
}
case class ThDecl(theory : Theory) extends Statement(theory.id) {
   override def components = super.components ::: List(theory.meta) ::: theory.getDeclarations
}

//The role of a symbol; defaulting to "constant"
object Role {
   def parse(s : String) : Role = {
      s match {
         case "" | "constant" => RoleConstant
         case "attribution" => RoleKey(false)
         case "semantic-attribution" => RoleKey(true)
         case "application" => RoleApplication
         case "binder" => RoleBinder
         case "error" => RoleError
         case _ => RoleError // TODO: correct roles; throw new ParseError("illegal role: " + s)
      }
   }
}

//Note: So far roles are not used, except for making sure that keys are always symbols
abstract class Role {
   //checks whether this instance maybe used with role r (note the subtle differences to the OpenMath standard)
   def isLegal(r : Role) : boolean
}
case class RoleConstant extends Role {
   def isLegal(r : Role) = r == RoleConstant
   override def toString = "constant"
}
case class RoleKey(semantic : boolean) extends Role {
   def isLegal(r : Role) = r.isInstanceOf[RoleKey]
   override def toString = if (semantic) "semantic-attribution" else "attribution"
}
case class RoleApplication extends Role {
   def isLegal(r : Role) = r == RoleConstant || r == RoleApplication
   override def toString = "application"
}
case class RoleBinder extends Role {
   def isLegal(r : Role) = r == RoleConstant || r == RoleBinder
   override def toString = "binder"
}
case class RoleError extends Role {
   def isLegal(r : Role) = r == RoleError
   override def toString = "error"
}
case class RoleNone extends Role {
   def isLegal(r : Role) = r == RoleConstant || r == RoleApplication || r == RoleBinder
   override def toString = null
}

/* 
   This class holds a theory.
   graph: A theory can call back to the development graph.
   Invariant: A theory is immutable.
*/
class Theory private (graph : DevGraph) {
   private var idVar : Path = null
   def id : Path = idVar
   private var metaVar : Path = null
   def meta : Path = metaVar
   private var subthVar : boolean = false // true if subtheory (of meta); false if toplevel theory (in graph)
   def subth = subthVar
   //statements and lookup must be kepts synchronous
   private var statements : List[Statement] = Nil // the sequence of statements
   private val lookup = new HashMap[String,Statement] //maps names efficiently to their statements
   private val roles = new HashMap[String,Role] //maps symbol name to role (total)

   /*
      N: node from which the theory is parsed
      graph: the graph in which the theory is a node
      base: containing document or containing theory
      addPresentation: callback method for presentations
   */
   def this (N : Node, graph : DevGraph, base : Path, addPresentation : (Node, Path) => Unit) {
      this(graph)
      //add theory to graph right away so that everything declared in the following is immediately available for validity checking
      idVar = base/attr(N,"name")
      graph.addTheory(this)
      log("Processing theory " + id.toString,0)
      //this is a subtheory iff the base is another theory and not a document
      subthVar = ! base.isDocument
      //set meta-language
      if (subth)
         metaVar = base
      else {
         val mt = attr(N,"meta")
         metaVar = if (mt == "")
            //default to omdocBase
            xml.omdocBase
         else
            //meta must be given relative to document base, it is parsed using lib
            Parse.path(mt, base, graph.lib)
      }
      log("  meta-language: " + meta,0)
      //construct import from the metatheory
      val metaimp = new Link(graph, id, meta)
      graph.addLink(metaimp)
      addDecl("..", ImpDecl(metaimp))
      //get theory-constitutive elements
      for (n <- N.child) {
         n.label match {
            case "symbol" =>
               val name = attr(n,"name")
               checkNew(name, n)
               val cid = id/# name
               log("  processing symbol " + cid.toString,0)
               val tps = (n\"type"\"OMOBJ").toList
               val tp = if (tps.isEmpty) 
                  OMNone
               else {
                  val tp = OMel.parse(tps(0), graph.lib, id)
                  log("    found type: " + tp.toString,0)
                  tp
               }
               val dec = SymDecl(cid, tp, OMNone)
               addDecl(name, dec)
               //parse roles
               val rl = Role.parse(attr(n,"role"))
               log("    found role: " + rl.toString,0)
               roles(name) = rl
            case "assertion" =>
               val name = attr(n,"name")
               checkNew(name, n)
               val cid = id/# name
               log("  processing axiom " + cid.toString,0)
               val fmp = OMel.parse((n\"FMP"\"OMOBJ")(0), graph.lib, id)
               log("    fmp: " + fmp.toString,0)
               val dec = AssDecl(cid, fmp, OMNone)
               addDecl(name, dec)
            case "definition" =>
               val name = attr(n,"for")
               val dec = try {lookup(name).asInstanceOf[SymDecl]}
               catch {case _ => throw new ParseError("definition of undeclared symbol: " + n)}
               val defin = OMel.parse((n\"OMOBJ")(0), graph.lib, id)
               //update existing symbol declaration
               dec.defin = defin
               //keep track of when the definition occured
               statements = statements ::: List(SymDef(id/#name))
               log("  found definition for " + name + " " + defin.toString,0)
            case "proof" =>
               val name = attr(n,"for")
               val dec = try {lookup(name).asInstanceOf[AssDecl]}
               catch {case _ => throw new ParseError("proof of unstated assertion: " + n)}
               val proof = OMel.parse((n\"OMOBJ")(0), graph.lib, id)
               //update existing assertiond declaration
               dec.proof = proof
               //keep track of when the proof occured
               statements = statements ::: List(AssDef(id/#name))
               log("  found proof for " + name + " " + proof.toString,0)
            case "imports" =>
               val name = attr(n,"name")
               val cid = id/# name
               log("  processing import " + cid.toString,0)
               val li = new Link(n, graph, id, true)
               //add definitional links to graph and to theory
               graph.addLink(li)
               addDecl(name, ImpDecl(li))
               //add symbols and definitions for all includes (including all symbols not done yet)
               for (inc <- n\"includes") {
                  val nm = attr(inc,"name")
                  var as = attr(inc,"as")
                  if (as == "") as = nm
                  log("    includes " + nm + " as " + as,0)
                  val dec = SymDecl(id/#as, OMNone, OMS(id/#nm))
                  addDecl(as, dec)
               }
            case "theory" =>
               val name = attr(n,"name")
               checkNew(name, n)
               val cid = id/name
               log("  processing subtheory " + cid.toString,0)
               //construct theory recursively
               val th = new Theory(n, graph, id, addPresentation)
               //th has already added itself to the graph, add it to this theory
               addDecl(name, ThDecl(th))
            case "presentation" =>
               addPresentation(n, id)
            case _ => ()
         }
      }
   }
   
   //checks whether a symbol assetion name is legal
   private def checkNew(name : String, n : Node) {
      if (name == "")
         throw (new ParseError("no name given in " + n.toString))
      if (isDecl(name))
         throw new ParseError("declaration of declared name: " + n)
   }
   
   private def addDecl(name : String, dec : Statement) {
      statements = statements ::: List(dec)
      lookup(name) = dec
   }
   
   def getDeclarations : List[Statement] =
      statements
   def getStatement(p : Path) : Statement = {
      if (((p/^) != id) || p.isToplevel)
         throw RefError(p + " not valid over " + id)
      if (p.isLocal)
         //look up locally
         return lookup(p.name)
      //look up first import locally, take its domain, and look up remaining path there
      lookup(p.flatname.head) match {
         case ImpDecl(link) => getTheory(link.from).getStatement(link.from /# p.flatname.tail)
         case _ => throw RefError(p + " not valid over " + id)
      }
   }
   
   def isSymbol(name : String) : boolean =
      try {lookup(name).asInstanceOf[SymDecl]; true}
      catch {case _ => false}

   def isImports(name : String) : boolean =
      try {getImports(name); true}
      catch {case _ => false}

   //to do: make this more efficient
   def isDecl(name : String) : boolean =
      statements.exists(_.path.name == name)

   //checks whether name is a declaration and return that; if cutoff given, also check that name is declared before and excluding cutoff
   def isDeclBefore(name : String, cutoff : String) : boolean = {
      def recurse(d : List[Statement]) : boolean = d match {
         case hd :: tl => hd match {
            case _ if hd.path.name == name => true
            case _ if hd.path.name == cutoff => false
            case _ => recurse(tl)
         }
         case Nil => false
      }
      recurse(statements)
   }

   def typeOf(name : String) : Option[OMel] = 
      try {Some(lookup(name).asInstanceOf[SymDecl].tp)}
      catch {case _ => None}

   def definitionOf(name : String) : Option[OMel] = 
      try {Some(lookup(name).asInstanceOf[SymDecl].defin)}
      catch {case _ => None}
   
   //checks whether symbol name is allowed with role rl
   def isLegalRole(name : String, rl : Role) : boolean =
      roles(name).isLegal(rl)
   
   //call backs to containing graph for access to theories or links
   def getImports(name : String) : Link = 
      graph.lib.getLink(id/#name)
   def getTheory(name : String) : Theory = 
      graph.lib.getTheory(id/name)
   def getTheory(path : Path) : Theory = 
      graph.lib.getTheory(path)

   def toNode : Seq[Node] = scala.xml.Utility.trim(
      <theory name={id.name} meta={if (subth) null else meta.toOMPath}>
      {
         for (d <- statements) yield
             d match {
                case SymDecl(p,tp, _) =>
                   <symbol name={p.name} role={roles(p.name).toString}>
                   {
                      if (tp == OMNone)
                         Nil
                      else
                         <type>{tp.toOBJNode}</type>
                   }
                   </symbol>
                case AssDecl(p, fmp, _) =>
                   <assertion name={p.name}>
                      <FMP>
                         {fmp.toOBJNode}
                      </FMP>
                   </assertion>
                case SymDef(p) =>
                   <definition for={p.name} type="simple">
                      {lookup(p.name).asInstanceOf[SymDecl].defin.toOBJNode}
                   </definition>
                case AssDef(p) =>
                   <proofobject for={p.name}>
                      {lookup(p.name).asInstanceOf[AssDecl].proof.toOBJNode}
                   </proofobject>
                case ImpDecl(link) =>
                   link.toNode
                case ThDecl(th) =>
                   th.toNode
             }
      }
      </theory>
      )
}