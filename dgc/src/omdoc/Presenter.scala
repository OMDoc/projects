package omdoc.presentation
import scala.xml.{Node}
import xml.{attr}
import utils.{log}

/* This provides the simplest implementation that can read and use all presentation information.
   Constants are printed by the Scala toString method, foreign objects different from text or xml throw exceptions.
   The current code assumes the following about the syntax of presentation elements:
   - for, format, and role are mandatory ???
   - format may only contain one format, not a list
   - bound variable presentations are optional (Note: A variable without presentation information cannot shadow one with presentation information.)
*/
class Presenter(presDb : Database, lib : Library) {
   protected val defaultPresGraphs = Presentation(infint.Infinity, ItemComponents(0,-1,false, ItemList(Nil), ItemRecurse(infint.Infinity)))
   
   //find a basic reference path that is used to look up default presentations
   protected def getPath(O : OMel) : Path = getPath(O, Nil)
   protected def getPath(O : OMel, varsPres : VarsPres) : Path = O match {
      case OMS(path) => path
      case OMA(f,_) => getPath(f)
      case OME(f,_) => getPath(f)
      case OMV(name) => varsPres.find(_._1 == name).get._2 //lookup path in (name, path, _)
      case OMBIND(b,_,_,_) => getPath(b)
      case OMM(via,_) if ! via.isIdentity => via.head
      case OMM(Identity,arg) => getPath(arg)
      case _ => throw (new Error("unable to find reference path in " + O.toString))
   }
   
   protected def presForeign(N : Node, format : String) : Output = {
      attr(N,"encoding") match {
         case "text" => new OutputText(N.child(0).toString, infint.Finite(0))
         case "xml" => OutputXML(N.child(0))
         case _ => throw (new Error("Cannot present foreign object " + N.toString))
      }
   }
   
