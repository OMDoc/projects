package omdoc
import utils.{log,fromList}

//Thrown by parsing methods (not all old uses of Error have been replaced by appropriate custom exceptions yet)
class ParseError(msg : String) extends java.lang.Throwable(msg)
class OutputError(msg : String) extends java.lang.Throwable(msg)

class Library {
   //the local cache of graphs
   private val graphs = new scala.collection.mutable.HashMap[Path,DevGraph]
   //look up graph in cache; if not present, download, parse and add to cache
   def getGraph(path : DocumentURI) : DevGraph = {
      try {graphs(path)}
      catch {case _ => 
         val N = try {xml.parseXML(path.cdbase.uri)}
         catch {case _ => throw new ParseError("problem occurred when retrieving " + path)}
         val graph = new DevGraph(N, path, this)
         graphs(graph.id) = graph
         graph
      }
   }
   def addGraph(graph : DevGraph) {
      graphs(graph.id) = graph
   }
   def getTheory(path : Path) : Theory = {
      val graph = getGraph(path/^^)
      graph.getTheory(path)
   }
   def getLink(path : Path) : Link = {
      val graph = getGraph(path/^^)
      graph.getLink(path)
   }
}


/* Semantics of Java string operations:
   pos = s.indexOf("/")
   s1 = s.substring(0,pos)
   s2 = s.substring(pos)
   splits s=a/b into s1=a and s2=/b
*/
object Parse {
   private def firstSlash(s : String) = s.indexOf("/")
   //parses smart syntax
   //ompath: URI to be parsed
   //base: path to a theory (!) that gives default document URI and theory path
   //lib: the library used to resolve prefixes of ompath to check whether they are valid
   def path(ompath : String, base : Path, lib : Library) : Path = {
      //check for naive syntax
      if (ompath.lastIndexOf("#") != -1) return Parse.path(ompath, base)
      //initialize for the case where ompath is local
      //invariant: locName is the local part of a name to be looked up in the theory graph at URI cdbase
      var cdbase = base.cdbase.uri
      var locName = ompath
      var pos = locName.lastIndexOf("://")
      //path will be the starting point from which the theory path is interpreted
      var path = if (pos != -1) {
         //if ompath is absolute, change values
         cdbase = ompath.substring(0,pos + 3)
         locName = ompath.substring(pos + 3)
         do {
         //here: cdbase + locName = ompath
         pos = firstSlash(locName)
            if (pos == -1) {
               if (locName == "")
                  throw (new ParseError("unparsable address: " + ompath))
               cdbase = cdbase + locName
               locName = ""
            } else {
               cdbase = cdbase + locName.substring(0,pos) //now cdbase + "/" + locName = ompath
               locName = locName.substring(pos + 1)
            }
         }
         //repeat until cdbase points to a theory graph
         while ( try {lib.getGraph(new DocumentURI(cdbase)); false} catch {case _=> cdbase += "/"; true} )
         //path points to the document explicitly identified by the first part of ompath
         new DocumentURI(cdbase)
      } else {
         //if ompath is document-local, check if it also theory-local
         if (locName == ".")
            //reference to the base theory itself; add "/" to unify treatment with the case where a local path follows
            locName += "/"
         if (locName.startsWith("./")) {
            //parse "./"
            locName = locName.substring(2)
            //theory-local ompath: path points to the therory identified by base
            base
         } else
            //document-local ompath: path points to the document given by base
            new DocumentURI(cdbase)
      }
      //repeat while we find theory names in ompath
      var repeat = locName != ""
      while (repeat) {
         pos = firstSlash(locName)
         val thy = if (pos == -1)
            {repeat = false; locName}
         else
            locName.substring(0,pos)
         try {
            lib.getTheory(path/thy)
            path = path/thy
            locName = if (pos == -1)
               ""
            else
               locName.substring(pos + 1)
         }
         //no more theory found
         catch {case _ => repeat = false}
      }
      if (locName == "")
         //whole ompath is parsed, i.e., no flatname component
         path
      else
         //append remaining part of ompath to path (this part is not checked against lib)
         path/# locName
   }      
   
   //parses cdbasei#mcd(cd)#mname(flatname), missing parts yield None
   def splitNaive(ompath : String) : (Option[String], Option[String], String) = {
      var omp = ompath
      //cdbase
      var pos = omp.indexOf("#")
      if (pos == -1)
         return(Some(omp),None,"")
      val cdbase = Some(omp.substring(0,pos))
      omp = omp.substring(pos)
      //theory path
      val theories = if (omp.startsWith("#mcd(")) {
         omp = omp.substring(5)
         pos = omp.indexOf(")")
         if (pos == -1)
            throw (new ParseError("unparsable address: " + ompath))
         val s = omp.substring(0,pos)
         omp = omp.substring(pos + 1)
         Some(s)
      } else
         None
      //flat name
      val flatname = if (omp.startsWith("#mname(")) {
         omp = omp.substring(7)
         pos = omp.indexOf(")")
         if (pos == -1)
            throw (new ParseError("unparsable address: " + ompath))
         omp.substring(0,pos)
      } else
         throw (new ParseError("unparsable address: " + ompath))
      (cdbase, theories, flatname)
   }
   //this determines how default values are inherited from base
   def inheritPath(p : (Option[String], Option[String], String), base : Path) : Path = {
      //omitted cdbase defaults to base.cdbase
      val cdbase = p._1.map(URI)getOrElse(base.cdbase)
      //omitted cd defaults to
      //  - Nil if cdbase present, or flatname starts with /
      //  - base.theories otherwise
      val cd = p._2.map(split).getOrElse(if (p._1.isEmpty && ! p._3.startsWith("/")) (base.theories ::: base.flatname) else Nil)
      val flatname = split(p._3)
      Path(cdbase, cd, flatname)
   }    
   def path(ompath : String) : Path = new DocumentURI(ompath)
   def path(ompath : String, base : Path) : Path = {
      inheritPath(splitNaive(ompath), base)
   }
   
