package jomdoc.objects
import scala.xml.{Node}
import jomdoc.xml.{attr}
import jomdoc.utils.{log}
import jomdoc.names.{Path}

//parsing methods for class OMel
object Obj {
   private def newBase(N : Node, base : Path) : Path =
      if (N.attribute(mmtbaseattr).isDefined)
         Path.parse(attr(N,mmtbaseattr), base)
      else
         base
   //name of the attribute giving the default value for cdbase and cd
   private val mmtbaseattr = "mmtbase"

   //base: base reference, may be set by any OMel during parsing
   //graph: Graph sed to interpolate and validate paths (may be null)
   def parse(N : Node, base : Path) : Obj = parse(N, base, None)
   def parseTerm(N : Node, base : Path, lib : Some[Library]) : Term = {
      //N can set local cdbase attribute; if not, it is copied from the parent
      val nbase = newBase(N,base)
      N match {
         case <OMS/> =>
            val cdbase = if (N.attribute("cdbase").isDefined)
               Some(attr(N,"cdbase")) else None
            val cd = if (N.attribute("cd").isDefined)
               Some(attr(N,"cd")) else None
            val name = if (N.attribute("name").isDefined)
               attr(N,"name") else throw (new ParseError("no name in " + N.toString))
            val p = Parse.inheritPath((cdbase, cd, name), nbase)
            if (lib.isDefined) {
               lib.get.validatePath(p)
            }
            if (cdbase == jomdoc.mmt.omdocbase)
               throw new ParseError("No arguments given: " + N.toString)
            OMS(p)
         case <OMV/> =>
            OMV(attr(N,"name"))
         case <OMA>{jomdoc.mmt.morphismapplication}{argument}{morphism}</OMA> =>
            val arg = parseTerm(argument, nbase, lib)
            val mo = parseMorphism(morphism, nbase, lib)
            OMM(arg, mo)
         case <OMA>{child : _*}</OMA> =>
            if (child.length <= 1)
               throw new ParseError("No arguments given: " + N.toString)
            val ch = child.toList.map(parseTerm(_, nbase, lib))
            OMA(ch.head,ch.tail)
         case <OME>{child : _*}</OME> =>
            val ch = child.toList.map(parseTerm(_, nbase, lib))
            OME(ch.head,ch.tail)
         case <OMBIND>{child : _*}</OMBIND> =>
            val binder = parseTerm(ch(0), nbase, lib)
            val vars = ch(1).child.map(parseTerm(_, nbase, lib)).toList        //parse all OMVs, OMBVAR is skipped
            if (vars.exists(! _.isVariable) || vars.isEmpty)
               throw new ParseError("Not a list of variables: " + vars.toString)
            //if there are 4 children, the third one is the condition
            val condition = if (ch.length == 4)
               Some(parseTerm(ch(2), lib, base))
            else
               None
            val body = parseTerm(ch.last, lib, base)
            OMBIND(binder, vars, condition, body)
         case <OMATTR><OMATP>{key}{value}</OMTAP>{attrs : _*}{arg}</OMATTR> =>
            //parse attributed object
            val k = parseTerm(key, nbase,lib)
            val v = parseTerm(value, nbase,lib)
            val next = if (attrs.isEmpty) parseTerm(arg, nbase,lib)
               else parseTerm(<OMATTR>{attrs}{arg}</OMATTR>, nbase, lib)
            OMATTR(next, k, v)
         case <OMFOREIGN>{_*}</OMFOREIGN> => OMFOREIGN(N)
         case <OMI>{i}</OMI> =>
            OMConst(i.toString.toInt)
            //to do case OMConst
         case <OMOBJ>{o}</OMOBJ> => parseTerm(o, nbase, lib)
         case _ => throw (new ParseError("not a well-formed term: " + N.toString))
      }
   }
   
   def parseMorphism(N : Node, base : Path, lib : Some[Library]) : Morph = {
      //N can set local cdbase attribute; if not, it is copied from the parent
      val nbase = newBase(N,base)
      N match {
         case <OMS/> =>
            val cdbase = if (N.attribute("cdbase").isDefined)
               Some(attr(N,"cdbase")) else None
            val cd = if (N.attribute("cd").isDefined)
               Some(attr(N,"cd")) else None
            val name = if (N.attribute("name").isDefined)
               attr(N,"name") else throw (new ParseError("no name in " + N.toString))
            val p = Path.inherit((cdbase, cd, name), nbase)
            if (lib.isDefined) {
               lib.get.validatePath(p)
            }
            OMLINK(p)
         case <OMA>{jomdoc.mmt.composition}{links : _*}</OMA> if links != Nil =>
            val li = links.map(parseMorphism(_, nbase, lib))
            OMCOMP(li)
         case <OMA>{jomdoc.mmt.identity}{th}</OMA> =>
            val theory = parseTerm(th, nbase, lib)
            if (! theory.isInstanceOf[OMS])
               throw new ParseError("Not atomic: " + theory.toString)
            if (lib.isDefined & ! lib.isTheory(theory.asInstanceOf[OMS].path))
               throw new ParseError("Not a valid theory: " + theory.toString)
            OMIDENT(theory.asInstanceOf[OMS].path)
         case _ =>  throw (new ParseError("not a well-formed morphism: " + N.toString))
      }
   }
}

