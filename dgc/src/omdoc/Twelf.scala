package omdoc
import scala.xml.{Node,Text}
import xml.{attr}
import utils.{log}
import presentation.{Context,Output,OutputText,OutputXML,OutputNone}

class TwelfError(s : String) extends OutputError(s)
/*object Twelfutils {
   //the path of the theory Twelf
   val twelfBase : Path = Path(URI(xml.namespace("omdoc")), Nil, List("twelf"))
    
   /*
     returns list of argument types and result type from a type or kind (T in beta-normal form)
     dependent arguments are returned as attributed OMV, other as OMel
     impl == true: include implicit arguments
   */
   def split(T : OMel, impl : boolean) : List[OMel] = {
    var result : List[OMel] = Nil
    def step (S : OMel) { 
       S match {
           case OMA(OMS(`twelfBase`/"arrow"),args) =>
              result = result ::: args.init
              step(args.last)
           case OMBIND(OMS(`twelfBase`/"Pi"),vs,_,bo) =>
              result = result ::: vs
              step(bo)
           case OMBIND(OMS(`twelfBase`/"implicit_Pi"),vs,_,bo) if impl =>
              result = result ::: vs
              step(bo)
           case OMBIND(OMS(`twelfBase`/"implicit_Pi"),_,_,bo) =>
              step(bo)
           case _ =>
              result = result ::: List(S)
       }
    }
    step(T)
    result
   }
   
   def lookup (path : Path, L : List[FlatSymbol]) =
    L.find({
       case FlatSymbol(`path`,_,_,_,_) => true
       case _ => false
    }).get.tp.get
    
   //return arguments and result type, respectively
   def arguments(T : OMel, impl : boolean) = split(T, impl).init
   def head(T : OMel) = split(T, false).last
   
   //return the level (term/type/kind) of an OMel (in beta normal form) with all declarations in T
   def level(O : OMel, L : List[FlatSymbol]) : String = {
    val H = head(O)
    H match {
       case OMS(`twelfBase`/"type") => "kind"
       case OMS(path) =>
          val l = level(lookup(path,L), L)
          if (l == "kind")
             "type"
          else
             "term"
       case OMM(_,arg) => level(arg,L)
       case OMA(f,_) => level(f,L)
    }
   }
}
*/

