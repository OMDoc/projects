package omdoc
import scala.xml.{Node,Elem,UnprefixedAttribute,PrefixedAttribute}
import utils.{fromList}

object xml {
// forces the node N to have prefix p (useful because <{p}:... does not trigger XML mode)
def prefix(N : Node, p : String) : Node = Elem(p,N.label,N.attributes,N.scope,N.child : _*)

val omdocBase = Path(URI("http://ombase.omdoc.org/omdoc"), Nil, List("omdoc"))
val presentationKey = OMS(omdocBase/#"presentation")
val omHidden = OMS(omdocBase/#"hidden")

//splits whitespace-separted list of references to imports into components; and inverse
def splitList(l : String) : List[String] =
   //split by whitespace, removing leading and trailing whitespace
   l.split("\\s").toList.flatMap(s => if (s == "") Nil else List(s))
def unsplitList(l : List[String]) : String =
   l.map(_.toString).myFold("")(_ + " " + _)

//unescape /, \, and . in names
def nameUnescape(s : String) : String = s.replace("\\b","\\").replace("\\s","/").replace("\\d",".")

//check equality resolving the prefixes and comparing the namespaces
def equalWP(M : Node, N : Node) : boolean = (
      M.label == N.label
   && M.attributes == N.attributes
   && M.scope.getURI(M.prefix) == N.scope.getURI(N.prefix)
   && M.child.length == N.child.length
   && M.child.toList.zip(N.child.toList).forall(x => equalWP(x._1,x._2))
)

//common namespaces
def namespace (ns : String) : String =
   ns match {
      case "xml" => "http://www.w3.org/XML/1998/namespace"
      case "omdoc" => "http://www.mathweb.org/omdoc"
      case "visib" => namespace("omdoc")
      case "om" => "http://www.openmath.org/OpenMath"
      case "xhtml" => "http://www.w3.org/1999/xhtml"
      case "html" => "http://www.w3.org/TR/REC-html40"
      case "mathml" => "http://www.w3.org/1998/Math/MathML"
   }

//read and parse xml file or URI ignoring whitespace
def parseXML(filename : String) : Node = {
   val doc = scala.io.Source.fromFile(filename)
   val parse = scala.xml.parsing.ConstructingParser.fromSource(doc, false).document
   parse(0)
}

def parseXML(loc : URI) : Node = {
   val doc = scala.io.Source.fromURL(loc.uri)
   val parse = scala.xml.parsing.ConstructingParser.fromSource(doc, false).document
   parse(0)
}

//pretty-printed XML output
def printXML(N : Node) : String = {
   val pp = new scala.xml.PrettyPrinter(80,3)
   pp.format(N)
}

//get a path-named entity as a node
def omPathGet(context : Node, path : Path) : Node = {
   var N : Node = context
   (path.theories ::: List(path.name)).map(name => {
       val cs = N.child.filter(attr(_,"name") == name)
       if (cs.isEmpty)
          throw new Error("path not found: " + path)
       else
          cs(0)
   })
   N
}

//returns attribute value, "" if attribute not present
def attr(N : Node, att : String) : String = {
   val l = N.attribute(att).getOrElse(Nil).toList
   l.map(_.text).foldLeft("")(_ + _)
}

//returns attribute value as string, "" if attribute not present
//this method uses the namespace, not the prefix; dummy has to be passed for overloading resolution;
def attr(N : Node, namespace : String, att : String, dummy : boolean) : String = {
   val l = N.attribute(namespace,att).getOrElse(Nil).toList
   l.map(_.toString).foldLeft("")(_ + _)
}

//returns attribute value as string, "" if attribute not present
def attr(N : Node, pref : String, att : String) : String = {
   val l = N.attribute(N.scope.getURI(pref),att).getOrElse(Nil).toList
   l.map(_.toString).foldLeft("")(_ + _)
}

def recurseNode(N : Node, f : Node => Node) : Node =
   Elem(N.prefix, N.label, N.attributes, N.scope, N.child.map(f) : _*)

/*
//adds the children of N at the end of M
def joinNodes(M : Node, N : Node) : Node =
   Elem(M.prefix, M.label, M.attributes, M.scope, (M.child.toList ::: N.child.toList) : _*)

//adds N as a child to M
def addNodeFront(M : Node, N : Node) : Node =
   Elem(M.prefix, M.label, M.attributes, M.scope, (N :: M.child.toList) : _*)

def addNodeBack(M : Node, N : Node) : Node =
   Elem(M.prefix, M.label, M.attributes, M.scope, (M.child.toList ::: List(N)) : _*)

def dropNode(M : Node, test : Node => boolean) : Node =
   Elem(M.prefix, M.label, M.attributes, M.scope, (M.child.filter(x => ! test(x))) : _*)

*/ 
//adds or updates an unprefixed attribute value
def addAttr(N : Node, att : String, value : String) : Node = {
   val atts = N.attributes.remove(att).append(new UnprefixedAttribute(att,new scala.xml.Text(value),scala.xml.Null))
   Elem(N.prefix, N.label, atts, N.scope, N.child : _*)
}

//adds or updates a prefixed attribute value
def addPrefAttr(N : Node, pref : String, att : String, value : String) : Node = {
   val ns = new scala.xml.NamespaceBinding("dummy",pref,null)
   val atts = N.attributes.remove("dummy",ns,att).append(new PrefixedAttribute(pref,att,new scala.xml.Text(value),scala.xml.Null))
   Elem(N.prefix, N.label, atts, N.scope, N.child : _*)
}

}
