package omdoc
import scala.xml.{Elem, Node, Text} 
import xml.attr
import utils.{log}

/* class for symbols in the flattened theory
m: Mappable by splitting <OMM via="#imp1 ... #impn"><OMS cd="thid" name="n">
for <symobl> and <definition> tp: type, df: definition
for <axiom> and <assertion> (via judgments-as-types paradigm) tp: theorem, df: proof
df2: if a defined symbol is mapped by an <imports>, df2 will be the translated definition and df the map by the <imports>; otherwise, df2 is None
     if df2 is present, df and df2 must be equal (which cannot be tested on the OMDoc level)
*/
case class FlatSymbol(val m : Path, val tp : Option[OMel], val df : Option[OMel], val df2 : Option[OMel], var comment : Option[String])
   extends presentation.Presentable {
   //convenience constructors with some arguments omitted
/*   def this(m : Mappable, tp : Option[OMel], df : Option[OMel], df2 : Option[OMel]) = this(m,tp,df,df2,None)*/ //seems to break compiler
   def this(m : Path, tp : Option[OMel], df : Option[OMel]) = this(m,tp,df,None,None)
   def this(m : Path, tp : Option[OMel], df : Option[OMel], comment : Option[String]) = this(m,tp,df,None,comment)
   def components : List[presentation.Presentable] = 
      List(OMS(m),tp.getOrElse(OMNone), df.getOrElse(OMNone), df2.getOrElse(OMNone))
}

class Flattener (context : Node, base : Path, lib : Library, addPresentation : (Node, Path) => Unit) extends DevGraph(context, base, lib, addPresentation)  {

   /* These data structures cache the flattened theories, assigning to every theory id its list of flattened symbols.
      Imported and local axioms are distinguished because they are treated differently when importing from the theory.
      In these data structures, tp and df are always normalized.
   */
   val flattenedNodesSymbols = new scala.collection.mutable.HashMap[Path,List[FlatSymbol]]     //all symbols and definitions
   val flattenedNodesImpAxioms = new scala.collection.mutable.HashMap[Path,List[FlatSymbol]]   //imported axioms
   
   //applies the <imports> id to the imported FlatSymbol s returning the FlatSymbol with its new name and translated tp and df
   private def translate(s : FlatSymbol, id : Path) : FlatSymbol = {
      val m = id /+ s.m.flatname
      log("translate " + s.toString + " via " + id.toString, 2)
      val tp = s.tp.map(apply(_,id))   // apply includes normalization
      val df = s.df.map(apply(_,id))
      new FlatSymbol(m, tp, df, None, s.comment)
   }
   
   //fills the cache with the flattening of a theory
   def flattenNode(thid : Path) : Unit = {
   log("flattening theory " + thid,2)
   //check if result already cached
   if (flattenedNodesSymbols.isDefinedAt(thid)) return ()
   val th = lib.getTheory(thid)
   //these var's carry the flattening locally
   var resSymb, resA : List[FlatSymbol] = Nil
   for (s <- th.getDeclarations) {
      s match {
         case SymDecl(path, _, _) =>
            val name = path.name
            //a local symbol of thid (type and definition are normalized)
            log("local symbol " + path,2)
            val d = new FlatSymbol(path, th.typeOf(name).map(normalize _), th.definitionOf(name).map(normalize _))
            resSymb = resSymb ::: List(d)
         case AssDecl(path, _, _) =>
            val name = path.name
           //a local axiom of thid
            log("  local axiom " + path,2)
            val fmp = normalize(th.typeOf(name).get) //to do: check with Theory.typeOf
            val d = new FlatSymbol(path, Some(fmp), None)
            resA = resA ::: List(d)
         case ImpDecl(imp) =>
            val id = imp.id
            log("  imports " + id,2)
            //the imported symbols via id
            for (s <- flattenedNodesSymbols.apply(imp.from)) {
               log("  imported symbol " + s.m.toString,2)
               val t = translate(s,id)   //the translation of s
               val map = imp.map(s.m) //the map of s by imp (if any)
               if (map.isEmpty) {
                  //if s is not mapped, use t
                  resSymb = resSymb ::: List(t)
               } else {
                  log("    symbol also mapped",2)
                  if (! t.df.isEmpty) log("  equality check needed",2)
                  //if s is mapped, use t, but coerced to be equal to map.
                  //If t already had a definition, map and t.df must be equal.
                  resSymb = resSymb ::: List(new FlatSymbol(t.m, t.tp, map.asInstanceOf[Option[OMel]], t.df, t.comment))
               }
            }
            //the imported axioms via id
            for (s <- flattenedNodesImpAxioms.apply(imp.from)) {
               log("  imported imported axiom " + s.m.toString,2)
               resA = resA ::: List(translate(s,id))
            }
      }
    }
   flattenedNodesSymbols.update(thid,resSymb)
   flattenedNodesImpAxioms.update(thid,resA)
   log("",2)
}

//flatten all theories of the graph (theories must appear in propber order)
def flattenGraph {
   for (dec <- statements) dec match {
      case ThDecl(th) => flattenNode(th.id)
      case _ =>
   }
}
}

//what about theorems???