   //parse bound variable presentations and store them in a list of pairs (name, path, presentation) (de Bruijn order, i.e., innermost variables first
   //Here path gives the base theory of the variable, i.e., the base theory of the binder
   //outer is the list of variables bound by outer binders and parsed earlier
   protected type VarsPres = List[(String, Path, Presentation)]
   private def parseVar(O : OMBIND, format : String, outer : VarsPres) : VarsPres = {
      val vars = O.variables
      val varb = vars.head
      val name = varb.name
      val path = getPath(O.binder)
      val att = varb.attribution(xml.presentationKey.path)
      val pre : Presentation =
         try {
            //actually, matching "for" should be redundant; role is not checked; take the first if there's more than one
            val pres = (att.get.asInstanceOf[OMFOREIGN].node\"presentation").filter(p => attr(p,"for") == name && attr(p,"format") == format)
            PresentationParser.parsePresentation(pres(0), path/^, lib)._2
         } catch { case _ => 
            //if none found, take default presentation, using the path of the binder as the starting reference
            presDb.lookup(Context(path, "variable", format))
         }
      if (vars.length == 1)
         (name, path, pre) :: outer
      else
         parseVar(OMBIND(O.binder, vars.tail, O.condition, O.body), format, (name, path, pre) :: outer)
   }
   /*  The public method to present an object
       O: Object to be presented
       format: target format, e.g., "ascii", "latex", "pmathml"
       params: The input precedence passed down from the parent and the parent's visibility, if O is not the root of the syntax tree.
         The former defaults to the minimal precedence so that top-level brackets are elided.
       varsPres: A list of Presentation instances for the bound variables that are in scope.
         This defaults to the empty list because top-level OMel objects must be closed.
       present passes "recurse", a partially applied version of itself, to the presentation items so that they can call back for recursion.
         This should be evaluated as a potential efficiency hazard.
   */
   def present(O : Presentable, format : String) : Output = {
      val writer = new OutputBuffer
      present(O, format, writer)
      writer.flush
   }
   def present(O : Presentable, format : String, writer : OutputWriter) {
      present(O,format, Util.initialParams.setWriter(writer), Nil)
   }
   protected def present(O : Presentable, format : String, params : Util.RecurseParams, varsPres : VarsPres) {
      //callback function to be passed along when calling the presentation
      val recurse : Util.Recurse = pars => O => present(O, format, pars, varsPres)
      //a local function for the unified treatment of OMA and OME in the following case distinction
      def omae(O : Presentable, f : OMel, role : String) = {
         //get presentation depending on whether f is symbol or not
         val p =
            if (f.isInstanceOf[OMS])
               //look up presentation for f
               presDb.lookup(Context(f.asInstanceOf[OMS].path, role, format))
            else
               //take default presentation for f
               presDb.lookup(Context(getPath(f, varsPres),role, format))
         p.print(O, params, recurse)
      }
      O match {
         case o : OMel if ! o.getAttributions.isEmpty =>
            log("  printing term: " + o.toString,5)
            val atts = o.getAttributions
            //If there is an attribution, present O according to its key.
            //Recall: O.components = List(key, value, rest) where rest is O without the first attribution
            val key = atts(0)._1
            val p = presDb.lookup(Context(key, "key", format))
            p.print(O, params, recurse)
            //now the case without attributions
         case OMS(path) =>
            val p = presDb.lookup(Context(path, "constant", format))
            p.print(O, params, recurse)
         case OMA(f,_) => omae(O, f, "application")
         case OME(f,_) => omae(O, f, "error")
         case OMBIND(b,_,_,_) => 
            //get presentation depending on whether f is symbol or not
            val p =
               if (b.isInstanceOf[OMS])
                  //look up presentation for b
                  presDb.lookup(Context(b.asInstanceOf[OMS].path, "binder", format))
               else
                  //take default presentation for b
                  presDb.lookup(Context(getPath(b),"binder", format))
            //new variable presentations (including successive inner binders) are added to varsPres
            val newVarsPres = parseVar(O.asInstanceOf[OMBIND], format, varsPres)           
            p.print(O, params, pars => O => present(O,format, pars, newVarsPres))
         case OMV(name) =>
            //find first (name,_,p) in varsPres and return p
            val p = varsPres.find(_._1 == name).map(_._3).get //existence guaranteed if original OMel was closed
            p.print(O, params, recurse)
         case OMM(via, arg) => 
            //eliminate special case; there is no presentation of the identity morphism
            if (via.isIdentity)
               recurse(params)(arg)
            else {
               val p = presDb.lookup(Context(via.last,"morphism",format))
               p.print(O, params, recurse)
            }
         //presentation of foreign objects and constants is done in separate methods to permit overriding
         case OMFOREIGN(node) => presForeign(node,format)
         case OMConst(c) => c match {
            case _ : Int =>
               val p = presDb.lookup(Context(xml.omdocBase,"integer", format))
               p.print(O, params, recurse)
            case _ => throw new OutputError("unimplemented constant type: " + O)
         }
         case OMNone() => 
         //to do: presentation of morphisms
         case Morphism(via) =>
            val p = if (O.asInstanceOf[Morphism].isIdentity)
               presDb.lookup(Context(xml.omdocBase,"identity", format))
            else   
               presDb.lookup(Context(via.head,"composition", format))
            p.print(O, params, recurse)
         case SymDecl(path, _, _) => 
            params.writer.startDeclaration(path.name)
            val p = presDb.lookup(Context(path,"symbol", format))
            p.print(O, params, recurse)
            params.writer.endDeclaration(path.name)
        case AssDecl(path, _, _) => 
            params.writer.startDeclaration(path.name)
            val p = presDb.lookup(Context(path,"assertion", format))
            p.print(O, params, recurse)
            params.writer.endDeclaration(path.name)
         case SymDef(path) => 
            params.writer.startDefinition(path.name)
            params.writer.endDefinition(path.name)
         case AssDef(path) => 
            params.writer.startDefinition(path.name)
            params.writer.endDefinition(path.name)
         case ThDecl(th) =>
            val thid = th.id
            params.writer.startTheory(thid.name)
            val p = presDb.lookup(Context(thid,"theory", format))
            p.print(O, params, recurse)
            params.writer.endTheory(thid.name)
         case ImpDecl(li) =>
            params.writer.startDeclaration(li.id.name)
            val p = presDb.lookup(Context(li.id,"import", format))
            p.print(O, params, recurse)
            params.writer.endDeclaration(li.id.name)
         case VwDecl(li) =>
            val name = li.id.name
            params.writer.startView(name)
            val p = presDb.lookup(Context(li.id,"view", format))
            p.print(O, params, recurse)
            params.writer.endView(name)
         case m : Map =>
            //all maps can be treated in the same way
            val p = presDb.lookup(Context(m.of,"map", format))
            p.print(O, params, recurse)
         case g : DevGraph =>
            val p = try {presDb.lookup(Context(g.id,"graph", format))}
               catch {case Util.LookupError(_) => defaultPresGraphs}
            params.writer.startGraph(g.id)
            p.print(O, params, recurse)
            params.writer.endGraph(g.id)
         case Path(_,_,_) => 
            val p = presDb.lookup(Context(O.asInstanceOf[Path],"name", format))
            p.print(O, params, recurse)
         case TheoryPath(path) => 
            val p = presDb.lookup(Context(path,"theorypath", format))
            p.print(O, params, recurse)
         case FlatName(path) => 
            val p = presDb.lookup(Context(path,"flatname", format))
            p.print(O, params, recurse)
         //render presentation output as itself
         case o : Output =>
            log("  printing text " + o.toText, 3)
            params.writer.write(o)
         case _ => throw new UnpresentableArgument("cannot present " + O.toString)
      }
   }
}

