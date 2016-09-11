package omdoc

object flomdoc {
   private var params : List[String] = Nil
   private var count : Int = 0
   private var options : String = ""
   //get next parameter
   private def next : String = {
      if (params == Nil)
         error("parameter expected")
      val res = params.head
      params = params.tail
      count -= 1
      res
   }
   def main(args : Array[String]) : Unit = {
   /* put components that are to be logged here
      0: read in theory graph
      1: normalization, application, home check
      2: flattening
      3: presentation, print
      4: presentation, parse
      5: Twelf
      6,7: presentation, lookup
      8: presentation recursion parameters
   */
      utils.setLogLevel(List(0,6,7,4))
/*      params = args.toList
      count = params.length
      while (count > 0 && params(0).startsWith("-")) {
         options = options + next.substring(1)
      }
      subcomm
*/
      
   
   }
   //branch according to subcommand
   private def subcomm {
      if (count == 0) {
         usage
         return
      }
      next match {
         case "present" => present
         case _ => error("unknown subcommand")
      }
   }
   //throw error
   def error(msg : String) = throw new Error(msg)
   //print usage information
   def usage {
      System.out.println("Usage: [program name] -[options] [subcommand] [args]")
   }
   //read input file and present component 
   def present {
      val writer = next match {
         case "-f" => new presentation.OutputToFile(new java.io.File(next))
         case "-ff" => new presentation.OutputToFile(new java.io.File(next), next, false)
         case "-fff" => new presentation.OutputToFile(new java.io.File(next), next, true)
         case "-c" => new presentation.OutputToConsole
         case _ => error("Output type expected")
      }
      val input = next
      val format = next
      val lib : Library = new Library
      lib.getGraph(new DocumentURI("E:\\Promotion\\homedir\\ombase\\omdoc\\omdoc.omdoc"))
      lib.getGraph(new DocumentURI("E:\\Promotion\\homedir\\ombase\\logical_frameworks\\lf\\twelf.omdoc"))
      lib.getGraph(new DocumentURI("E:\\Promotion\\homedir\\ombase\\logics\\fol\\fol_implicit.omdoc"))
      val db = new presentation.Database(lib)
      val graph = new Flattener(xml.parseXML(input), Parse.path(input), lib, db.addPresentation)
      db.addFiles(params : _*)
      val presenter = new presentation.Presenter(db, lib)
      presenter.present(graph, format, writer)
   }
}
