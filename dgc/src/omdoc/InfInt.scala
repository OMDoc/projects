package omdoc.infint

/* a package that extends integers with positive and negative infinity */

object InfInt {
   def parse(s : String) : InfInt = parse(s, Finite(0))
   def parse(s : String, dft : InfInt) : InfInt = {
      s match {
         case "" => dft
         case "infinity" => Infinity
         case "-infinity" | "- infinity" => NegInfinity
         case _ =>
            try {Finite(s.toInt)}
            catch {case _ => throw (new Error("InfInt: unsupported value: " + s))}
      }
   }
   //this permits to use the integer i instead of Finite(i)
   implicit def fromInt(i : Int) : InfInt = Finite(i)
}

//the class for the set of possibly infinite integers
abstract class InfInt {
   def <= (q : InfInt) : boolean
   def >= (q : InfInt) : boolean = ! (this < q)
   def > (q : InfInt) : boolean = ! (this <= q)
   def < (q : InfInt) : boolean = this <= q && ! (this == q)
   def + (q : InfInt) : InfInt = this - (- q)
   //this method makes - a binary infix operator
   def - (q : InfInt) : InfInt
   //this method makes - a unary prefix operator
   def unary_- : InfInt = Finite(0) - this
   //operators to test for i \in [a,b]
   def $in(m : Interval) : boolean = this >= m.left && this <= m.right
   def $nin(m : Interval) = ! (this $in m)
}
//the finite integers
case class Finite(val i : Int) extends InfInt {
   def <= (q : InfInt) = q match {
      case Finite(j) => i <= j
      case Infinity() => true
      case NegInfinity() => false
   }
   def - (q : InfInt) = q match {
      case Finite(j) => i - j
      case Infinity() => NegInfinity
      case NegInfinity() => Infinity
   }
   override def toString = i.toString
}
//the inifinite values, inf - inf = (-inf) - (-inf) = 0
case class Infinity extends InfInt {
   def <= (q : InfInt) = q == Infinity
   def - (q : InfInt) = q match {
      case Infinity() => 0
      case _ => Infinity
   }
   override def toString = "infinity"
}
case class NegInfinity extends InfInt {
   def <= (q : InfInt) = true
   def - (q : InfInt) = q match {
      case NegInfinity() => 0
      case _ => NegInfinity
   }
   override def toString = "-infinity"
}

case class Interval(left : InfInt, right : InfInt)
