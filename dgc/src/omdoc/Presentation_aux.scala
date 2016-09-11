package omdoc.presentation
import scala.xml.{Node}
import xml.{attr}
import utils.{log,fromList}
import infint.{InfInt,Infinity,NegInfinity,Finite,Interval}
import infint.InfInt.{fromInt}

//This object collects all small top-level declarations related to presentation.
object Util {
   type Precedence = InfInt
   type VsLevel = InfInt
   /* RecurseParams: The parameters passed back and forth between the Presentation.print and Presenter.present methods when recursing.
      bracketLevel: For outer presentation elements, the input precedence of the parent.
         For inner elements, e.g., within ItemComponents, the input/output precedence difference.
      parentVisible: All presentation items (and other elements containing presentation items) can specify visibility information.
         But only some items actually produce output, e.g., ItemText and ItemElement. parentOverride saves this information when processing the former,
         applyOverride uses it to override the visibility information of the latter.
         If items of the former kind are nested (e.g., component and separator), the inner one's information is ignored.
         If items of the latter kind are nested, the override only applies to the outer one.
   */
   case class RecurseParams(bracketLevel : InfInt, parentVisible : Option[Visible], index : Int, writer : OutputWriter) {
      //override visibility information if parentVisible is set
      def applyOverride(visible : Visible) : Visible = {
         log(toString + ": applying override to " + visible,8)
         parentVisible.getOrElse(visible)
      }
      //cancel visibility override
      def noOverride = RecurseParams(bracketLevel, None, index, writer)
      //set visibility override if non-trivial visibility is passed and no override already exists
      def setOverride(visible : Visible) = {
         val vis =
            if (visible != Unelidable && parentVisible == None)
                  Some(visible)
               else
                  parentVisible
         RecurseParams(bracketLevel, vis, index, writer)
      }
      def setOutputPrec(prec : Precedence) =
         RecurseParams(prec, parentVisible, index, writer)
      def setBracketLevel(bL : InfInt) = setOutputPrec(bL)
      def setIndex(i : Int) = RecurseParams(bracketLevel, parentVisible, i, writer)
      def setWriter(newWriter : OutputWriter) = RecurseParams(bracketLevel, parentVisible, index, newWriter)
   }
   //parameters for top-level objects
   def initialParams = RecurseParams(NegInfinity, None, 0, null)
   type Recurse = RecurseParams => Presentable => Unit
   // thrown by presentation-related parsing methods
   case class UnsupportedItem(s : String) extends ParseError(s)
   // Thrown by toPresentation above if use element not supported.
   case class UnsupportedUseElement(s : String) extends OutputError(s)
   case class LookupError(s : String) extends OutputError(s)

   //special modulo function for accessing components at position i of l; returns values between 0 and l-1
   //takes i modulo l for values between -l and (l-1)
   //for other values, it takes 0 or l - 1 (no modulo here to prevent overflows)
   def componentIndex(i : Int, l : Int) : Option[Int] = {
      if (i < -l)
         return None
      if (i > l-1)
         return None
      if (i < 0)
         return Some(i + l)
      return Some(i)
   }
}

//An object containing the parser for a presentations
object PresentationParser {
   def parsePresentation(pres : Node, base : Path, lib : Library) : (Context, Presentation) = {
      log("Processing presentation: " + pres.toString, 4)
      val format = attr(pres,"format")  //empty format is allowed, means any format
      val role = attr(pres,"role")
      val fo = attr(pres, "for")
      if (role == "" || fo == "")
         throw new ParseError("not all attribute´s found in: " + pres.toString)
      val path = Parse.path(fo, base, lib)
      //pc is the input part of pres
      val pc = Context(path,role,format)
      //to do: base should be symbol/^ if possible
      val p = parseRendering(pres, path/^, lib)  //p is the output part of pres
      log("  presentation context: " + pc.toString,4)
      log("  presentation items: " + p.toString,4)
      (pc,p)
   }

