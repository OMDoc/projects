package omdoc.presentation
import scala.xml.{Node}
import xml.{attr}
import utils.{log}

class Database(lib : Library) {
   //A HashMap is used for symbol presentations, i.e., when two presentations apply to the same Context, the one parsed later takes precedence.
   private var presData = new scala.collection.mutable.HashMap[Context,Presentation]
   def addFiles(files : String*) {
      for (f <- files) {
         val N = xml.parseXML(f)
         var cdb = attr(N, "cdbase")
         if (cdb == "")
            cdb = attr(N, "xml", "id")
         val base = Parse.path(cdb, xml.omdocBase, lib)
         for (pres <- N\\"presentation") {
            addPresentation(pres, base)
         }
      }
   }
   def addPresentation(pres : Node, base : Path) {
      val (pc,p) = PresentationParser.parsePresentation(pres, base, lib)
      presData.update(pc,p)
   }
   //throw exception if no presentation is found
   def error(pc : Context) = Util.LookupError("no presentation found for: " + pc.toString)
   //look up the presentation by a presentation context pc
   //to do: lookup must also return morhism that is to applied to the found presentation
   def lookup(pcon : Context) : Presentation = {
      //here the parent of a path s is: S#c if s=T#i/c and dom(T#i)=S; the containing theory for local names; the meta-theory for theories
      def parent(pc : Context) : Context = {
         val path = pc.path
         if (path.isDocument || path == xml.omdocBase)
            //nothing to go up to
            throw (error(pcon))
         if (! path.isToplevel && path.isLocal)
            //containing theory
            return Context(pc.path/^,pc.role,pc.format)
         if (path.isLocal) {
            //metatheory
            val meta = lib.getTheory(pc.path).meta
            return Context(meta,pc.role,pc.format)
         }
         //take the import declared in the containing theory
         val imp = (path/^) /# path.flatname.head
         //take the domain and append the remaining local name
         val par = lib.getLink(imp).from /# path.flatname.tail
         Context(par, pc.role, pc.format)
      }
      //looks up a presentation in the database, continues with the parent if not found
      def lookupParent(pc : Context) : (Context, Presentation) = {
         //call the HashMap
         log("  looking up presentation: " + pc.toString,7)
         try {(pc, presData(pc))}
         catch {case _ =>
            //look up default presentation for arbitrary format
            try {(Context(pc.path,"", pc.format), presData(pc))}
            catch {case _ =>
            //if no presentation found, get presentation for parent
               lookupParent(parent(pc))
            }
         }
      }
      // get the presentation par for pcon or its closest parent pc; if no parent with appropriate presentation, throw error
      val l = try {lookupParent(pcon)} catch {case Util.LookupError(_) => throw (error(pcon))}
      var pc = l._1
      var p = l._2
      log("  found presentation: " + p.toString,6)
      //if p is incomplete, inherit the missing parameters from the parent
      while (p.isIncomplete) {
         log("  presentation incomplete",6)
         //get the presentation for the closest parent pc; if no more parent with appropriate presentation, throw error
         val l = try {lookupParent(parent(pc))} catch {case Util.LookupError(_) => throw (error(pcon))}
         pc = l._1
         val par = l._2
         //check if parent consists of a single ItemUse
         if (par.items.items.length == 1 && par.items.items(0).isInstanceOf[ItemUse]) {
            //if so, make p inherit from par
            log("  inherting from: " + par.toString,6)
            p = p.inheritFrom(par.items.items(0).asInstanceOf[ItemUse])
         } else
            //otherwise, throw error
            throw (error(pcon))
      }
      //if complete, return p
      p
   }
}