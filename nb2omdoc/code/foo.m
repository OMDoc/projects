(*******************************************************************
This file was generated automatically by the Mathematica front end.
It contains Initialization cells from a Notebook file, which
typically will have the same name as this file except ending in
".nb" instead of ".m".

This file is intended to be loaded into the Mathematica kernel using
the package loading commands Get or Needs.  Doing so is equivalent
to using the Evaluate Initialization Cells menu command in the front
end.

DO NOT EDIT THIS FILE.  This entire file is regenerated
automatically each time the parent Notebook file is saved in the
Mathematica front end.  Any changes you make to this file will be
overwritten.
***********************************************************************)





printmssg[x__String] := If[ $prndebug,Print["**** ",x]];
printsec[x__String] := If[ $secdebug,Print["**** ",x]];



clear[xx___] :=Clear[xx];
FreeOfQ = FreeQ;



BasicTerms={};
KnownUpper={};
KnownLower={};
Facts[_]:=True;
Lemmas[_]:=True;
UserRules={};
UserFunctions={};
InductionVariables:={};
BranchStack={};





NumberOfTerms := Length[BasicTerms];
IndexOf[{b___, a_, c___}, a_] := Length[{b}] + 1;
IndexOf[_, a_] := NewTerm[a];
TermNumber[a_] := IndexOf[ BasicTerms, a ];

NewTerm[a_] := 
(
	AppendTo[BasicTerms, a];
	AppendTo[KnownUpper, Unknown];
	AppendTo[KnownLower, Unknown];
	NumberOfTerms
);



NumberOfAppearances[a_, pat_] := Length[Appearances[a, pat]];

Appearances[a_, pat_] := Union[Map[subexpressions[a], Position[a, pat]]];

subexpressions[a_][{pos__}] := a[[pos]];



VariablesIn[a_Const]  := {a};
VariablesIn[a_Var]    := {a};
VariablesIn[a_Symbol] := {a};
VariablesIn[f_[a___]] := Apply[Union, Map[VariablesIn, {a}]];
VariablesIn[_]        := {};



TermsIn[imp[a_, b_]]  := Union[TermsIn[a], TermsIn[b]];
TermsIn[seq[a_, b_]]  := Union[TermsIn[a], TermsIn[b]];
TermsIn[and[a_, b__]] := Apply[Union, Map[TermsIn, {a, b}]];
TermsIn[or[a_, b__]]  := Apply[Union, Map[TermsIn, {a, b}]];
TermsIn[not[a_]]      := TermsIn[a];

TermsIn[p_[a___]]     := Apply[Union, Map[BasicTermsIn, {a}]];
TermsIn[_] := {};

BasicTermsIn[a_Const]  := {a};
BasicTermsIn[a_Var]    := {a};
BasicTermsIn[a_Symbol] := If[ Defined[a], {}, {a}];

BasicTermsIn[ f_[t_, {k_, index__}] ] := 
	Complement[ Apply[Union, Map[BasicTermsIn, {t, index}]], {k} ] /;
		MemberQ[{sum, product, limit}, f];
	
BasicTermsIn[f_[a___]] := 
	If[ Defined[f], Apply[Union, Map[BasicTermsIn, {a}]], {f[a]}];
BasicTermsIn[_] := {};

Defined[Pi] = True;
Defined[Plus] = True;
Defined[Times] = True;
Defined[Power] = True;
Defined[infinity] = True;
Defined[_] = False;







seq[_,True]:=True;
seq[False,_]:=True;
seq[a_,a_]:=True;
seq[and[a___,b_,c___],b_]:=True;



seq[a_,imp[b_,c_]]:=seq[and[b,a],c];
seq[a_,seq[b_,c_]]:=seq[and[b,a],c];



seq[imp[a_,b_],c_]:=seq[or[not[a],b],c];
seq[and[h1___,imp[a_,b_],h2___],c_]:=seq[and[h1,or[not[a],b],h2],c];
seq[seq[a_,b_],c_]:=seq[or[not[a],b],c];
seq[and[h1___,seq[a_,b_],h2___],c_]:=seq[and[h1,or[not[a],b],h2],c];



not[seq[a_,b_]]:=and[a,not[b]];
seq[not[a_],c_]:=seq[True,or[a,c]];
seq[and[h1___,not[a_],h2___],c_]:=seq[and[h1,h2],or[a,c]];
seq[h_,not[a_]]:=seq[and[h,a],False];
seq[h_,or[c1___,not[a_],c2___]]:=seq[and[h,a],or[c1,c2]];



or[a___,seq[h_,c_],b___]:=seq[h,or[a,c,b]];
imp[a_,seq[h_,c_]]:=seq[and[a,h],c];



or[]:=False;
or[a___,NIL,b___]:=or[a,b];
or[x_]:=x;
or[d___,or[a_,b__],c___]:=or[d,a,b,c];
or[d___,imp[a_,b_],c___]:=imp[a,or[d,b,c]];
or[a___,False,b___]:=or[a,b];
or[t1___,True,t2___]=True;
or[a___,b_,c___,b_,d___]:=or[a,b,c,d];
or[___,a_,___,not[a_],___]=True;
or[___,not[a_],___,a_,___]=True;
or[a___,b_,c___,and[___,b_,___],d___]:=or[a,b,c,d];
or[a___,and[___,b_,___],c___,b_,d___]:=or[a,b,c,d];



and[]:=True;
and[a___,NIL,b___]:=and[a,b];
and[x_]:=x;
and[d___,and[a_,b__],c___]:=and[d,a,b,c];
and[a___,True,b___]:=and[a,b];
and[t1___,False,t2___]=False;
and[a___,b_,c___,b_,d___]:=and[a,b,c,d];
and[___,a_,___,not[a_],___]=False;
and[___,not[a_],___,a_,___]=False;
and[a___,b_,c___,or[___,b_,___],d___]:=and[a,b,c,d];
and[a___,or[___,b_,___],c___,b_,d___]:=and[a,b,c,d];



imp[_,True]:=True;
imp[False,_]:=True;
imp[True,x_]:=x;
imp[x_,False]:=not[x];
imp[x_,x_]:=True;
imp[a_,imp[b_,c_]]:=imp[and[a,b],c];