   private def parseRendering(N : Node, base : Path, lib : Library) : Presentation = {
      // parses a list of Nodes element-wise into ItemList (type="emplicit") or Use (type="implicit", default)
      val precedence = - infint.InfInt.parse(attr(N,"precedence"), infint.Infinity)
      def parseItemList(l : List[Node], defaultVisib : Visible) : ItemList = {
         l match {
            case Nil => ItemList(Nil)
            case head :: tail => {
               //parse the visibility attributes; the semantics is best seen by looking at the code
               val visible = (attr(head,xml.namespace("visib"),"egroup", true), attr(head,xml.namespace("visib"),"elevel", true)) match {
                  case ("","") => defaultVisib  //use default value if no attributes given.
                  case (_,"bracket") | (_,"rbrack") | (_,"lbrack") => Bracket //level "bracket" is used for brackets.
                  case ("", lv) => Elidable(base.toOMPath, - infint.InfInt.parse(lv)) //Here the group defaults to te theory.
                  case (gr, lv) => Elidable(gr, - infint.InfInt.parse(lv,Finite(0))) //Here level defaults to 0.
               }
               val it = head match {
                     //parse <text value="..."/>
                     case <text/> =>
                        ItemText(attr(head, "value"))
                     //parse <text>...</text>
                     case <text>{t @ _*}</text> =>
                        //text as an element
                        ItemText(t(0).toString)
                     case <name/> =>
                        //parse name
                        ItemName
                     //parse <element>
                     case <element>{_*}</element> =>
                        val name = attr(head,"name")
                        //list to collect attributes
                        var atts : List[ItemElemAttr] = Nil
                        //list to collect children, will be parsed as whole at the end
                        var chs : List[Node] = Nil
                        //parse <attribute> children
                        for (N <- head.child) {
                           if (N.label == "attribute") {
                              //N is an attribute
                              val nm = attr(N,"name")
                              val its = parseItemList(N.child.toList, visible)
                              atts = atts ::: List(ItemElemAttr(nm, its))
                           } else {
                              //N is a child
                              chs = chs ::: List(N)
                           }
                        }
                        //parse <element> children
                        val elems = parseItemList(chs, visible)
                        //construct element
                        ItemElement(name, atts, elems)
                     //parse <components>, which are identical
                     case <components>{ch @ _*}</components> =>
                        var its = ch.toList
                        var beg = 0
                        var end = 0
                        var sep = ItemList(Nil)
                        if (head.attribute("pos").isDefined) {
                           beg = try {attr(head,"pos").toInt}
                                 catch {case _ => 0}
                           end = beg
                        } else {
                           try {attr(head,"begin").toInt}
                           catch {case _ => 0}
                           //parse begin and end
                           beg = 
                              try {attr(head,"begin").toInt}
                              catch {case _ => 0}
                           end = 
                              try {attr(head,"end").toInt}
                              catch {case _ => -1}
                           //separator is optional first child
                           if (its.isEmpty || its(0).label != "separator")
                              //default separator if none present
                              sep = ItemList(Nil)
                           else {
                              val s = its.head
                              //remove separator
                              its = its.tail
                              //parse separator
                              sep = parseItemList(s.child.toList, visible)
                           }
                        }
                        //parse items
                        val items = if (its.isEmpty) {
                           //a single recurse (with input == output precedence) is the default for the case when the body of components is empty
                           new ItemList(ItemRecurse(precedence))
                        } else
                           parseItemList(its, visible)
                        //if end > begin, reverse = true, i.e., reverse order is used
                        //here the ordering is 0 < 1 < ... < oo < -oo < ...< -2 < -1, which yields the intuitively right semantics
                        def sgn(i : Int) = if (i >= 0) 1 else -1
                        val reverse : boolean = (sgn(beg) == sgn(end) && end > beg) || sgn(end) > sgn(beg)
                        ItemComponents(beg, end, reverse, sep, items)
                     //parse <attribution>
                     case <attribution>{body @ _*}</attribution> =>
                        //key must be symbol
                        val k = Parse.path(attr(head,"key"), base)
                        val its = if (body.isEmpty)
                           //single recurse is default
                           new ItemList(ItemRecurse(precedence))
                        else
                           //parse items
                           parseItemList(body.toList, visible)
                        ItemAttribution(k, its)
                     //parse index
                     case <index/> =>
                        //multiple and offset default to m * x + o = x
                        val m = try {attr(head,"multiple").toInt}
                                catch {case _ => 1}
                        val o = try {attr(head,"offset").toInt}
                                catch {case _ => 0}
                        ItemIndex(m,o)
                     //parse <recurse>
                     case <recurse/> =>
                        //ItemRecurse has the input precedence as a constructor argument. By default it is equal to the input precedence.
                        //Default value and final result are negated to turn around OMDoc's stronger/weaker binding semantics.
                        ItemRecurse(- infint.InfInt.parse(attr(head,"precedence"), - precedence))
                     //parse group
                     case <group>{its @ _*}</group> =>
                        ItemGroup(parseItemList(its.toList, Unelidable))
                     //parse if
                     case <ifpresent>{its @ _*}</ifpresent> =>
                        val check = try {attr(head,"pos").toInt}
                        catch {case _ => 0} 
                        ItemIf(check, parseItemList(its.toList, defaultVisib))
                     // parses a presentation of type "use"
                     // parameters are given as attributes or children; the latter may contain presentation items
                     // missing parameters default to None
                     case <use>{_ @ _*}</use> =>
                        //fixity
                        val f = attr(head,"fixity") 
                        val fixity = f match {
                           case "" => None
                           case "prefix" => Some(Prefix)
                           case "postfix" => Some(Postfix)
                           case "infix" => Some(Infix)
                           case "infixlr" | "infixrl" => Some(InfixLR)
                           case "infixr" => Some(InfixR)
                           case "infixl" => Some(InfixL)
                           case _ => throw (new ParseError("unsupported fixity: " + f))
                        }
                        //bracket style
                        val b = attr(head,"bracketstyle")
                        val brackStyle = b match {
                           case "" => None
                           case "math" => Some(BSMath)
                           case "lisp" => Some(BSLisp)
                           case _ => throw (new ParseError("unsupported bracket style: " + b))
                        }
                        //brackets
                        var lbrack : Option[ItemList] = None
                        val l = head\"lbrack"
                        if (! l.isEmpty) {
                           //parse recursively
                           lbrack = Some(parseItemList(l(0).child.toList, Bracket))
                        }
                        var rbrack : Option[ItemList] = None
                        val r = head\"rbrack"
                        if (! r.isEmpty) {
                           //parse recursively
                           rbrack = Some(parseItemList(r(0).child.toList, Bracket))
                        }
                        var operator : Option[ItemList] = None
                        //operator symbol
                        val o = head\"operator"
                        if (! o.isEmpty)
                           operator = Some(parseItemList(o(0).child.toList, defaultVisib))
                        //separator
                        var separator : Option[ItemList] = None
                        val s = head\"separator"
                        if (! s.isEmpty)
                           separator = Some(parseItemList(s(0).child.toList, defaultVisib))
                        //implicit arguments
                        var implicitArgs : Option[Int] = None
                        val imp = attr(head,"implicit")
                        if (imp != "") {
                           try {implicitArgs = Some(imp.toInt)}
                           catch {case _ => throw (new ParseError("unsupported number of implicit arguments: " + imp))}
                        }
                        ItemUse(fixity, lbrack, rbrack, brackStyle, operator, separator, implicitArgs, precedence)
                 }
                 it.visible = visible
                 it * parseItemList(tail, defaultVisib)
            }
         }
      }
      //the main code of the parsing method
      val defaultVisib = Unelidable
      val items = parseItemList(N.child.toList, defaultVisib)
      new Presentation(precedence, items)
   }
}