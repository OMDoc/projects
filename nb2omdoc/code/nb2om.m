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







Off[General::spell,General::spell1]
Off[General::stop]


ClearAll[dprintind,dprint]
dprintind[xx___String] :=If[ $celltrace, Print[makeSpace[],xx] ];
dprintdown[xx___String] := 
    If[ $celltrace, 
      	$indent += $deltaindent;Print["---->  ", xx] ];
dprintup[xx___String] := 
    If[ $celltrace, 
      	$indent -= $deltaindent;Print["<----  ", xx] ];

makeSpace[] := StringJoin@@Table[" ",{$indent}]



Clear[InitializeCounters,genID]

$leerzeichen = 1;
$ostream;
$filename = "";
$indent = 0;
$deltaindent = 1;

InitializeCounters[] := 
(
	$tmpcnt = 0;
	$indent = 0;
	codeCnt = 0;
	textCnt = 0;
	groupCnt = 0;
	inputCnt = 0;
	sectionCnt = 0;
	ssectionCnt = 0;
	sssectionCnt = 0;
	ssssectionCnt = 0;
	titleCnt = 0;
	stitleCnt = 0;
	sstitleCnt = 0;
	theoremCnt = 0;
	definitionCnt = 0;
	propositionCnt = 0;
	lemmaCnt = 0;
	corollaryCnt = 0;
	commentCnt = 0;
	exerciseCnt = 0;
	exampleCnt = 0;
	questionCnt = 0;
	proofCnt = 0;	
	proofstepCnt = 0;	
	globalCnt = 0;
	mtainCnt = 0;
	mtaoutCnt = 0;
	graphCnt = 0;
);

genID["text"] :=  "T" <> ToString[ textCnt++]
genID["title"] :=  "S" <> ToString[ titleCnt++]
genID["subtitle"] :=  "S" <> ToString[ stitleCnt++]
genID["subsubtitle"] :=  "S" <> ToString[ sstitleCnt++]
genID["section"] :=  "S" <> ToString[ sectionCnt++]
genID["subsection"] :=  "S" <> ToString[ ssectionCnt++]
genID["subsubsection"] :=  "S" <> ToString[ sssectionCnt++]
genID["subsubsubsection"] :=  "S" <> ToString[ ssssectionCnt++]
genID["omgroup"] :=  "G" <> ToString[ groupCnt++]
genID["theorem"] :=  "Thm" <> ToString[ theoremCnt++]
genID["lemma"] :=  "L" <> ToString[ lemmaCnt++]
genID["proposition"] :=  "P" <> ToString[ propositionCnt++]
genID["corollary"] :=  "O" <> ToString[ corollaryCnt++]
genID["definition"] :=  "D" <> ToString[ definitionCnt++]
genID["comment"] :=  "C" <> ToString[ commentCnt++]
genID["example"] :=  "E" <> ToString[ exampleCnt++]
genID["exercise"] :=  "X" <> ToString[ exerciseCnt++]
genID["proof"] :=  "Pr" <> ToString[ proofCnt++]
genID["proofstep"] :=  "Ps" <> ToString[ proofstepCnt++]
genID["mtainput"] :=  "Mtain" <> ToString[ matinputCnt++]
genID["code"] :=  "c" <> ToString[ codeCnt++]

$celltrace = True;
$tracemath = False;
$fulltracemath=False;
$traceinput = False;
$traceoutput = False;
$fulltrace = False;
$longpath = True;




Clear[CellType,CellCont,isText,isInput,isOutput,isGraphics,isGrData]

CellType[ Cell[_,ct_String,___]] := ct;
CellType[ Cell[CellGroupData[__]]] := "CellGroup";
CellType[ Cell[BoxData[__],___]] := "BoxData";
CellType[ Cell[c_]] := (Print[c];"untyped cell");
CellCont[ Cell[cnt_,___ ]] := cnt;

$headingsm={"Section","Subsection","Subsubsection","Subsubsubsection","Title",
      "Subtitle","Subsubtitle"};
isHeading[str_String] := MemberQ[ $headingsm, str ];
isHeading[c_Cell] := isHeading[  CellType[c] ];

$textlike={"Text","SmallText","Warning","Note","Question","Hint",
      "RhetoricalQuestion","Definition","Proposition","Lemma","Problem",
      "Program","Theorem","Proof","ProofEnd","ProofStep","Creator","Date"};
$textlike={"Text","SmallText"};
isText[str_String] := MemberQ[ $textlike, str ];
isText[c_Cell] := isText[  CellType[c] ];

$assertion={"Proposition","Lemma","Theorem"};
$textlike={"Text","SmallText"};
isAssertion[str_String] := MemberQ[ $assertion, str ];
isAssertion[c_Cell] := isAssertion[  CellType[c] ];

