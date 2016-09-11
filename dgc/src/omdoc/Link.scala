package omdoc
import scala.xml.{Node}
import xml.{attr}
import utils.{log}

abstract class LinkType
case class defLink extends LinkType {
   override def toString = "definitional"
}
case class thmLink extends LinkType {
   override def toString = "theorem"
}

abstract class Map(val of : Path, val to : Object) extends presentation.Presentable {
   def components : List[presentation.Presentable] = of.flatname.map(new presentation.OutputText(_)) ::: List(to)
}
case class SymMap(override val of : Path, override val to : OMel) extends Map(of, to)
case class AssMap(override val of : Path, override val to : OMel) extends Map(of, to)
case class ImpMap(override val of : Path, override val to : Morphism) extends Map(of, to)

/*
   The class for links, i.e., elementary morphisms, i.e., imports or theory-inclusion elements
   id: reference of the link
   tp: type (definitional or theorem)
   from, to: domain and codomain
   scope: local or global
   meta: a theory morphism from the meta-theory of the domain, if any, into the codomain (or one of its meta-theories)
   maps: the morphism itself
      (m,Some(im)): m \mapsto im
      (m,None): m is hidden
      no (m,_): m is imported (illegal for theorem links)
      (m,a) and (m,b): the earlier one is ignored
      (m,a) and (m/m',b): the latter, more specific map is prefered
   hideafter: true for metatheory imports into subtheories; in this case everything declared after the codomain must be hidden
*/
class Link private (graph : DevGraph) {
   private var idVar : Path = null
   def id = idVar
   private var tpVar : LinkType = null
   def tp = tpVar
   private var fromVar : Path = null
   def from = fromVar
   private var fromth : Theory = null
   private var toVar : Path = null
   def to = toVar
   private var maps : List[Map] = Nil
   //val lookup = new scala.collection.mutable.HashMap[Path,Object]
   private var metaVar : Morphism = Identity
   def meta = metaVar
   //
   private var hideafter = false

   //constructor for definitional links, fourth argument is only for overloading resolution
   def this(N : Node, graph : DevGraph, base : Path, dummy : boolean) = {
      this(graph)
      idVar = base/#attr(N,"name")
      tpVar = defLink
      toVar = base
      commonPart(N, graph, base)
   }
   //constructor for theorem links
   def this(N : Node, graph : DevGraph, base : Path) = {
      this(graph)
      idVar = base/#attr(N,"name")
      tpVar = thmLink
      toVar = Parse.path(attr(N,"to"), base, graph.lib)
      commonPart(N, graph, base)
   }
   //constructor for links from the metatheory
   def this(graph : DevGraph, thid : Path, meta : Path) = {
      this(graph)
      idVar = thid/#".."
      tpVar = defLink
      fromVar = meta
      fromth = graph.lib.getTheory(meta)
      toVar = thid
      metaVar = new Morphism(thid/#"../..")
      if (! thid.isToplevel)
         hideafter = true
   }

   //common code of the two parsing constructors
   private def commonPart(N : Node, graph : DevGraph, base : Path) {
      fromVar = Parse.path(attr(N,"from"), base, graph.lib)
      fromth = try {graph.lib.getTheory(from)}
         catch {case _ => throw new ParseError("unknown domain theory: " + from)}
      metaVar = OMel.parseMorphism(attr(N,"meta"), graph.lib, base)
      //parse maps
      val insts = N\"instantiation"
      if (! insts.isEmpty) {
         val maps = insts(0)
         log("    processing instantiation: " + maps.toString,0)
         for (r <- maps.child) {
            //parsing map from s to im; automatically setting base reference
            val p = Parse.path(attr(r(0),"path"), from, graph.lib)
            val dec = try {fromth.getStatement(p)}
               catch {case _ => throw new ParseError("map for undeclared name " + p + " in: " + N)}
            dec match {
               case SymDecl(_,_,_) =>
                  val im = if (r.label == "hides") xml.omHidden
                     else OMel.parse(r.child(0), graph.lib, to)
                  addMap(SymMap(p,im))
               case AssDecl(_,_,_) =>
                  val im = if (r.label == "hides") xml.omHidden
                     else OMel.parse(r.child(0), graph.lib, to)
                  addMap(AssMap(p,im))
               case ImpDecl(_) =>
                  val im = OMel.parseMorphism(r.child(0), graph.lib, to)
                  addMap(ImpMap(p,im))
               case _ => throw new ParseError("map of non-declarative name: " + p + " in " + N)
            }
         }
      }
      log("  found " + toString,0)
   }
   private def addMap(m : Map) {
      maps = maps ::: List(m)
      log("      found map for " + m.of.toString + ": " + m.to.toString,0)
   }
   def getMaps = maps
   
   //textual description
   override def toString = {
      tp.toString + " link " + id.toString + " from " + from.toString + " to " + to.toString
   }
   
   //print as OMDoc
   def toNode : Node =
      if (tp == defLink)
         <imports name={id.name} from={from.toOMPath} meta={meta.toOMPath}>
            <instantiation>{mapsToNode}</instantiation>
         </imports>
      else
         <view name={id.name} from={from.toOMPath} to={to.toOMPath} meta={meta.toOMPath}>
            <instantiation>{mapsToNode}</instantiation>
         </view>

   def mapsToNode : Seq[Node] =
      for (r <- maps) yield r match {
         case SymMap(of, to) =>
            <maps path={of.toOMPath}>
               {to.toOBJNode}
            </maps>
         case AssMap(of, to) =>
            <maps path={of.toOMPath}>
               {to.toOBJNode}
            </maps>
         case ImpMap(of, to) =>
            <maps path={of.toOMPath}>
               {to.toOBJNode}
            </maps>
      }

   /* A morphism may map a whole imports element instead of just a single symbol; thus there may be several ways to specify the same map;
      thus all prefixes must be checked.
      Assume p = from#i_1/.../i_n/s. If there is no map for p, look for a map m for from#i_1/.../i_n
      and return OMM(m,S#s) where S is the domain of from#i_1/.../i_n.
      If no map is found for any prefix, to#id.name/i_1/.../i_n/s is returned.
   */
   def lookup(p : Path) : Option[Object] = {
      maps.find(_.to == p).map(_.to)
   }
   def map(p : Path) : Option[Object] = {
      log("checking for map of " + p.toString,2)
      val dec = try {fromth.getStatement(p)}
         catch {case _ => throw new MapError(p + " not valid over " + from)}
      if (! dec.isDeclarative)
         throw new MapError(p + " not mappable via " + id)
      //everything declared in fromth after the theory to is declared is hidden
      if (hideafter && ! fromth.isDeclBefore(dec.path.flatname.head, to.name))
         return Some(xml.omHidden)
      val O = lookup(p)
      if (O.isDefined) {
         //map found
         log("  found map: " + O.get.toNode.toString,2)
         O
      } else {
         //no map for p found, go up in the flat name
         if (! p.isLocal) {
            val imp = p/^+
            val pfrom = graph.lib.getLink(imp).from/#(p.name)
            //map the import, result must be Morphism
            val mi = map(imp).asInstanceOf[Morphism]
            //apply it to the imported declaration; return None if mi == None
            if (dec.isSymbolic)
               Some(mi.applyTo(OMS(pfrom)))
            else
               Some(mi * pfrom)
         } else
            //no going up possible, thus no map found
            None
      }
   }
}