/*
  Obj: An object
    - printing, component computation done in class OMel for uniform treatment of attributions
    - OMS and OMM contain references (Path elements)
    - attributions are normalized, and stored separately (i.e., there is no case class OMATTR extends OMel)
    - OMels are immutable except for adding attributions
*/
//to do: check equality by checking object and all semantic attributions
//Object unites OMel (terms) and Morphism
abstract class Obj extends presentation.Presentable {
//prints to OpenMath (without OMOBJ wrapper)
   def toOBJNode = <OMOBJ>{toNode}</OMOBJ>
   def toNode : scala.xml.NodeSeq = {
      val body = this match {
         case OMS(Path(cdbase,cd,name)) => <om:OMS cdbase={cdbase.toString} cd={cd.toString} name={name.toString}/>
         case OMV(name) => <om:OMV name={name}/>
         case OMA(function, arguments) => <om:OMA>{function.toNode}{arguments.map(_.toNode)}</om:OMA>
         case OME(error, arguments) => <om:OME>{error.toNode}{arguments.map(_.toNode)}</om:OME>
         case OMBINDC(binder, variables, condition, body) =>
            <om:OMBIND>{binder.toNode}<om:OMBVAR>{variables.map(_.toNode)}</om:OMBVAR>{if (condition.isDefined) condition.get.toNode}{body.toNode}</om:OMBIND>
         case OMATTR(term, key, value) =>
            <om:OMATTR><om:OMATP>{key.toNode}{value.toNode}</om:OMATP>{term.toNode}</om:OMATTR>
         case OMM(argument, morphism) => <om:OMA>{jomdoc.mmt.morphismapplication}{argument.toNode}{morphism.toNode}</om:OMA>
         case OMFOREIGN(node) => node
         case OMConst(c) => <om:OMConst>{c.toString}</om:OMConst> //to do: correct OpenMath syntax
         case OMCOMP(morphisms) => <om:OMA>{jomdoc.mmt.composition}{morphisms.map(_.toNode)}</om:OMA>
         case OMIDENT(path) => <om:OMA>{jomdoc.mmt.identity}{OMS(path).toNode}</om:OMA>
         case OMLINK(path, _, _) => OMS(path).toNode
      }
   }
}

abstract class GTerm extends Obj {
   def isVariable = false
   def strip = this
   def copy : Term
}
case class OMHid extends GTerm
case class OMUnd extends GTerm
abstract class Term extends GTerm

abstract class Morph extends Obj {
   //application
   def applyTo(O : Term) = OMM(O,this)
   def applyTo(M : Morph) = M * this
   //* is composition in diagrammatic order
   def *(that : Morph) = OMCOMP(List(this, that))
   //convenience methods for composed morphisms
   def head : Morph
   def last : Morph
   def init : Morph
   def tail : Morph
   def length : Int
   def isIdentity = length == 0
}

//symbols
case class OMS(path : Path) extends Term {
   def name = path.name
   def cd = path/^
   def copy = OMS(path)
   def components = path.components
}

//bindings, variables may not be the empty list, elements must be variables
case class OMBINDC(binder : Term, variables : List[Term], condition : Option[Term], body : Term) extends Term  {
   //constructor for omitted condition
   def components = binder :: variables ::: (if (condition.isDefined) List(condition.get) else Nil) ::: List(body)
   def copy = OMBIND(binder, variables, condition, body)
}

case class OMBIND(binder : Term, variables : List[Term], body : Term) extends OMBINDC(binder, variables, None, body) {
   //constructor for one-variable case
   def this(binder : Term, variable : Term, body : Term) = this(binder, List(variable), body)
}

//Morphism application
case class OMM(arg : Term, via : Morph) extends Term {
   def copy = OMM(via,arg)
   def components = List(arg,via)
}
//applications
case class OMA(function : Term, arguments : List[Term]) extends Term {
   def components = function :: arguments
   def copy = OMA(function, arguments)
}
//variables
case class OMV(name : String) extends Term {
   def components = List(new presentation.OutputText(name))
   override def isVariable = true
   def copy = OMV(name)
}
//error objects
case class OME(error : Term, arguments : List[Term]) extends Term {
   def components = error :: arguments
   def copy = OMA(error, arguments)
}
//attributions
case class OMATTR(arg : Term, key : Term, value : Term) extends Term {
   def components = List(arg, key, value)
   override def isVariable = arg.isVariable
   override def strip = arg.strip
   def copy = OMATTR(arg, key, value)
}
//foreign objects
case class OMFOREIGN(node : Node) extends Term {
   def components = List(new presentation.OutputXML(node))
   def copy = OMFOREIGN(node)
}
//constants
//to do, can Scala and OpenMath constants be identified or are there subtle difficulties
case class OMConst(const : AnyVal) extends OMel {
   def components = List(new presentation.OutputText(c.toString))
   def copy = OMConst(const)
}

//morphisms
case class OMCOMP(morphisms : List[Morph]) extends Morph {
   def head : Path = morphisms.head
   def last : Path = morphisms.last
   def init : Morph = OMCOMP(morphisms.init)
   def tail : Morph = OMCOMP(morphisms.tail)
   def length : Int = morphisms.length
   def components = morphisms
}

case class OMIDENT(theory : Path) extends Morph {
   def head : Path = this
   def last : Path = this
   def init : Morph = this
   def tail : Morph = this
   def length : Int = morphisms.length.head
   def components = theory.components
}

case class OMLINK(link : Path, dom : Path, codom : Path) extends Morph {
   def head = this
   def last = this
   def init = OMIDENT(dom)
   def tail = OMIDENT(codom)
   def components = List(link,dom,codom)
}