isInput[str_String] := "Input" === str;
isInput[c_Cell] := isInput[  CellType[c] ];

isOutput[str_String] := "Output" === str;
isOutput[c_Cell] := isOutput[  CellType[c] ];

isGraphics[str_String] := "Graphics" === str;
isGraphics[c_Cell] := isGraphics[  CellType[c] ];

isGrData[Cell[GraphicsData[___],___]] := True;
isGrData[_] := False;




XMLmeta[cnt_List] :=  XMLElement["metadata",{}, cnt];
XMLmeta[cnt__] :=  XMLElement["metadata",{}, {cnt}];
XMLcmp[cnt_List] :=  XMLElement["CMP",{}, cnt ];
XMLcmp[cnt__] :=   XMLElement["CMP",{}, {cnt} ];

XMLgroup[cnt_List] :=  
    XMLElement["omgroup",{"id"\[Rule]genID["omgroup"]}, cnt];
XMLgroup[cnt__] :=   XMLElement["omgroup",{"id"->genID["omgroup"]}, {cnt}];
XMLtext[cnt_List] :=  XMLElement["omtext",{"id"->genID["text"]}, cnt];
XMLtext[cnt__] :=   XMLElement["omtext",{"id"->genID["text"]}, {cnt}];
XMLcode[cnt_List] :=  XMLElement["code",{"id"->genID["code"]}, cnt];
XMLcode[cnt__] :=   XMLElement["code",{"id"->genID["code"]}, {cnt}];

XMLdata[cnt_String] := XMLElement["data",{"format"->"mathematica"},
      						{ XMLObject["CDATASection"][cnt]} ];
XMLdata[cnt_] := XMLdata[ToString[cnt,CharacterEncoding\[Rule]None]];
XMLdata[fmt_String,cnt_String] := 
    XMLElement[
      "data",{"format"\[Rule]fmt},{ XMLObject["CDATASection"][cnt]} ];
XMLdata[fmt_String,cnt_] := 
    XMLdata[fmt,ToString[cnt,CharacterEncoding\[Rule]None]];





Clear[processCell]
processCell::nodef = "cannot process: `1`";





processCell[ Cell[CellGroupData[ {ch_?isHeading,cc___},___] ]] := 
    Block[ {res,hd},
      	dprintdown[CellType[ch]];
      	hd = XMLmeta[XMLElement["Title",{}, 
            	Flatten[{processText[CellCont[ch]]}] ] ];
      	res = Prepend[ Map[ processCell, {cc} ],hd ];
      	dprintup[];
      	XMLgroup[ res ]
      ];



processCell[ 
      Cell[CellGroupData[ {cin_?isInput,grout_?isGraphics,
            grsk___?isOutput},___] ]] := 
    Block[ {res,resg},
      	dprintdown[CellType[cin]];
      	resg = XMLcode[ XMLdata["graphics","---PHONY---"]];
      	res =  XMLgroup[  Flatten[{processInput[cin], resg}]];
      	dprintup[];
      	res
      ];

processCell[ Cell[CellGroupData[ {cin_?isInput,cout_},___] ]] := 
    Block[ {resi,reso},
      	dprintdown[CellType[cin]];
      	res =  XMLgroup[  Flatten[{processInput[cin], processOutput[cout]}]];
      	dprintup[];
      	res
      ];

processCell[ cin_Cell?isInput ] := XMLgroup[  processInput[cin] ];

processInput[ Cell[ cnt_String,___] ] := 
    Block[ {resi,resic},
      	dprintind["Input"];
      	resi = XMLtext[XMLcmp[processText[cnt ] ]];
      	resic = XMLcode[XMLdata[cnt]];
      	{ resi,resic }
      ];

processInput[ Cell[ cnt_BoxData,___] ] := 
    Block[ {resi,resic},
      	dprintind["Input"];
      	resi = XMLtext[XMLcmp[btoSML[cnt ] ]];
      	resic = XMLcode[XMLdata[cnt]];
      	{ resi,resic }
      ];

processCell[  co_?isOutput ] := processOutput[co];

processOutput[  Cell[ cnt_,___] ] := 
    Block[ {reso},
      	dprintind["Output"];
      	XMLcode[XMLdata[cnt]]
      ];




processCell[ ch_Cell?isHeading ] := 
    Block[ {},
      	dprintind["Heading naked"];
      	XMLgroup[XMLmeta[XMLElement["Title",{}, 
            	Flatten[{processText[CellCont[ch]]}] ] ] ]
      	
      ];




