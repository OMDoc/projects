package omdoc
import scala.xml.{Node}
import xml.{attr}
import utils.{log}

class Proof {}

case class PlainProof (p : OMel) extends Proof {
}

case class OMDocProof private extends Proof {
   var method : Method = null   //reference to the proof rule
   var params : List[OMel] = Nil  //objects giving the parameters of the rule
   var premises : List[Premise] = Nil  //proofs of the premises of the rule
   var fmp : Option[OMel] = None  //the derived formula (may be None because it can be reconstructed from the proof)
   var hypotheses : List[(String,OMel)] = Nil  //context (whole proof is lambda abstraction over this)
//   var symbols : List[String] = Nil
//   var types : String => Node = null
//   var definitions : String => Node = null
   
   def this(P : Node, context : Node) = this()
   
   //unparses a marked up proof into an OMel proof object
   //hypothetical proofs are returned as abstraction using lambda as binder and tpkey as key for the type attribution
   //gaps are bridged by using new variables
   //a gap is treated as an underived proof rule, in particular gaps may not depend on hypotheses
   //result is pair of proof term and list of used gaps (as name-type pair)
   def toOM(variables : List[(String,OMel)], lambda : OMel, tpkey : Path) : (OMel,List[(String,OMel)]) = {
		   //unfold into proof term; variables: hypotheses that are declared in the context
		      var gaps : List[(String,OMel)] = Nil
		      //a local function because rule applications and gaps do almost the same
      def applyRule(r : OMel) : OMel = {
         val prem : List[OMel] = premises.map({
         //unfold recursively adding this proof step's hypotheses to the context
         case PremiseProof(p) =>
            val (pf,gs) = p.toOM(variables ::: hypotheses, lambda, tpkey)
            gaps = gaps ::: gs
            pf
         //refer to variable (which will be bound below)
         case PremiseHypothesis(id) => 
            //check if variable is declared
            if (variables.exists(_._1 == id)) //checks if first component of pair equal to id (It doesn't matter whether the ids are unique.)
               new OMV(id)
            else
               throw (new Error("undeclared hypothesis: " + id))
         //refer to axiom
         case PremiseAxiom(id) => id
         })
        //Curry-Howard paradigm: rule application is OMA with parameters and premises as arguments
        new OMA(r,params ::: prem)
      }
		val body = method match {
         case MethodRule(r) => applyRule(r)
         case MethodGap(g) =>
            //invent variable name
            var name = "OmittedStep_" + gaps.length.toString
            //make sure that the name is fresh by adding "'" (It's no problem if the gap variable is shadowed later.)
            while (variables.exists(_._1 == name)) name = name + "'"
            //keep track of gaps
            gaps = gaps ::: List((name,g))
            //bridge gap by using the variable as the rule
            val rule = new OMV(name)
            applyRule(rule)
            //gap variable is not applied to the variables in the context because gaps do not depend on hypotheses
         case MethodTranslation(p,via) =>
            //translation of p along via, what about gaps, hypotheses, variables?
            new OMM(via,p.toOM(Nil,lambda,tpkey)._1)
      }
      //take lambda abstraction over the hypotheses
      val pf = hypotheses.foldLeft[OMel](body)({case (x, (id,tp)) => new OMBIND(lambda,(new OMV(id)).addAttribution(tpkey,tp).asInstanceOf[OMV],x)})
      (pf,gaps)
   }
}

class Method
case class MethodRule(r : OMel) extends Method  //rule application, r: rule (typically symbol)
case class MethodGap(g : OMel) extends Method   //omitted proof step, g:, type of missing proof
case class MethodTranslation(p : OMDocProof, via : Morphism) extends Method  //translation of p along via

class Premise
case class PremiseProof(p : OMDocProof) extends Premise   //proof of a premise
case class PremiseHypothesis(id : String) extends Premise  //reference to a hypothesis by its name
case class PremiseAxiom(ax : OMel) extends Premise   //reference to axioms, tp: type of the proof given by the axiom