class UnpresentableArgument(msg : String) extends OutputError(msg)

abstract class OutputWriter {
   //callback methods that are called during the printing
   def startGraph (uri : Path) {}
   def endGraph (uri : Path) {}
   def startTheory (name : String) {}
   def endTheory (name : String) {}
   def startView (name : String) {}
   def endView (name : String) {}
   def startDeclaration(name : String) {}
   def endDeclaration(name : String) {}
   def startDefinition(name : String) {}
   def endDefinition(name : String) {}
   def write(output : Output)
}

class OutputBuffer extends OutputWriter {
   protected var buffer : Output = OutputNone
   def write(output : Output) {
      buffer = buffer + output
   }
   def flush : Output = {
      val b = buffer
      buffer = OutputNone
      b
   }
}

class OutputToConsole extends OutputWriter {
   def write(output : Output) {
      System.out.print(output.toText)
   }
}

/* Writer that outputs to a file system
   target: Output directory
   toplevelSeparate == false: everything is printed into one file
   toplevelSeparate == true: theories and views are printed into separate files; subtheories are printed into subdirectories 
      statementsSeparate == true: every statement is printed into a separate file (only possible if toplevelSeparate == true)
   extension: file name extension (if output to single file: file name)
   TODO: test toplevelSeparate
*/
class OutputToFile private (var target : java.io.File, extension : String, toplevelSeparate : boolean, statementsSeparate : boolean) extends OutputWriter {
   def this(target : java.io.File, extension : String, statementsSeparate : boolean) = {
      this(target, extension, true, statementsSeparate)
      if (extension == "")
         throw new Error("extension may not be empty")
   }
   def this(target : java.io.File, extension : String) = this(target, extension, false)
   def this(filename : java.io.File) = {
      this(filename.getParentFile, filename.getName, false, false)
   }
   
   private var files : List[java.io.PrintWriter] = Nil
   protected def openFile(name : String) {
      if (! target.isDirectory)
         target.mkdir
      files ::= new java.io.PrintWriter(new java.io.OutputStreamWriter(
            new java.io.FileOutputStream(new java.io.File(target, name)),
            java.nio.charset.Charset.forName("UTF-8")
      ))
   }
   protected def closeFile {
      files.head.close   
      files = files.tail
   }
   override def startGraph (uri : Path) {if (! toplevelSeparate) openFile(extension)}
   override def endGraph (uri : Path) {if (! toplevelSeparate) closeFile}
   override def startTheory (name : String) {
      if (toplevelSeparate)
         openFile(name + "." + extension)
      target = new java.io.File(target, name)
   }
   override def endTheory (name : String) {
      if (toplevelSeparate)
         closeFile
      target = target.getParentFile
   }
   override def startView (name : String) {if (toplevelSeparate) openFile(name + "." + extension)}
   override def endView (name : String) {if (toplevelSeparate) closeFile}
   override def startDefinition (name : String) {if (statementsSeparate) openFile(name)}
   override def endDefinition (name : String) {if (statementsSeparate) closeFile}
   override def startDeclaration (name : String) {if (statementsSeparate) openFile(name)}
   override def endDeclaration (name : String) {if (statementsSeparate) closeFile}

   def write(output : Output) {
      files.head.print(output.toText)
   }
}