processCell[ Cell[CellGroupData[ {ch_,cc___},___] ]] := 
    Block[ {res},
      	dprintdown[CellType[ch]];
      	res = Map[ processCell, {ch,cc} ];
      	dprintup[];
      	XMLgroup[ res ]
      ];





processCell[ Cell[ BoxData[ bd_] ] ]:= 
    Block[ {res},
      	dprintind[ "*BoxData" ];
      	btoSML[BoxData[bd]]
      ];



processCell[ Cell[ cnt_, tp_String?isText, ___  ] ] := 
    Block[ {res},
      	dprintind["*Cell  Text" ];
      	XMLtext[ XMLcmp[ processText[cnt] ] ]
      ];


processText[str_String]:=ToString[str,CharacterEncoding\[Rule]None];
processText[StyleBox[str_String,__]]:=
    XMLElement["with",{"style"\[Rule]"emph"},{processText[str]}];
processText[TextData[L_List]]:=processText/@L;
processText[TextData[StyleBox[str_String,__]]]:=processText[str];
processText[TextData[cl_Cell]]:=processText[cl];
processText[Cell[BoxData[bx_]]]:=processCell[Cell[BoxData[bx]]];



processCell[ Cell[ cnt_, tp_String?isAssertion, ___  ] ] := 
    Block[ {res},
      	tpp = ToLowerCase[tp];
      	dprintind["*Cell  Assertion  ",tp ];
      	XMLElement[
        "assertion",{"id"\[Rule] genID[tpp],"type"\[Rule]tpp},{ 
          XMLcmp[ processText[cnt]]} ]
      ];



processCell[ Cell[ cnt_, "Definition", ___  ] ] := 
    Block[ {res},
      	tpp = ToLowerCase[tp];
      	dprintind["*Cell  Definition"];
      	XMLElement[
        "definition",{"id"\[Rule] genID["definition"],"for"->"dogfood",
          "type"\[Rule]"simple"},{ XMLcmp[ processText[cnt]]} ]
      ];



processCell[ Cell[ GraphicsData[ bd__],___ ] ]:= 
    Block[ {res},
      	dprintind[ "*GraphicsData" ];
      XMLcode[ XMLdata["graphics","---PHONY---"] ]
      ];




processCell[   StyleBox[str_String,__]  ] := 
    Block[ {res},
      	dprintind["*StyleBox  " ];
      	XMLElement["with",{"style"->"emph"},{str} ] 
      ];

processCell[ xx__ ] := 
    Block[ {res},
      	Message[ processCell::nodef,xx ]
      ];





ClearAll[btoSMLraw,btoSML]

btoSMLraw[ BoxData[FormBox[bb_,TraditionalForm ]]] :=
    	
    btoSMLraw[BoxData[bb]];

btoSMLraw[ BoxData[InterpretationBox[bb_,cc_,___ ]]] :=
    	
    btoSMLraw[BoxData[cc]];

btoSMLraw[ BoxData[bx_List]] := 
    XMLElement["OMA",{}, 
      Flatten[{
          XMLElement[ "OMS",{"cd"->"mathematica","name"->"Compound"},{}],
          btoSMLraw /@ bx }] ];

btoSMLraw[ee_] := 
    XML`MathML`BoxesToSymbolicMathML[ Unevaluated[ee],"Annotations"\[Rule]{},
        "Formats"\[Rule]{"ContentMathML"}  ][[3,1]];