not[True]=False;
not[False]=True;
not[not[a_]]:=a;
not[and[a_,b__]]:=or[not[a],not[and[b]]];
not[or[a_,b__]]:=and[not[a],not[or[b]]];
not[imp[a_,b_]]:=and[a,not[b]];



eqv[a_,b_]=and[imp[a,b],imp[b,a]];



if[_,f_,f_]:=f;
if[test_,f1_,f2_]:=and[imp[test,f1],imp[not[test],f2]];



OperatorRules={Or\[Rule]or,And\[Rule]and,Not\[Rule]not};







all[{a_, b___}, f_] := all[a, all[{b}, f]];
all[{}, f_] := f;
some[{a_, b___}, f_] := some[a, some[{b}, f]];
some[{}, f_] := f;



all[x_, f_] := f /; FreeOfQ[f, x];
all[x_, and[a___, b_, c___]] := and[a, all[x, b], c] /; FreeOfQ[{a, c}, x];
all[x_, or[a___, b_, c___]] := or[a, all[x, b], c] /; FreeOfQ[{a, c}, x];
all[x_, not[b_]] := not[some[x, b]];
all[x_, imp[a_, b_]] := imp[a, all[x, b]] /; FreeOfQ[a, x];
all[x_, imp[a_, b_]] := imp[some[x, a], b] /; FreeOfQ[b, x];
some[x_, f_] := f /; FreeOfQ[f, x];
some[x_, and[a___, b_, c___]] := and[a, some[x, b], c] /; FreeOfQ[{a, c}, x];
some[x_, or[a___, b_, c___]] := or[a, some[x, b], c] /; FreeOfQ[{a, c}, x];
some[x_, not[b_]] := not[all[x, b]];
some[x_, imp[a_, b_]] := imp[a, some[x, b]] /; FreeOfQ[a, x];
some[x_, imp[a_, b_]] := imp[all[x, a], b] /; FreeOfQ[b, x];



all[x_, restrict_, f_] := all[x, imp[restrict, f]];
some[x_, restrict_, f_] := some[x, and[f, restrict]];





VariableNumber=0;
Quantifiers={};
QuantifierNames={};
AllQuantifier=1;
SomeQuantifier=-1;
PosPos=1;
NegPos=-1;

Skolemize[seq[a_,b_],pos_,vars_]:=
  	
  seq[Skolemize[a,-pos,vars],Skolemize[b,pos,vars]];
Skolemize[and[a_,b__],pos_,vars_]:=
  	
  and[Skolemize[a,pos,vars],Skolemize[and[b],pos,vars]];
Skolemize[HoldPattern[and[a_]],pos_,vars_]:=Skolemize[a,pos,vars];
Skolemize[or[a_,b__],pos_,vars_]:=
  	
  or[Skolemize[a,pos,vars],Skolemize[or[b],pos,vars]];
Skolemize[HoldPattern[or[a_]],pos_,vars_]:= Skolemize[a,pos,vars];
Skolemize[imp[a_,b_],pos_,vars_]:=
  	
  imp[Skolemize[a,-pos,vars],Skolemize[b,pos,vars]];
Skolemize[not[a_],pos_,vars_]:= not[Skolemize[a,-pos,vars]];
Skolemize[all[x_,a_],pos_,vars_]:=
  	
  If[Positive[pos],Universal[x,a,pos,vars],Existential[x,a,pos,vars]];
Skolemize[some[x_,a_],pos_,vars_]:=
  	
  If[Negative[pos],Universal[x,a,pos,vars],Existential[x,a,pos,vars]];

Skolemize[a_,_,_]:=a;

Universal[ x_,a_,pos_,vars_ ]:=
  Block[{newvar},
    	AppendTo[Quantifiers,AllQuantifier];
    	AppendTo[QuantifierNames,x];
    	newvar=Var[V[++VariableNumber]];
    	Skolemize[a/.\[InvisibleSpace]x\[Rule]newvar,pos,Append[vars,newvar]]
    ];

Existential[ x_,a_,pos_,vars_ ]:=
  Block[{newfun},
    	AppendTo[Quantifiers,SomeQuantifier];
    	AppendTo[QuantifierNames,x];
    	newfun=Funct[V[++VariableNumber],vars];
    	Skolemize[a/.\[InvisibleSpace]x\[Rule]newfun,pos,vars]
    ];



CleanUp[f_] := f /. {Funct[v_, ___] :> v, Var[v_] :> v};
Requantify[_, subrules[a_]] :=  Rename[CleanUp[a]];
Requantify[PosPos, f_] := Rename[ AddQuantifiers[ Quantifiers, CleanUp[f]] ];
Requantify[NegPos, f_] := Rename[ AddQuantifiers[-Quantifiers, CleanUp[f]] ];
Rename[f_] := f /. {V[n_] :> QuantifierNames[[n]]};
AddQuantifiers[{}, f_] := f;
AddQuantifiers[{a___, 1}, f_]  := AddQuantifiers[{a},  all[V[Length[{a}]+1], f]];
AddQuantifiers[{a___, -1}, f_] := AddQuantifiers[{a}, some[V[Length[{a}]+1], f]];







disjunct[ h_, or[a_, b__]] := orelse[disjunct[h, a], disjunct[h, or[b]]];



disjunct[h_, c_] := 
        orelse[(MatchingState = MShypothesis; conjunct[h, c]),  
               (MatchingState = MSfacts; conjunct[Facts[Head[c]], c ])];
               





conjunct[and[a_, b__],  c_] :=  orelse[conjunct[a, c],  conjunct[and[b],  c]];
conjunct[h_, c_] :=  
Block[{u},
        If[MatchingState === MSfacts, CurrentLemma = h ]; 
        If[FalseQ[ u = unify[h, c]], Return[False] ];
        SucceedWith[ 
        	If[ MatchingState === MShypothesis, 
                  PrintResult["matching hypothesis with", u], 
                  (print["matching lemma"]; 
                   PrintLemma[CurrentLemma];
                   PrintResult["with", u])];
			TryOtherBranches[u]]
];