   //splits t1/.../tn into List(t1,...,tn) and inverse
   def split(frag : String) : List[String] = {
      var comps = frag.split("/").toList
      //leading and trailing "/" are ignored
      if (comps != Nil && comps.last == "")
         comps = comps.init
      if (comps != Nil && comps.head == "")
         comps = comps.tail
      comps
   }
   def unsplit(names : List[String]) = names.myFold("")(_ + "/" + _)
}

class DocumentURI(uri : URI) extends Path(uri, Nil, Nil) {
   def this(uri : String) = this(URI(uri))
   override def toString = uri.toString
}

case class URI(uri : String) {
   override def toString = uri
   def toOMpath = toString
}

//only used for presentation
case class TheoryPath(p : Path) extends presentation.Presentable {
   def components = p.theories.map(s => new presentation.OutputText(xml.nameUnescape(s)))
}

//only used for presentation
case class FlatName(p : Path) extends presentation.Presentable {
   def components = p.theories.map(s => new presentation.OutputText(xml.nameUnescape(s)))
}

/*
   This class holds a reference to a named theory-constitutive element.
   cdbase: URI of the containing document
   theories: list of names of nested theories
   flatname: flat name, i.e., list of import names, and name of symbol, imports, axiom or theory starting in the innermost of the above theories
   theories == Nil and name == Nil for path of the document
   theories == Nil and name != Nil for paths of the toplevel statements
*/
case class Path(cdbase : URI, theories : List[String], flatname : List[String]) extends presentation.Presentable{
   //to do: eliminate all uses of null; use Nil in the future
   def isDocument = flatname == Nil
   def isToplevel = ! isDocument && theories == Nil
   def isLocal = flatname.length == 1
   
   def name : String =
      if (isDocument) throw (new Error("cannot take name of document path"))
         else flatname.last
   //For / and /#, "this" should refer to a theory
   //invariant: p/t_1 ... /t_n /^ ... /^ = p
   //appends to the theory path (see also object / below)
   def /(theos : String) : Path = /(Parse.split(theos))
   def /(theos : List[String]) : Path = 
      if (theos == Nil) this
         else Path(cdbase, theories ::: flatname ::: theos.init, List(theos.last))
   //invariant: (p/^)/#(p.flatname) = p
   //adds a flatname to a theory (see also object /# below)
   def /#(f : String) : Path = /#(Parse.split(f))
   def /#(f : List[String]) : Path = Path(cdbase, theories ::: flatname, f)
   //returns path to enclosing theory, i.e., goes up one level in Path space skipping all imports
   def /^ : Path =
      if (isToplevel || isDocument) new DocumentURI(cdbase)
         else Path(cdbase, theories.init, List(theories.last))
   //invariant: (p/^+)/(p.name) = p
   //as /# and /^, but considering the hierarchy of imports, i.e., appends to and removes from flatname
   def /+(suffix : String) : Path = /+(Parse.split(suffix))
   def /+(suffix : List[String]) : Path = Path(cdbase, theories, flatname ::: suffix)
   def /^+ : Path =
      if (isLocal) this/^
         else Path(cdbase, theories, flatname.init)
   //returns address of containing graph
   def /^^ = new DocumentURI(cdbase)
   
   //output routines
   private def thypath = xml.nameUnescape(Parse.unsplit(theories))
   private def flatpath = xml.nameUnescape(Parse.unsplit(flatname))
   //th_1/.../th_r/f_1/.../f_s/n
   private def fullpath = xml.nameUnescape(Parse.unsplit(theories ::: flatname))
   //cdbase#mcd(th_1/.../th_r)#mname(f_1/.../f_s/n)
   def toOMPathNaive : String =
      cdbase + (if (isDocument) "" else "#mcd(" + thypath + ")#mname(" + flatpath + ")")
   //cdbase/th_1/.../th_r/f_1/.../f_s/n
   def toOMPathSmart : String =
      cdbase + (if (isDocument) "" else "/" + fullpath)
   def toOMPath = toOMPathNaive
   //cdbase#xpointer(...), works only if name.lenght == 1
   def toXPointer : String = cdbase + (if (isDocument) "" else 
      "#xpointer(/omdoc" + theories.foldLeft("")(_ + "/theory[name=" + _ + "]") + "/" + "*" + "[name=" + name + "]" + ")")
   override def toString = toOMPathNaive
   
   //components of g/T_1/.../T_m#i_1/.../i_n/s are g, T_1/.../T_m, i_1, ..., i_n, s
   def components = new presentation.OutputText(cdbase.toOMpath) :: TheoryPath(this) :: 
      FlatName(this) :: Nil
}


//These objects defines methods to decompose a path for pattern matching.
//Thus base/#flatname and base/"name" are legal patterns.
//In both cases base must be a theory. In the second case, name may not contain slashes.
object / {
   def apply(base : Path, suffix : String) = base/suffix
   def unapply(path : Path) = if (path.isLocal) Some(path/^,path.name) else None
}
object /# {
   def apply(base : Path, suffix : List[String]) = base/#suffix
   def unapply(path : Path) = Some(path/^,path.flatname)
}

object noPath extends DocumentURI(null : URI) {
   override def /(suffix : String) : Path = throw new Error("cannot construct path relative to noPath")
   override def /^ : Path = Path(null,Nil,Nil)
}