btoSML[ee_] := 
  Module[{res,err},
    	res = XMLElement["OMOBJ",{},{btoSMLraw[ee]  //. omrules} ];
    	err = XML`SymbolicXMLErrors[res];
    	If[ err === {}, 
      		res, 
      		OMOBJERR
      	]
    ]

OMOBJERR = 
    XMLElement[
      "OMOBJ",{},{XMLElement[
          "OMS",{"cd"\[Rule] "error","name"\[Rule] "ERROR"},{}] } ];





Clear[ ompre, omrgeneral, omrspecial, ommat, omrlist,omrminmax,omrrelation, \
omrlogic, omrarithmetic, omrround, omrinteger, 
  omrcompound , omrsequ ]

 ompre = {
      XMLElement[
          "apply",{},{ XMLElement["ci",{},{"CompoundExpression"}],xxx__,
            XMLElement["ci",{},{"Null"}]}] \[RuleDelayed] xxx,
      
      {xxx___,XMLElement["ci",{},{"Null"}],yyy___} \[RuleDelayed] {xxx,yyy},
      
      XMLElement[
          "apply",{},{ XMLElement["ci",{},{"MatrixForm"}],
            xxx__ }] \[RuleDelayed] xxx,
      
      XMLElement[
          "apply",{},{XMLElement["times",{},{}],top_,
            XMLElement[
              "apply",{},{XMLElement["power",{},{}],bot_,
                XMLElement["cn",{"type"\[Rule]"integer"},{"-1"}]}]}] :>
        XMLElement[
          "OMA",{},{XMLElement["OMS",{"cd"->"arith1","name"->"divide"},{}],
            top,bot}],
      
      XMLElement[
          "apply",{},{XMLElement["plus",{},{}],arg1_,
            XMLElement[
              "apply",{},{XMLElement["times",{},{}],
                XMLElement["cn",{"type"\[Rule]"integer"},{"-1"}],arg2_}]}]:>
        XMLElement[
          "OMA",{},{XMLElement["OMS",{"cd"->"arith1","name"->"minus"},{}],
            arg1, arg2 }],
      
      XMLElement[
          "apply",{},{XMLElement["times",{},{}],
            XMLElement["cn",{"type"\[Rule]"integer"},{"-1"}],
            arg_}] \[RuleDelayed]
        XMLElement[
          "OMA",{},{XMLElement[
              "OMS",{"cd"->"arith1","name"->"unary_minus"},{}],arg }],
      
      XMLElement["ci",{},{"SetDelayed"}] \[RuleDelayed] 
        XMLElement["OMS",{"cd"->"prog2","name"->"assignment"},{}],
      
      (* XMLElement["ci",{},{"Set"}] \[RuleDelayed] 
          
          XMLElement[
            "OMS",{"cd"->"prog2","name"->"assignment"},{}], *)
      
       XMLElement["ci",{},{"Set"}] \[RuleDelayed] 
        XMLElement["OMS",{"cd"->"relation1","name"->"eq"},{}], 
       XMLElement["apply",{},{
            XMLElement["ci",{},{"Function"}],
            XMLElement["ci",{},{var_String}],body_ } ] \[RuleDelayed]
        XMLElement["OMBIND",{},{
            XMLElement["OMS",{"cd"->"fns1","name"->"lambda"},{}],
            
            XMLElement[
              "OMBVAR",{},{ XMLElement["OMV",{"name"\[Rule]var}, {} ] }],
            body }],
       XMLElement["lambda",{},{body__}] \[RuleDelayed]
        XMLElement["OMBIND",{},{
            XMLElement["OMS",{"cd"->"fns1","name"->"lambda"},{}],
            body } ],
       XMLElement["bvar",{},{xx__}] \[RuleDelayed]
        XMLElement["OMBVAR",{},{xx}]
      };

omrgeneral = {
      XMLElement["transpose",{},{}] \[RuleDelayed] 
        XMLElement["OMS",{"cd"->"mathematica","name"->"Transpose"},{}],
      XMLElement["ident",{},{} ] :> 
        XMLElement["OMS",{"cd"->"mathematica","name"->"Identity"},{} ],
      XMLElement["none",{},{} ] :> 
        XMLElement["OMS",{"cd"->"mathematica","name"->"None"},{} ],
      
      
      XMLElement["math",att_, dat_ ] :> XMLElement["OMOBJ",{},dat ],
      XMLElement["apply",att_, dat_ ] :> XMLElement["OMA",att,dat], 
      XMLElement["selector",att_, dat_ ] :> 
        XMLElement["OMV",{"name"\[Rule]"Part"},{}] ,
      XMLElement["ci",att_, {"\[CenterEllipsis]"} ] :> 
        XMLElement[
          "OMS",{"cd"->"sequences", "name"\[Rule]"CenterEllipsis"}, {} ],
      XMLElement["ci",{}, {"Subscript"} ] :> 
        XMLElement["OMS",{"cd"->"scripts","name"\[Rule]"subscript"}, {} ],
      XMLElement["ci",att_, {xx_String} ] :> 
        XMLElement["OMV",{"name"\[Rule]xx}, {} ],
      XMLElement["cn",{"type"\[Rule]"integer"}, {xx_String} ] :> 
        XMLElement["OMI",{}, {xx} ],
      XMLElement["cn",{"type"\[Rule]"real"}, {xx_String} ] :> 
        XMLElement["OMF",{"dec"\[Rule]xx}, {} ],
      XMLElement["ms",{}, {xx_String} ] :> 
        XMLElement["OMV",{"name"\[Rule]xx}, {} ],
      
      XMLElement["msub",{}, {dat__} ] :> 
        XMLElement["OMS",{"cd"->"scripts","name"\[Rule]"subscript"}, {dat} ]
      }; 

omrlist = { 
      XMLElement["list",att_, dat_ ] :> 
        XMLElement["OMA",{},  
          Join[ {XMLElement["OMS",{"cd"->"list1","name"->"list"},{}]},dat]],
      XMLElement["in",{},{}] \[RuleDelayed] 
        XMLElement["OMS",{"cd"->"set1","name"->"in"},{}],
      XMLElement["subset",{},{}] \[RuleDelayed] 
        XMLElement["OMS",{"cd"->"set1","name"->"SubsetEqual"},{}],
      XMLElement["prsubset",{},{}] \[RuleDelayed] 
        XMLElement["OMS",{"cd"->"set1","name"->"Subset"},{}],
      XMLElement["union",{},{}] \[RuleDelayed] 
        XMLElement["OMS",{"cd"->"set1","name"->"union"},{}],
      XMLElement["intersect",{},{}] \[RuleDelayed] 
        XMLElement["OMS",{"cd"->"set1","name"->"intersection"},{}]
      };


omrspecial = {
      XMLElement["scalarproduct",att_, dat_ ] :> 
        XMLElement["OMV",{"name"->"Dot"},dat],
      XMLElement["infinity",att_, dat_ ] :> 
        XMLElement["OMS",{"cd"->"nums1","name"->"infinity"},dat],
      
      XMLElement[
          "cn",{"type"->"rational"},{num_,XMLElement["sep",{},{}],den_} ] :> 
        XMLElement[
          "OMA",{},{XMLElement["OMS",{"cd"->"nums1","name"->"rational"},{}],
            XMLElement["OMI",{},{num}],XMLElement["OMI",{},{den}]}],
      
      
      
      XMLElement[
          "cn",{"type"->"complex-cartesian"},{xx_,XMLElement["sep",{},{}],
            yy_} ] :> XMLElement[
          "OMA",{},{XMLElement[
              "OMS",{"cd"->"complex1","name"->"complex_cartesian"},{}],
            XMLElement["OMI",{},{xx}],XMLElement["OMI",{},{yy}]}],
      
      
      XMLElement["exponentiale",att_, dat_ ] :> 
        XMLElement["OMS",{"cd"->"nums1","name"->"e"},dat],
      XMLElement["imaginaryi",att_, dat_ ] :> 
        XMLElement["OMS",{"cd"->"nums1","name"->"i"},dat],
      XMLElement["pi",att_, dat_ ] :> 
        XMLElement["OMS",{"cd"->"nums1","name"->"pi"},dat],
      XMLElement["real",att_, dat_ ] :> 
        XMLElement["OMS",{"cd"->"complex1","name"->"real"},dat],
      XMLElement["imaginary",att_, dat_ ] :> 
        XMLElement["OMS",{"cd"->"complex1","name"->"imaginary"},dat],
      XMLElement["conjugate",att_, dat_ ] :> 
        XMLElement["OMS",{"cd"->"complex1","name"->"conjugate"},dat],
      XMLElement["arg",att_, dat_ ] :> 
        XMLElement["OMS",{"cd"->"complex1","name"->"argument"},dat],
      XMLElement["sinh",att_, dat_ ] :> 
        XMLElement["OMS",{"cd"->"transc1","name"->"sinh"},dat],
      XMLElement["cosh",att_, dat_ ] :> 
        XMLElement["OMS",{"cd"->"transc1","name"->"cosh"},dat],
      XMLElement["tan",att_, dat_ ] :> 
        XMLElement["OMS",{"cd"->"transc1","name"->"tan"},dat],
      XMLElement["arctan",att_, dat_ ] :> 
        XMLElement["OMS",{"cd"->"transc1","name"->"arctan"},dat],
      XMLElement["sin",att_, dat_ ] :> 
        XMLElement["OMS",{"cd"->"transc1","name"->"sin"},dat],
      XMLElement["cos",att_, dat_ ] :> 
        XMLElement["OMS",{"cd"->"transc1","name"->"cos"},dat],
      XMLElement["ln",att_, dat_ ] :> 
        XMLElement["OMS",{"cd"->"transc1","name"->"ln"},dat],
      XMLElement["vectorproduct",att_, dat_ ] :> 
        XMLElement["OMS",{"cd"->"linalg1","name"->"vectorproduct"},dat]
      };

omrrelation = {
      XMLElement["eq",att_, dat_ ] :> 
        XMLElement["OMS",{"cd"->"relation1","name"->"eq"},dat],
      XMLElement["geq",att_, dat_ ] :> 
        XMLElement["OMS",{"cd"->"relation1","name"->"geq"},dat],
      XMLElement["leq",att_, dat_ ] :> 
        XMLElement["OMS",{"cd"->"relation1","name"->"leq"},dat],
      XMLElement["neq",att_, dat_ ] :> 
        XMLElement["OMS",{"cd"->"relation1","name"->"neq"},dat],
      XMLElement["lt",att_, dat_ ] :> 
        XMLElement["OMS",{"cd"->"relation1","name"->"lt"},dat],
      XMLElement["gt",att_, dat_ ] :> 
        XMLElement["OMS",{"cd"->"relation1","name"->"gt"},dat]
      };

omrminmax = {
      XMLElement["min",att_, dat_ ] :> 
        XMLElement["OMS",{"cd"->"minmax1","name"->"min"},{} ],
      XMLElement["max",att_, dat_ ] :> 
        XMLElement["OMS",{"cd"->"minmax1","name"->"max"},{} ]
      };

omrlogic = {
      XMLElement["false",att_, dat_ ] :> 
        XMLElement["OMS",{"cd"->"logic1","name"->"false"},{} ],
      XMLElement["true",att_, dat_ ] :> 
        XMLElement["OMS",{"cd"->"logic1","name"->"true"},{} ],
      XMLElement["not",att_, dat_ ] :> 
        XMLElement["OMS",{"cd"->"logic1","name"->"not"},{} ],
      XMLElement["implies",att_, dat_ ] :> 
        XMLElement["OMS",{"cd"->"logic1","name"->"implies"},{} ],
      XMLElement["and",att_, dat_ ] :> 
        XMLElement["OMS",{"cd"->"logic1","name"->"and"},{} ],
      XMLElement["xor",att_, dat_ ] :> 
        XMLElement["OMS",{"cd"->"logic1","name"->"xor"},{} ],
      XMLElement["or",att_, dat_ ] :> 
        XMLElement["OMS",{"cd"->"logic1","name"->"or"},{} ]
      };

omrround = {
      XMLElement["ceiling",att_, dat_ ] :> 
        XMLElement["OMS",{"cd"->"round1","name"->"ceiling"},{} ],
      XMLElement["floor",att_, dat_ ] :> 
        XMLElement["OMS",{"cd"->"round1","name"->"floor"},{} ]
      };

omrinteger = {
      XMLElement["rem",att_, dat_ ] :> 
        XMLElement["OMS",{"cd"->"integer1","name"->"rem"},dat]
      };

omrarithmetic = {
      XMLElement["factorial",att_, dat_ ] :> 
        XMLElement["OMS",{"cd"->"integer1","name"->"factorial"},dat],
      XMLElement["root",att_, dat_ ] :> 
        XMLElement["OMS",{"cd"->"arith1","name"->"root"},dat],
      XMLElement["gcd",att_, dat_ ] :> 
        XMLElement["OMS",{"cd"->"arith1","name"->"gcd"},dat],
      XMLElement["plus",att_, dat_ ] :> 
        XMLElement["OMS",{"cd"->"arith1","name"->"plus"},dat],
      XMLElement["minus",att_, dat_ ] :> 
        XMLElement["OMS",{"cd"->"arith1","name"->"minus"},dat],
      XMLElement["times",att_, dat_ ] :> 
        XMLElement["OMS",{"cd"->"arith1","name"->"times"},dat],
      XMLElement["power",att_, dat_ ] :> 
        XMLElement["OMS",{"cd"->"arith1","name"->"power"},dat],
      XMLElement["abs",att_, dat_ ] :> 
        XMLElement["OMS",{"cd"->"arith1","name"->"abs"},dat]
      };

omrcompound = 
    { { 
          XMLElement["product",{} ,{} ],
          XMLElement["bvar",{}, {bv_} ],
          XMLElement["lowlimit",{}, {lol_} ],
          XMLElement["uplimit",{}, {upl_} ],
           xmlelm_ }  :> 
        {   XMLElement["OMS",{"cd"->"arith1","name"->"prod"},{}],
             
          XMLElement[
            "OMA",{},{XMLElement[
                "OMS",{"cd"->"interval1","name"->"integer_interval"},{}],lol,
              upl }],
             XMLElement["OMBIND",{},{
              XMLElement["OMS",{"cd"->"fns1","name"->"lambda"},{}],
              XMLElement["OMBVAR",{},{bv}],
              xmlelm } ] },
      { 
          XMLElement["sum",{} ,{} ],
          XMLElement["bvar",{}, {bv_} ],
          XMLElement["lowlimit",{}, {lol_} ],
          XMLElement["uplimit",{}, {upl_} ],
           xmlelm_ }  :> 
        {   XMLElement["OMS",{"cd"->"arith1","name"->"sum"},{}],
             
          XMLElement[
            "OMA",{},{XMLElement[
                "OMS",{"cd"->"interval1","name"->"integer_interval"},{}],lol, 
              upl } ],
             XMLElement["OMBIND",{},{
              XMLElement["OMS",{"cd"->"fns1","name"->"lambda"},{}],
              XMLElement["OMBVAR",{},{bv}],
              xmlelm } ]  } };

omrsequ = {
      XMLElement["OMV",{"name"->"EllipsisInfix"},{} ] :> 
        XMLElement["OMS",{"cd"->"sequences","name"->"ellipsis_infix"},{}],
      XMLElement["OMV",{"name"->"EllipsisInfixPlus"},{} ] :> 
        XMLElement[
          "OMS",{"cd"->"sequences","name"->"ellipsis_infix_plus"},{}],
      XMLElement["OMV",{"name"->"EllipsisInfixTimes"},{} ] :> 
        XMLElement[
          "OMS",{"cd"->"sequences","name"->"ellipsis_infix_times"},{}]
      };

ommat= {
      XMLElement["determinant",{},{}] \[RuleDelayed] 
        XMLElement["OMS",{"cd"->"linalg1", "name"\[Rule]"determinant"},{}],
      
      XMLElement["list",{}, 
          XX:{XMLElement["list",{},{__}]..}] \[RuleDelayed] 
        XMLElement["apply",{},{ 
            XMLElement["OMS",{"cd"->"linalg2", "name"\[Rule]"matrix"},{}],
            
            Sequence@@(XMLElement[
                      "apply",{},{XMLElement[
                          "OMS",{"cd"->"linalg2", 
                            "name"\[Rule]"matrixrow"},{}],
                        Sequence@@(#[[3]])}]& /@ XX)} ]};

omother = {  
      XMLElement[
          "OMA",{},{XMLElement["OMV",{"name"\[Rule]"SubscriptBox"},{}],xx_,
            yy_}]\[RuleDelayed]
         XMLElement["OMA",{},{XMLElement["OMS",{"cd"\[Rule]"scripts",
                "name"->"subscript"},{}],xx,yy} ],
      XMLElement[
          "OMA",{},{XMLElement["OMV",{"name"\[Rule]"SuperscriptBox"},{}],xx_,
            yy_}]\[RuleDelayed]
         XMLElement["OMA",{},{XMLElement["OMS",{"cd"\[Rule]"scripts",
                "name"->"superscript"},{}],xx,yy} ],
      XMLElement["OMA",{},
          
          {XMLElement["OMS",{"cd"\[Rule]"arith1","name"\[Rule]"power"},{}],
            base_,exp_ }]\[RuleDelayed] 
        XMLElement[
          "OMA",{},{XMLElement[
              "OMS",{"cd"\[Rule]"scripts","name"\[Rule]"superscript"},{}],
            base,exp }]
      };
omother = {};



omrules = 
    Dispatch[Join[ ompre, omrgeneral, omrspecial, ommat, omrlist,omrminmax,
        omrrelation, omrlogic, omrarithmetic, omrround, omrinteger, 
        omrcompound , omrsequ, omother ]];





(* $omsystem = "../../../../../../omdoc/dtd/omdoc.dtd"; *)
$omsystem = 
    "omdoc.dtd";
$omident = "mtanb";
$omtitle ="NN";
$omcreator="NN";
$omsubject="NN";

PrintHeaderInfo[] :=
    (
      Print["dtd:       ",$omsystem];
      Print["ident:     ",$omident];
      Print["title:     ",$omtitle];
      Print["creator:   ",$omcreator];
      Print["subject:   ",$omsubject];
      );




Clear[ProfileCells]

ProfileCells[ fname_String] := ProfileCells[ Directory[],fname ];
ProfileCells[nbpath_String,fname_String] :=
  Module[ {nb,cl},
    	If[(nb=Get[ToFileName[nbpath,fname]])===$Failed,
      		Message[NB2OMDoc::nofile,fname];
      		Return[]
      	];
    	cl = Position[ nb, Cell[___]];
    	Print["number of cells:  ",Length[cl]];
    	Table[CellType@Part[ nb, Sequence@@cl[[i]]] , {i,Length[cl]}]
    ] 

Clear[TransformCells]

TransformCells[nbpath_String,fname_String] :=
  Module[ {nb,cl},
    	If[(nb=Get[ToFileName[nbpath,fname]])===$Failed,
      		Message[NB2OMDoc::nofile,fname];
      		Return[]
      	];
    	cl = Position[ nb, Cell[BoxData[__],"Input",___]];
    	Print["number of cells:  ",Length[cl]];
    	rep = 
      	Pairs[ Table[ fixcell@Part[ nb, Sequence@@cl[[i]]] , {i,Length[cl]}],
        cl];
    nnb = Fold[ ReplacePart[#1,#2[[1]],#2[[2]]]&, nb,  rep ];
    NotebookSave[ nnb, ToFileName[nbpath,"foo.nb"] ];
    rep
    ] 

Clear[fixcell]



fixcell[Cell[BoxData[FormBox[RowBox[L_List],__]],tp_String,___]] := 
    Cell[Concatenate@@L,tp];
fixcell[Cell[BoxData[FormBox[RowBox[s_String],__]],tp_String,___]] := 
    Cell[s,tp];
fixcell[Cell[BoxData[FormBox[s_String,__]],tp_String,___]] := Cell[s,tp];

Clear[ProcessNotebook]

ProcessNotebook[nb:Notebook[ {cells__},options___ ]] := 
    Block[{res},
      	$indent = 0;
      	res = Map[ processCell, {cells} ];
      	dprint["eof"];
      	res
      ];




ClearAll[NB2OMDoc]
NB2OMDoc::nofile = "cannot open `1`";
NB2OMDoc::nodir  = "cannot cd to `1`";
NB2OMDoc::nosave = "cannot save `1`";
NB2OMDoc::noclose = "cannot close `1`";

NB2OMDoc[ fn_String ]:= NB2OMDoc[ fn,  Directory[] ];

NB2OMDoc[ fn_String,  nbpath_String ]:=
    Module[{cepos,i,nbp, nb },
      
      	InitializeCounters[];
      
      	If[ StringMatchQ[ fn, "*.nb" ],
        		filename = fn; 
        		$filename = StringDrop[fn,-3], 
        		filename = StringJoin[fn,".nb"];
        		$filename = fn
        	];
      
      Print["nb2omdoc:  ",filename  ];
      
      	If[(nb=(Get[ToFileName[nbpath,filename]]))===$Failed,
        			Message[NB2OMDoc::nofile,filename] ;
        			Return[]
        	];
      
      	res = ProcessNotebook[ nb ] ;
      
      	If[ NotebookClose[nb]===$Failed,
        		Message[NB2OMDoc::noclose,filename] ;
        			Return[]
        	];
      
      	$ofile =  StringJoin[$filename,".omdoc"];

		printHeadInfo[];

        Print["nb2omdoc:  ", $ofile  ];
    
      	Export[ $ofile, 
        		res = addHeader[ res ],
        		"XML",
       			ConversionOptions\[Rule]{"ElementFormatting"\[Rule]All,
       					"AttributeQuoting"->"\""}];
      res
      ];



ClearAll[addHeader]
Options[addHeader]={HeaderMeta \[Rule]
        {"omdident"\[RuleDelayed]  $omident,"Title"\[RuleDelayed] $omtitle,
          "Creator"\[RuleDelayed] $omcreator,
          "Subject"\[RuleDelayed] $omsubject }};

addHeader[body_List,opts___?OptionQ ] := 
    Module[ {metadr,date,root},
      metadr = HeaderMeta /. {opts} /. Options[addHeader];
      date = 
        StringJoin[Thread[{ToString /@ Date[],{"-","-"," ",":",":",""}}]];
      AppendTo[ metadr,"Date"\[Rule]date];
      
      root =  XMLElement["omdoc",{"id"\[Rule] "omdident" /. metadr,
            "xmlns" \[Rule] "http://www.mathweb.org/omdoc",
            
            "catalogue"\[Rule] 
              "../../../../../../omdoc/examples/omstd/catalogue.omdoc",
            	"xmlns:xsi"\[Rule] "http://www.w3.org/2001/XMLSchema-instance",
            	
            "xsi:schemaLocation"\[Rule] 
              "omdoc.xsd http://www.mathweb.org/omdoc" },
          Join[  
            {
              XMLElement["metadata",{},{
                  XMLElement["Title",{},{ "Title" /. metadr }],
                  XMLElement["Creator",{},{ "Creator" /. metadr }],
                  XMLElement["Subject",{},{ "Subject" /. metadr }],
                  
                  XMLElement[
                    "Date",{"action"->"created"},{ "Date" /. metadr }]}],
              XMLElement["catalogue",{},{
                  
                  XMLElement[
                    "loc",{"theory"->"scripts",
                      "omdoc"->
                        "../../../../../theories/migration/scripts.omdoc"},{}]\
} ] 
              },
            	body 
            ]];
      
      XMLObject["Document"][
        {
          
          XMLObject["Declaration"]["Version"\[Rule]"1.0",
            "Encoding"\[Rule]"utf-8"],
          
          XMLObject["Doctype"]["omdoc", 
            "Public"\[Rule] "-//OMDoc//DTD OMDoc V1.2//EN",
            "System" \[Rule] $omsystem,"InternalSubset"\[Rule]""]},
        root,
        {}
        ]
      ];