unify[a_, a_] := subrules[];



unify[ a_, Var[n_] ]    := subrules[{Var[n] -> a}]  /; FreeOfQ[a, n];
unify[ Var[n_], a_ ]    := subrules[{Var[n] -> a}]  /; FreeOfQ[a, n];
unify[ Var[n_] + a_, 0] := subrules[{Var[n] -> -a}] /; FreeOfQ[a, n];
unify[-Var[n_] + a_, 0] := subrules[{Var[n] -> a }] /; FreeOfQ[a, n];



unify[a_ == b_, c_ == d_] := unify[a - b, c - d];
unify[a_ <= b_, c_ <= d_] := unify[a - b, c - d];
unify[ a_ < b_, c_ < d_ ] := unify[a - b, c - d];



unify[a_ + b_., a_ + c_.] := unify[b, c];
unify[a_ + b_, c_ + d_] := 
Block[{u}, 
	subrules[u, unify[apply[u, b], apply[u, d]]] /; !FalseQ[u = unify[a, c]]
];

unify[a_ b_., a_ c_.] := unify[b, c];
unify[a_ b_, c_ d_] := 
Block[{u}, 
	subrules[u, unify[apply[u, b], apply[u, d]]] /; !FalseQ[u = unify[a, c]]
];

unify[1/Var[n_], a_] := subrules[{Var[n] -> 1/a}] /; FreeOfQ[a, n];
unify[a_, 1/Var[n_]] := subrules[{Var[n] -> 1/a}] /; FreeOfQ[a, n];



unify[f_[a___], f_[b___]] := unifylist[{a}, {b}];



unify[_, _] := False;



unifylist[_, False] := False;
unifylist[False, _] := False;
unifylist[{}, {}]   := subrules[];
unifylist[{}, {__}] := False;
unifylist[{__}, {}] := False;
unifylist[{a_}, {b_}] := unify[a, b];
unifylist[{a_, x___}, {b_, y___}] := 
With[{u = unify[a, b]},
	subrules[u, unifylist[apply[u, {x}], apply[u, {y}]]]
];





subrules[] = True;
subrules[___, False, ___]  := False;
subrules[a___, True, b___] := subrules[a, b];
subrules[a___, subrules[b__], c___] := subrules[a, b, c];
subrules[{a__}, {b__}, c___] := subrules[Union[{a}, {b}], c];
subrules[{a___, b_, c___, b_, d___}, e___] := subrules[{a, b, c, d}, e];



apply[False, a_] := False;
apply[True,  a_] := a;
apply[subrules[s_], term_] := term //. s;





$StrongSimpBnd = 20;



OperatorRules={Or\[Rule]or,And\[Rule]and,Not\[Rule]not};
SimplifyRules:= Dispatch[
    Join[ OperatorRules,AbsRule,ExpressionRules,
                MaxMinRules,EquationRules,InequalityRules] ];

WeakSimplify[
    A_]:=
  	(Simplify[ 
          A//.\[InvisibleSpace]SimplifyRules \
]/.\[InvisibleSpace]RulesFromGiven)/.\[InvisibleSpace]RulesForRelations;



SimplifyMethods=
  {
    {"reduces to",WeakSimplify},
    {"simplify formula using local context",
      SimplifyUsingContext},{"check denominators",CheckSoundness},
    {"calculate summations via Gosper",SimplifySummation[1]},
    {"calculate summations",SimplifySummation[2]},
    {"simplify summations",SimplifySummation[3]},
    {"simplify products",SimplifyProduct},
    {"simplify limits",SimplifyLimit}
    };



TrySimplifyMethods[A_] := Fold[ tryop, A, SimplifyMethods ];

tryop[A_,{msg_,op_}] := 
  With[ {AA = op[A]}, If[A=!=AA,AppendTo[SimpMsgList,{msg,A}]]; AA ]





StrongSimplify[A_] := 
(
	SimpMsgList = {};
	FixedPoint[ TrySimplifyMethods, A, $StrongSimpBnd ]
);





SimplifyUsingContext[ or[a_, b__] ] := 
	UsingContext[Map[SimplifyUsingContext, or[a, b]]];
SimplifyUsingContext[ and[a_, b__] ] := 
	UsingContext[Map[SimplifyUsingContext, and[a, b]]];
SimplifyUsingContext[ imp[a_, b_] ] := 
	UsingContext[Map[SimplifyUsingContext, imp[a, b]]];
SimplifyUsingContext[ seq[a_, b_] ] := 
	UsingContext[Map[SimplifyUsingContext, seq[a, b]]];
SimplifyUsingContext[A_] := A;