/*
   A printer for Twelf
*/
/*
 class Twelf (presDb : presentation.Database, graph : Flattener) extends presentation.Presenter(presDb, graph) {
   override val topMeta = Twelfutils.twelfBase
   //this returns a FlatSymbol expressing equality of the types tp and tp2 by declaring _ : tp -> tp2 = [x:_] x
   private def tpEqCheck(tp1 : OMel, tp2 : OMel) = {
      val omitted = Twelfutils.twelfBase/"omitted"
      val v = OMV("x").addAttribution(OMS(Twelfutils.twelfBase/"oftype"), OMS(omitted)).asInstanceOf[OMV]
      new FlatSymbol(omitted, Some(OMA(OMS(Twelfutils.twelfBase/"arrow"), List(tp1,tp2))), Some(new OMBIND(OMS(Twelfutils.twelfBase/"lambda"), v, OMV("x"))))
   }

   //to do: permit switching implicit/explicit in morphisms

   override val extension = ".elf"
   private def text(s : String) = new OutputText(s)
   override def printSymbol(s : FlatSymbol, format : String) = {
      printEqCheck(s, format)
      super.printSymbol(s, format)
   }
   override def startTheory {
      //write the configuraton file
      val out = new java.io.PrintWriter(new java.io.OutputStreamWriter(
         new java.io.FileOutputStream(new java.io.File(baseDir,currentTheory.id.name + ".cfg")),
         java.nio.charset.Charset.forName("UTF-8")
      ))
      //meta.cfg
      if (currentMeta != null)
         out.println(currentMeta.id.name + ".cfg")
      //theory.elf
      out.println(currentTheory.id.name + ".elf")
      out.close
      //prepend theory name to the .elf file
      output(new OutputText("%% Theory " + currentTheory.id.toOMPath + "\n"))
   }
   /* This function prints those symbols that are needed for the equality check.
      Fresh name generation is needed for the equality checks. This code assumes that no name is _ or _a or starts with _X.
   */
   def printEqCheck(s : FlatSymbol, format : String) {
      if (! s.df2.isEmpty) {
         //It is necessary to check df == df2, which is not a Twelf primitive.
         if (Twelfutils.level(s.df.get, graph.flattenedNodesSymbols(currentTheory.id)) == "term") {
            //for terms, check _a df == _a df2 for a new symbol _a : tp -> type
            val a = currentTheory.id/"_a"
            val f = new FlatSymbol(a, Some(OMA(OMS(Twelfutils.twelfBase/"arrow"), List(s.tp.get,OMS(Twelfutils.twelfBase/"type")))), None)
            printSymbol(f, format)
            val tp1 = OMA(OMS(a), List(s.df.get))
            val tp2 = OMA(OMS(a), List(s.df2.get))                   
            printSymbol(tpEqCheck(tp1, tp2), format)
         } else {
            //for type families, check df X_1 ... X_n == df2 X_1 ... X_n where n is the number of explicit arguments
               val n = Twelfutils.arguments(s.df.get,false).length
               val vars = List.range(0,n).map(i => OMV("_X" + i.toString))
               val tp1 = OMA(s.df.get, vars)
               val tp2 = OMA(s.df2.get, vars)
               printSymbol(tpEqCheck(tp1,tp2), format)
            }
         }
   }
}
*/
/*class TwelfToPMathml(omPresenter : OMPresenter) extends Twelf {
   override val extension = ".xhtml"
   private def printOM(O : OMel) : Seq[Node] = {
      omPresenter.present(O,"pmathml").toXML
   }
   //print a symbol in MathML/Twelf syntax
   def printSymbol(s : FlatSymbol) {
      val sep = "0.25em"
      val col = "blue"
      val N =	
      <math xmlns="http://www.w3.org/1998/Math/MathML">
         {printOM(s.m.toOMel)}
         {
         if (s.tp != None)
            <mspace width={sep}/><mo mathcolor={col}>:</mo><mspace width={sep}/> ++ printOM(s.tp.get)
          else
             Nil
         }
         {
         if (s.df != None)
            <mspace width={sep}/><mo mathcolor={col}>=</mo><mspace width={sep}/> ++ printOM(s.df.get)
         else
            Nil
         }
         <mo mathcolor={col}>.</mo>
      </math>
      output(OutputXML(scala.xml.Utility.trim(N) ++ <html:br/>))
   }
   override def startTheory {
      output(new OutputXML(<html:h3>{currentTheory.id.name}</html:h3>))
      if (currentMeta != null)
         output(OutputXML(<html:a href={currentMeta.id.name + extension}>Meta-theory</html:a><html:br/>))
   }
   override def endTheory {
      buffer = OutputXML(
         <?xml-stylesheet?> ++
         scala.xml.Utility.trim(
         <html xmlns="http://www.w3.org/1999/xhtml" xmlns:visib="http://www.mathweb.org/omdoc" xmlns:html="http://www.w3.org/1998/Math/MathML">
            <head></head>
            <body>
               {buffer.toXML}
            </body>
         </html>
      ))
      super.endTheory
   }
}
*/
/*
class TwelfToHtml(omPresenter : OMPresenter) extends Twelf {
   override val extension = ".xhtml"
   private def printOM(O : OMel) : Seq[Node] = {
   omPresenter.present(O,"pmathml").toXML
   }
   //print a symbol in HTML-encoded MathML syntax
   def printSymbol(s : FlatSymbol) {
      val col = "blue"
      val N =
      <p class="formula">
         {printOM(s.m.toOMel)}
         {
         if (s.tp != None)
            <span class="mo" style={"color:" + col}>&#xa0;:&#xa0;</span> ++ printOM(s.tp.get)
          else
             Nil
         }
         {
         if (s.df != None)
            <span class="mo" style={"color:" + col}>&#xa0;=&#xa0;</span> ++ printOM(s.df.get)
         else
            Nil
         }
         <span class="mo" style={"color:" + col}>.</span>
      </p>
      output(OutputXML(scala.xml.Utility.trim(N)))
   }
   //holds a list of names that are used to generate the index file at the end
   private var index : List[String] = Nil
   //print theory name and link to meta-theory
   override def startTheory {
      val name = currentTheory.id.name
      index = index ::: List(name)
      output(new OutputXML(<h3>{name}</h3>))
      if (currentMeta != null)
         output(OutputXML(<a href={currentMeta.id.name + extension}>Meta-theory</a><br/>))
   }
   //wrap buffer in xhtml, then call parent method to write the buffer to a file
   override def endTheory {
      buffer = OutputXML(
         //<?xml version="1.0" encoding="UTF-8"?> ++
         //<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1 plus MathML 2.0//EN" "http://www.w3.org/TR/MathML2/dtd/xhtml-math11-f.dtd"> ++ 
         <html xmlns="http://www.w3.org/1999/xhtml" xmlns:visib="http://www.omdoc.org/visibility">{
            scala.xml.Utility.trim(
               <head>
                  <link rel="stylesheet" type="text/css" href="omdoc.css"/>
               </head>
            ) ++ scala.xml.Utility.trim(
               <body>
                  {buffer.toXML}
               </body>
            )
         }
         </html>
      )
      super.endTheory
   }
   //write index file
   override def endGraph {
      val out = new java.io.PrintWriter(new java.io.OutputStreamWriter(
         new java.io.FileOutputStream(new java.io.File(baseDir,"index.html")),
         java.nio.charset.Charset.forName("UTF-8")
      ))
      out.print("<html><head/><body>")
      for (t <- index)
         out.print("<a href=\"" + t + ".xhtml\">" + t + "</a><br/>")
      out.print("</body></html>")
      out.close
   }
}
*/
/*class TheoryPresenterLatex(omPresenter : OMPresenter, out : java.io.PrintWriter) extends TheoryPresenter(omPresenter, "latex", out) {
   // prints a normalized OMOBJ that does not contain empty OMMs in Twelf syntax
   private def printTerm(O : OMel) : String = {
      printOM(O).toText
   }
   
   //print a symbol in Latex/Twelf input syntax using Latex macros
   def printSymbol(s : FlatSymbol) = {
      def text(s : String) = new OutputText(s)
         val sy = printTerm(s.m.toOMel)
         val tp = if (s.tp != None) printTerm(s.tp.get) else ""
         val df = if (s.df != None) printTerm(s.df.get) else ""
         val line : String =
         ((s.tp.isDefined, s.df.isDefined) match {
            case (true,true) => "\\twelfdecldef{" + sy + "}{" + tp + "}{" + df + "}"
            case (true,false) => "\\twelfdecldef{" + sy + "}{" + tp + "}"
            case (false,true) => "\\twelfdef{" + sy + "}{" + df + "}"
         }) + (if (s.comment != None) "% " + s.comment.get else "") + "\n"
         output(new OutputText(line))
   }
   override def endTheory(id : Path) = output(new OutputText("\n"))
}*/