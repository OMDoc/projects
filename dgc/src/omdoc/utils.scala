package omdoc
import scala.xml.{Node,Elem,UnprefixedAttribute,PrefixedAttribute}

object utils {
   /* put components that are to be logged here
      0: read in theory graph
      1: normalization, application, home check
      2: flattening
      3: presentation, print
      4: presentation, parse
      5: Twelf
      6, 7: presentation lookup (6,7 more verbose than 6)
      8: presentation recursion parameters
   */
   private var components : List[Int] = List()
   def setLogLevel(l : List[Int]) {components = l}
   def log(s : => String, l : Int) : Unit = 
      if (components.exists(_ == l)) System.out.println(s)
   def log(s : String) {System.out.println(s)}
   
   //modulo function that always returns positive representative
   def mod(a : Int, b : Int) = a % b + (if (a < 0) b.abs else 0)
   
   implicit def fromList[A](l : List[A]) : myList[A] = new myList(l)
}

class myList[A](private val l : List[A]) {
   //not sure if this works, it might have to be in an object Mylist
   implicit def toList : List[A] = l
   // a certain way to fold: e.g., List("1", "2").fold("")(_ + " " + _ ) = "1 2" (foldLeft returns " 1 2").
   def myFold(start : A)(map : (A,A) => A) : A =
      l match {
         case Nil => start
         case List(a) => a
         case hd :: tl => tl.foldLeft(hd)(map)
      }
}