UsingContext[and[a_, b__]] := SimplifyAnd[True, and[a, b]];
UsingContext[or[a_, b__]]  := SimplifyOr[False, or[a, b]];
UsingContext[imp[a_, b_]]  := (imp[AssumeFalse[#, a], #]&) [AssumeTrue[a, b]];
UsingContext[seq[a_, b_]]  := (seq[AssumeFalse[#, a], #]&) [AssumeTrue[a, b]];
UsingContext[A_] := A;



SimplifyAnd[ A_, and[a_, b__] ] := 
	SimplifyAnd[ and[ AssumeTrue[a, A], a], AssumeTrue[a, and[b]] ];
SimplifyAnd[ A_, a_ ] := and[ AssumeTrue[a, A], a ];



SimplifyOr[ A_, or[a_, b__]] := 
	SimplifyOr[ or[ AssumeFalse[a, A], a], AssumeFalse[a, or[b]] ];
SimplifyOr[ A_, a_] := or[AssumeFalse[a, A], a];



AssumeTrue[ h_, A_ ]  :=  A /. RulesFrom[h];
AssumeFalse[ h_, A_ ] :=  A /. RulesFrom[not[h]];



RulesFrom[ a_==b_ ] := 
	{(x_ <= y_) :> True /; (a-b) - (x-y) === 0 || (a-b) + (x-y) === 0,
	 (x_ < y_) :> False /; (a-b) - (x-y) === 0 || (a-b) + (x-y) === 0,
	 (x_ == y_) :> True /; (a-b) - (x-y) === 0 || (a-b) + (x-y) === 0};



RulesFrom[a_ < b_] :=
	{(x_ <= y_) :> True  /; (a-b) - (x-y) === 0,
	 (x_ <= y_) :> False /; (a-b) + (x-y) === 0,
	 (x_ <  y_) :> True  /; (a-b) - (x-y) === 0,
	 (x_ <  y_) :> False /; (a-b) + (x-y) === 0,
	 (x_ == y_) :> False /; (a-b) - (x-y) === 0 || (a-b) + (x-y) === 0};



RulesFrom[a_ <= b_] :=
	{(x_ <= y_) :> True  /; (a-b) - (x-y) === 0,
	 (x_ <= y_) :> (x == y) /; (a-b) + (x-y) === 0,
	 (x_ <  y_) :> not[x == y] /; (a-b) - (x-y) === 0,
	 (x_ <  y_) :> False /; (a-b) + (x-y) === 0};



RulesFrom[not[a_ == b_]] :=
	{(x_ == y_) :> False /; (a-b) - (x-y) === 0 || (a-b) + (x-y) === 0,
	 (x_ <= y_) :> (x < y) /; (a-b) - (x-y) === 0 || (a-b) + (x-y) === 0};



RulesFrom[and[a_, b__]] := Union[RulesFrom[a], RulesFrom[and[b]]];



RulesFrom[ imp[__] ]:={};
RulesFrom[ or[a_,b__] ]:={};
RulesFrom[ not[A_] ]:={A\[Rule]False};
RulesFrom[ H_ ]:={H\[Rule]True};



SimplifyIfChanged[ A_, B_ ] := If[ A =!= B, StrongSimplify[B], B ];



CheckSoundness[s_] := 
	If[ FreeOfQ[s, over], s, WeakSimplify[ AddSoundnessConstraint[s, 1]] ];



AddSoundnessConstraint[ seq[h_, c_], pos_ ] :=
	seq[ AddSoundnessConstraint[h, -pos], AddSoundnessConstraint[c, pos] ];
AddSoundnessConstraint[ imp[h_, c_], pos_ ] :=
	imp[ AddSoundnessConstraint[h, -pos], AddSoundnessConstraint[c, pos] ];
AddSoundnessConstraint[ or[a_, b__], pos_ ] :=
	Map[ AddSoundnessConstraint[#, pos]&, or[a, b] ];
AddSoundnessConstraint[ and[a_, b__], pos_ ] :=
	Map[ AddSoundnessConstraint[#, pos]&, and[a, b] ];



AddSoundnessConstraint[ A_, _ ] := A  /; FreeOfQ[A, over];
AddSoundnessConstraint[ A_, PosPos ] := 
	and[ Apply[ and, Map[Soundness[A], Position[A, _over]]], A ] //. 
		{over[a_,b_] :> a/b};
AddSoundnessConstraint[ A_, NegPos ] :=
	imp[ Apply[and, Map[Soundness[A], Position[A, _over]]], A ] //. 
		{over[a_, b_] :> a/b};



Soundness[A_][{a__}] := (not[A[[a]][[2]] == 0]);







SubstEquation[seq_]:=
  Block[{s0,s1},
    	s0=FixedPoint[Substitute,seq]/.\[InvisibleSpace]GivenIdentities;
    	s1=SimplifyIfChanged[seq,s0];
    	If[s1=!=seq,print["substitute using equation"];
      		PrintMessage[SimpMsgList]
      	];
    	s1
    ];





\!\(IsVarConsSymbol[a_] := 
    Head[a] === Var || Head[a] === Const || 
      Head[a] === Symbol; \n\[IndentingNewLine]
  Substitute[seq[and[h1___, a_ == b_, h2___], c_]] := 
    seq[and[h1, h2] /. \[InvisibleSpace]a \[Rule] b, 
        c /. \[InvisibleSpace]a \[Rule] b] /; IsVarConsSymbol[a]; \n
  Substitute[seq[a_ == b_, c_]] := 
    seq[True, c /. \[InvisibleSpace]a \[Rule] b] /; IsVarConsSymbol[a]; \n
  Substitute[seq[and[h1___, a_\^n_ == b_, h2___], c_]] := 
    seq[and[h1, h2], c] /; IsVarConsSymbol[a] && FreeOfQ[{h1, h2, c}, a]; \n
  Substitute[seq[a_\^n_ == b_, c_]] := 
    seq[True, c] /; IsVarConsSymbol[a] && FreeOfQ[c, a]; \n
  Substitute[seq[and[h1___, a_ == b_, h2___], c_]] := 
    seq[and[and[h1, h2] /. \[InvisibleSpace]a \[Rule] b, a == b], 
        c /. \[InvisibleSpace]a \[Rule] b] /; \(! FreeOfQ[{h1, h2, c}, 
          a]\); \n
  Substitute[seq[a_ == b_, c_]] := 
    seq[a == b, c /. \[InvisibleSpace]a \[Rule] b] /; \(! FreeOfQ[c, a]\); \n
  Substitute[s_] := s; \)







Initialize[] := 
(
	While[!FreeOfQ[CurrentPath, Temp], EndSection[]];
    RulesGivenIn[CurrentSection] = {};
	GivenIdentitiesAt[CurrentSection] = {};
    clear[GivenUpperAt[CurrentSection]];
    clear[GivenLowerAt[CurrentSection]]; 
	GivenUpperAt[CurrentSection][_] := {};
	GivenLowerAt[CurrentSection][_] := {};
	ResetKnownBounds[];
	BranchStack = {};
);



StartSection[] := StartSection[ Unique["temp"] ];
StartSection[a_] := 
(
	printsec["StartSection"]; 
	ResetKnownBounds[]; 
	PrependTo[CurrentPath, a]; 
);





EndSection[] := 
(
	printsec["EndSection"]; 
    clear[GivenUpperAt[CurrentSection]];
    clear[GivenLowerAt[CurrentSection]]; 
    GivenUpperAt[CurrentSection] = .; 
    GivenLowerAt[CurrentSection] = .; 
    RulesGivenIn[CurrentSection] = {}; 
    GivenIdentitiesAt[CurrentSection] = {}; 
    CurrentPath = Drop[CurrentPath, 1]; 
    RulesGivenIn[a] = {}; ResetKnownBounds[]; 
);

ResetKnownBounds[] :=  
(
	KnownUpper = Table[Unknown, {NumberOfTerms}]; 
    KnownLower = Table[Unknown, {NumberOfTerms}]; 
); 



GivenIdentitiesAt[_] := {};

RulesGivenIn[_] := {};
GivenFormulasIn[_] := {};

CurrentPath = {};
CurrentSection := CurrentPath[[1]];





SetAttributes[ EvaluateAssuming, HoldRest ];

EvaluateAssuming[ True, result_ ] := result;
EvaluateAssuming[ cond_, result_ ] := 
Block[{tempresult},
	StartSection[];
		AddKnowledge[cond, CurrentSection];
		tempresult = result;
	EndSection[];
	tempresult
];





SetAttributes[ProveAndSave, {HoldAll}];
ProveAndSave[form_]  := ( Prove[form]; Given[form] );
ProveAndSave[form__] := ( Prove[and[form]]; Given[form] );



ProveAndSaveTo[form__, a_] := (Prove[and[form]]; GivenTo[and[form], a]);





Given[a__] := GivenTo[ and[a], CurrentSection ];



GivenTo[form_, section_] := AddKnowledge[ WeakSimplify[form], section];




AddKnowledge[and[a_, b__], section_] := 
(
	AddKnowledge[a, section]; 
	AddKnowledge[and[b], section] 
);
AddKnowledge[form_, section_] := 
(
	AppendTo[GivenFormulasIn[section], form];
	(* if given a inequality, add some knowledge about the upper or lower bounds *)
	If[Head[form] == LessEqual,
		AddUpperBound[form[[1]] - form[[2]], 0, section]];
	If[Head[form] == Less,
		AddUpperBound[form[[1]] - form[[2]], Strict[0], section]];
	(* if given a identity, add it to the set of given identities, so
	   it can be used for substitution *)
	If[Head[form]==Equal, 
		AddIdentity[form, section]];
	(* use the given formula as simplify rules *)
	AddSimplifyRules[form, section];
);





GivenIdentities := Apply[ Union, Map[GivenIdentitiesAt, CurrentPath] ];





RulesFromGiven := Apply[Union, Map[RulesGivenIn, CurrentPath]];
GivenFormulas[] := Apply[Union, Map[GivenFormulasIn, CurrentPath]];





GivenUpperAt[section_] := 
(
	GivenUpperAt[section] = Unique["Upper"];
	GivenUpperAt[section][_] := {}; 
	GivenUpperAt[section]
);
GivenLowerAt[section_] := 
(
	GivenLowerAt[section] = Unique["Lower"];
	GivenLowerAt[section][_] := {}; 
	GivenLowerAt[section]
);





GivenUpper[n_] := Apply[Union, Map[(GivenUpperAt[#][n])&, CurrentPath]];
GivenLower[n_] := Apply[Union, Map[(GivenLowerAt[#][n])&, CurrentPath]];





AddUpperBound[ f1_ + f2_, upper_, section_] := 
(
	AddUpperBound[f1, upper - f2, section];
	AddUpperBound[f2, upper - f1, section]
);
AddLowerBound[f1_ + f2_, lower_, section_] := 
(
	AddLowerBound[f1, lower - f2, section];
	AddLowerBound[f2, lower - f1, section]
);



\!\(AddUpperBound[n_?NumberQ\ f_, upper_, section_] := 
    If[n > 0, AddUpperBound[f, upper\/n, section], 
      AddLowerBound[f, upper\/n, section]]; \n
  AddUpperBound[f_\ g_\^\(n_Integer?Negative\ e_. \), upper_, section_] := 
    AddUpperBound[f, upper\ g\^\(\(-n\)\ e\), section] /; 
      EvenQ[n] || WeakSimplify[g \[GreaterEqual] 0]; \n\[IndentingNewLine]
  AddUpperBound[f_\ g_\^\(n_Integer?Negative\ e_. \), upper_, section_] := 
    AddLowerBound[f, upper\ g\^\(\(-n\)\ e\), section] /; 
      OddQ[n] && WeakSimplify[g \[LessEqual] 0]; \)

\!\(AddLowerBound[n_?NumberQ\ f_, lower_, section_] := 
    If[n > 0, AddLowerBound[f, lower\/n, section], 
      AddUpperBound[f, lower\/n, section]]; \n
  AddLowerBound[f_\ g_\^\(n_Integer?Negative\ e_. \), upper_, section_] := 
    AddLowerBound[f, upper\ g\^\(\(-n\)\ e\), section] /; 
      EvenQ[n] || WeakSimplify[g \[GreaterEqual] 0]; \n\[IndentingNewLine]
  AddLowerBound[f_\ g_\^\(n_Integer?Negative\ e_. \), upper_, section_] := 
    AddUpperBound[f, upper\ g\^\(\(-n\)\ e\), section] /; 
      OddQ[n] && WeakSimplify[g \[LessEqual] 0]; \)





AddUpperBound[f_,upper_,section_]:=
  (
    If[NumberQ[f]||!FreeOfQ[upper,f],Return[]];
    ResetKnownBounds[];
    PrependTo[GivenUpperAt[section][TermNumber[f]],upper]
    );

AddLowerBound[f_,lower_,section_]:=
  (
    If[NumberQ[f]||!FreeOfQ[lower,f],Return[]];
    ResetKnownBounds[];
    PrependTo[GivenLowerAt[section][TermNumber[f]],lower]
    );



AddIdentity[a_==b_,section_]:=AppendTo[GivenIdentitiesAt[section],a\[Rule]b];



AddSimplifyRules[form_,section_]:=
  RulesGivenIn[section]=RulesFrom[form]\[Union]RulesGivenIn[section];





FalseQ[x_] := (x === False);





SetAttributes[orelse, HoldRest];
orelse[f_] := f;
orelse[False, f2__] := orelse[f2];
orelse[f1_, f2__] := f1;



BranchStackEmpty[]:=BranchStack==={};
BranchStackPush[a_]:=PrependTo[BranchStack,a];
BranchStackPop[]:=With[{temp=First[BranchStack]},
    BranchStack=Rest[BranchStack];temp];



OpenDefinition[seq_] := 
Block[{s0}, 
	s0 = Skolemize[seq /. UserFunctions, NegPos, {}];
	If[ s0 =!= seq, print["open definition"]];
	Return[s0]
];



curinstantiation = True;
TheoremsProved = {};
ProveHistory = {};





SetAttributes[ProveByInduction,{HoldRest}];

ProveByInduction[{n_,n0_,nbases_},f_]:=
  Module[{k},
    StartProof;
    ProveHistory={};
    StartSection[Temp];
    label="1";
    PrintBold["Theorem :"];
    PrintSequent[HoldForm[f]];
    AppendTo[TheoremsProved,Printform[HoldForm[f]]];
    PrintBold["Proof :"];
    print["prove by induction on ",ToString[n],"\n"];
    integer[n]=True;
    
    For[k=0,k<nbases,k++,
      	print["base case with ",ToString[n]," = ",ToString[n0+k]];
      	If[   
        FalseQ[ Verify[ 
            seq[ True,
              Skolemize[ f/.\[InvisibleSpace](n\[Rule]n0+k),NegPos,{}]]]],
        		PrintResult["RESULT",Fail];
        		sequent=False;
        		EndSection[];
        		EndProof;
        		Return[]
        	];
      ];
    
    print["induction step"];
    Given[n\[GreaterEqual]n0];
    printmssg["ProveByInduction: before Verify "];
     Verify[  
      seq[Apply[ and,
          Map[Skolemize[f/.(\[InvisibleSpace]n\[Rule]n+#-1),PosPos,{}]&,
            Range[nbases]]],
        Skolemize[f/.(\[InvisibleSpace]n\[Rule]n+nbases),NegPos,{}]]];
    printmssg["ProveByInduction: after Verify "];
    
    EndSection[];
    EndProof;
    ];

ProveByInduction[{n_,n0_},f_]:=ProveByInduction[{n,n0,1},f];
ProveByInduction[n_,f_]:=ProveByInduction[{n,0},f];



SetAttributes[Prove,{HoldFirst}];
Prove[f_]:=
  (
    	StartProof;
    	ProveHistory={};
    	StartSection[Temp];
    	PrintBold["Theorem :"];
    	PrintSequent[HoldForm[f]];
    	AppendTo[TheoremsProved,Printform[HoldForm[f]]];
    	PrintBold["Proof :"];
    	sequent=seq[True,Skolemize[f,NegPos,{}]];
    	label="1";
    	Verify[sequent];
    	EndSection[];
    	EndProof;
    );



VerifyIfNotSame[t_,s_]:=If[s=!=t,Verify[s],False];

Verify[s_]:=
  Block[{seq},
    	seq=StrongSimplify[s];
    	PrintMessage[SimpMsgList];
    	If[DepthCount>0,Return[TryProving[seq]]];
    	orelse[ TryProving[seq],
      		RewriteAndProve[seq],
      		VerifyIfNotSame[seq,OpenDefinition[seq]],
      		PrintResult["after all",Fail];False]
    ];





RewriteAndProve[s_]:=orelse[
    TryProveIfNotSame[sequent,sequent=SubstEquation[sequent]],
    TryProveIfNotSame[sequent,sequent=Rewriting[sequent]],
    TryInduction[sequent],
    TryProveIfNotSame[sequent,sequent=RewriteSum[sequent]],
    TryProveIfNotSame[sequent,sequent=RewriteTrigg[sequent]],
    TryProveIfNotSame[sequent,sequent=Factorize[sequent]],
    TryProveIfNotSame[sequent,sequent=SolveEquation[sequent]],
    If[ s =!=sequent,RewriteAndProve[sequent],False ]
    ];





TryProveIfNotSame[ t_, s_] := If[ s =!= t, TryProving[s], False];

TryProving[s_] := 
Block[{temp, temph},
	PrintSequent[s];
	SucceedWith[
		If[ TrueQ[s], 
			TryOtherBranches[True],
			orelse[ Imply[s], ProveUsingBound[s]]]
	]
];







Imply[seq[h_, a_  ==  b_]] :=  
Block[{u, u1, temph},
	u1 /;  (!FalseQ[u = unify[a, b]] && 
	        !FalseQ[u1 = SucceedWith[ PrintResult["equation", u]; 	
	        						  TryOtherBranches[u]]])
];
Imply[seq[h_, or[c1___, a_  ==  b_,  c2___]]] :=  
Block[{u,u1, temph},
	u1 /; (!FalseQ[u = unify[a, b]] && 
	       !FalseQ[u1 = SucceedWith[ PrintResult["equation", u];
	       							 TryOtherBranches[u]]])
];





Imply[seq[h_, a_  <=  b_]] :=  
Block[{u,u1},
	u1 /;	( !FalseQ[u = unify[a, b]] && 
	          !FalseQ[u1 = SucceedWith[ PrintResult["inequality", u];
	          							TryOtherBranches[u]]] )
];

Imply[seq[h_, or[c1___, a_  <=  b_,  c2___]]] := 
Block[{u,u1},
	u1 /;  (!FalseQ[u = unify[a, b]] && 
	        !FalseQ[u1 = SucceedWith[ PrintResult["inequality", u];
	       							  TryOtherBranches[u]]])
];



Imply[seq[Var[x_] == f_, c_]] := 
Block[{u,u1},
	u1 /; ( FreeOfQ[f, x] && 
	        !FalseQ[u1 = SucceedWith[ 
	        		PrintResult["add restriction:", x != f]; 
				 Restriction = and[Restriction, not[Var[x] == f]]; 
				 Given[not[Var[x] == f]];
				 TryOtherBranches[True]]] )
];

Imply[seq[and[h1___, Var[x_] == f_, h2___], c_]] := 
Block[{u,u1},
	u1 /;
	( FreeOfQ[f, x] && 
	  !FalseQ[u1 = SucceedWith[ PrintResult["add restriction:", x != f]; 
			 Restriction = and[Restriction, not[Var[x] == f]]; 
			 Given[not[Var[x] == f]];
			 TryOtherBranches[True]]])
];





Imply[seq[h_, c_]] := u /; (!FalseQ[SucceedWith[u = disjunct[h, c]]]); 





simple[_or] = simple[_and] = simple[_imp] = NIL;
simple[a_] := a;





Imply[seq[h_, and[a_, b__]]] := 
(
	print["and split \n"];
	SequentialTry[ seq[h, a], seq[and[h, simple[a]], and[b]]]
);





Imply[seq[h_, or[c1___, and[a_, b__], c2___]]] :=
(
	print["and split\n"];
	SequentialTry[ seq[h, or[c1, a, c2]], seq[and[h, simple[a]],  or[c1, and[b], c2]]]
);





Imply[seq[or[a_, b__], c_]] := 
(
	print["cases\n"];
	SequentialTry[ seq[a, c], seq[or[b], or[c, simple[a]]]]
);



Imply[seq[and[h1___, or[a_, b__], h2___], c_]] := 
(
	print["cases\n"];
	SequentialTry[ seq[and[h1, a, h2],  c],
		seq[and[h1, or[b], h2],  or[c, simple[a]]]]
);



Imply[seq[h0_, or[c0___, c_, c1___]]] := 
Block[{u}, 
	u /; !FalseQ[u = Backchain[seq[h0, or[c0, c1]], 
				Lemmas[Head[c]], c]]
];

Imply[seq[h0_, c_]] := 
Block[{u}, 
	u /; !FalseQ[u = Backchain[seq[h0, False], Lemmas[Head[c]], c]]
];



Imply[s_] := False;





Backchain[s_, and[a_,rest__], c_] :=
	orelse[ Backchain[s, a, c],	Backchain[s, and[rest], c] ];



Backchain[s_, imp[b_, c1_], c_] :=   
Block[{u1},
	MatchingState = MSlemma;
	CurrentLemma  = imp[b, c1];
	BranchStackPush[{or[b, s], 0}];
	(* if the backchaining rule can be applied here *)
	If[ FalseQ[u1 = conjunct[c1, c]], BranchStackPop[] ];
	u1
];



Backchain[___] :=  False; 





TryPart[f_, lab_] :=  
If[label===0, 
	(label = templ; print["back chaining"]; Verify[f]),
	(SetAndPrintLabel[StringJoin[label, ".", lab]]; Verify[f])
]; 





SequentialTry[p1_, p2_] := 
Block[{u1},
	BranchStackPush[{p2, label}];
	If[ FalseQ[u1 = TryPart[p1, "1"]], BranchStackPop[]];
	u1
];
	
TryOtherBranches[u_] := 
Block[{	u1, tempseq, templ = label, 
	curinstantiation = subrules[curinstantiation, u],
	tempstack = BranchStack},
	If[BranchStackEmpty[], 
		If[FalseQ[u1 = TryRestrict[curinstantiation]], 
			print["back tracking"]; SetAndPrintLabel[templ]; 
			PrintSequent[sequent];
			BranchStack = tempstack; Return[False],
		Return[u1]]];
	tempseq = BranchStackPop[];
	label = tempseq[[2]];
	tempseq = tempseq[[1]];
	If[FalseQ[u1 = TryPart[apply[curinstantiation, tempseq], "2"]], 
		print["back tracking"]; SetAndPrintLabel[templ]; 
		PrintSequent[sequent]; 
		BranchStack = tempstack; Return[False]];
	(* then the second part *)
	TryOtherBranches[u1]
];





Restriction = True;

TryRestrict[u_] := 
Block[{temp = Restriction, temp0}, 
	Restriction = True;
	If[temp === True, Return[u]];
	print["check restrict on instantiation"];
	If[ FalseQ[temp0 = Verify[seq[True, apply[u, temp]]]], 
		Restriction = temp; Return[False]
	];
	subrules[u, temp0]
];





TryInduction[s_]:=TryInductionOn[s,VariablesIn[s]];
TryInductionOn[s_,{}]=False;
TryInductionOn[s_,{x_,rest___}]:=
  orelse[ SucceedWith[InductionOn[x,DeriveInductScheme[x,s]]],
    		TryInductionOn[s,{rest}]];

InductionOn[x_,{}]:=False;
InductionOn[x_,{-\[Infinity],{main_,others_}}]:=False;
InductionOn[x_,{n_,{main_,others_}}]:=Block[{temp},
    If[!FreeOfQ[InductionVariables,x],Return[False]];
    temp=EvaluateAssuming[ and[n\[LessEqual]x,integer[x]],
        WeakSimplify[main]];
    AppendTo[InductionVariables,x];
    print["prove"];PrintSequent[temp];
    print["by induction on ",ToString[x],"\n"];
    print["base case with ",ToString[x]," = ",ToString[n]];
    If[ FalseQ[Verify[or[others,temp/.\[InvisibleSpace]x\[Rule]n]]],
      	PrintResult["RESULT",Fail];
      	InductionVariables=Drop[InductionVariables,-1];
      	Return[False]
      ];
    print["induction step"];
    temp=Verify[
        or[others,
          seq[and[integer[x],n\[LessEqual]x,temp],
            temp/.\[InvisibleSpace]x\[Rule]x+1]]];
    InductionVariables=Drop[InductionVariables,-1];
    temp
    ];



DeriveInductScheme[x_, f_] := {GetBase[x, f], SeperateMain[x, f, {False, False}]};

SeperateMain[x_,seq[True,or[a_,b__]],{main_,others_}]:=If[ FreeOfQ[a,x],
    	SeperateMain[x,seq[True,or[b]],{main,or[others,a]}],
    	SeperateMain[x,seq[True,or[b]],{or[a,main],others}]
    ];

SeperateMain[x_,seq[True,c_],{main_,others_}]:=
  If[ FreeOfQ[c,x],{main,or[others,c]},{or[c,main],others}];

SeperateMain[x_,seq[and[a_,b__],c_],{main_,others_}]:=If[ FreeOfQ[a,x],
    	SeperateMain[x,seq[and[b],c],{main,seq[a,others]}],
    	SeperateMain[x,seq[and[b],c],{seq[a,main],others}]
    ];
SeperateMain[x_,seq[h_,c_],{main_,others_}]:=
  If[ FreeOfQ[h,x],
    	SeperateMain[x,seq[True,c],{main,seq[h,others]}],
    	SeperateMain[x,seq[True,c],{seq[h,main],others}]
    ];
SeperateMain[x_,a_,{main_,others_}]:=
  If[ FreeOfQ[a,x],{main,or[others,a]},{or[a,main],others}];

GetBase[x_,f_]:=EvaluateAssuming[ not[f],
    If[ !TrueQ[ WeakSimplify[integer[x]]]||
        	   !useful[x,f,
            StrongSimplify[f/.\[InvisibleSpace]x\[Rule]x+1]],
      		-\[Infinity],
      		SelectBase[Lower[x]]]
    ];

\!\(useful[x_, f_, seq[h_, c_]] := useful[x, seq[h, f], c]; \n
  useful[x_, f_, or[a_, b__]] := useful[x, f, a] && useful[x, f, or[b]]; \n
  useful[x_, f_, and[a_, b__]] := useful[x, f, a] && useful[x, f, and[b]]; \n
  useful[x_, f_, 
      imp[a_, b_] | a_ \[LessEqual] b_ | a_ < b_ | a_ == b_ | a_ + b_ | 
        a_\ b_ | a_\^b_] := 
    useful[x, f, a] && useful[x, f, b]; \n\[IndentingNewLine]
  useful[x_, f_, ff_] := \[IndentingNewLine]\t
    PolynomialQ[ff, x] || FreeOfQ[ff, x] || \(! FreeOfQ[f, ff]\); \)

SelectBase[{S[a_],b___}]:=SelectBase[{a,b}];
SelectBase[{a_?NumberQ,b___}]:=Max[Ceiling[a],SelectBase[{b}]];
SelectBase[{a_,b___}]:=SelectBase[{b}];
SelectBase[{}]:=-\[Infinity];







AddLemma[lemma_] := 
	AddToDataBase[ Skolemize[WeakSimplify[lemma], PosPos, {}]];

AddToDataBase[and[a_, b__]] := (AddToDataBase[a]; AddToDataBase[and[b]];);
AddToDataBase[imp[a_, and[b_, c__]]] := 
	(AddToDataBase[imp[a, b]]; AddToDataBase[imp[a, and[c]]];);

AddToDataBase[imp[a_, b_]] := (Lemmas[Head[b]] = and[imp[a, b], Lemmas[Head[b]]];);

AddToDataBase[a_] := (Facts[Head[a]] = and[a, Facts[Head[a]]];);





AddDefinition[f_==b_]:=AppendTo[UserFunctions,f\[RuleDelayed]b];



AddRule[rule_]:=PrependTo[UserRules,GetRule[Skolemize[rule,PosPos,{}]]];

GetRule[a_==
      b_]:=(a/.\[InvisibleSpace]Var[n_]\[RuleDelayed]
          n_)\[Rule](b/.\[InvisibleSpace]Var[n_]\[Rule]n);
GetRule[imp[cond_,a_==b_]]:=
  ConditionalRule[cond/.\[InvisibleSpace]Var[n_]\[Rule]n,
    a/.\[InvisibleSpace]Var[n_]\[Rule]n_,
    b/.\[InvisibleSpace]Var[n_]\[Rule]n];
ConditionalRule[cond_,left_,right_]:=
  left\[RuleDelayed]right/;WeakSimplify[cond];





Rewriting[s_]:=
  Module[{s0,s1},
    	s0=EvaluateAssuming[not[s],s//.\[InvisibleSpace]UserRules];
    	s1=SimplifyIfChanged[s,s0];
    	If[s1=!=s,print["using rewrite rules"];PrintMessage[SimpMsgList]];
    	s1
    ];







AddLemma[ all[{f,n,x,x0,min},
    imp[ and[Continuous[f,{x,x0}],
        UniformlyConvergent[sum[f,{n,min,infinity}],{x,x0-sigma,x0+sigma}]],
      Continuous[sum[f,{n,min,infinity}],{x,x0}]]] ];



AddLemma[ 
  all[{f,n,x,c1,c2,min},
    imp[ some[f1,
        and[imp[and[c1<x,x<c2],Abs[f]\[LessEqual]f1],IsConstant[f1,x],
          Convergent[sum[f1,{n,min,infinity}]]]],
      UniformlyConvergent[sum[f,{n,min,infinity}],{x,c1,c2}]]]];



AddLemma[all[{k,low,up,f},
    imp[imp[and[low\[LessEqual]k,k\[LessEqual]up],0\[LessEqual]f],
      0\[LessEqual]sum[f,{k,low,up}]]]];
AddLemma[all[{k,low,up,f},
    imp[imp[and[low\[LessEqual]k,k\[LessEqual]up],f\[LessEqual]0],
      sum[f,{k,low,up}]\[LessEqual]0]]];
AddLemma[all[{k,low,up,f},
    imp[imp[and[low\[LessEqual]k,k\[LessEqual]up],f==0],
      sum[f,{k,low,up}]==0]]];
AddLemma[all[{k,low,up,f,cond},
    imp[imp[and[low\[LessEqual]k,k\[LessEqual]up,cond],0\[LessEqual]f],
      0\[LessEqual]sum[f,{k,low,up,cond}]]]];
AddLemma[all[{k,low,up,f,cond},
    imp[imp[and[low\[LessEqual]k,k\[LessEqual]up,cond],f\[LessEqual]0],
      sum[f,{k,low,up,cond}]\[LessEqual]0]]];
AddLemma[all[{k,low,up,f,cond},
    imp[imp[and[low\[LessEqual]k,k\[LessEqual]up,cond],f==0],
      sum[f,{k,low,up,cond}]==0]]];



AddLemma[all[x, imp[and[x \[GreaterEqual] -\[Pi]/2, x \[LessEqual] \[Pi]/2], 0 \[LessEqual] Cos[x]]]];
AddLemma[all[x, imp[and[x \[GreaterEqual] 0, x \[LessEqual] \[Pi] ], 0 \[LessEqual] Sin[x]]]];