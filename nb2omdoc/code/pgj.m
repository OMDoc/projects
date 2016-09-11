        StyleBox[
          ButtonBox["\[MathematicaIcon]",
            ButtonFunction:>Module[ {}, 
                CompoundExpression[ {}, 
                  Get[ "LinearAlgebra`MatrixManipulation`"]]],
            ButtonEvaluator->"Local",
            Active->True,
            Background->RGBColor[0.500008, 0.500008, 0]],
          FormatType->TraditionalForm,
          FontFamily->"Courier",
          FontSize->12,
          Background->RGBColor[1, 1, 0]], 

---------------------------------------------------------------------------

        StyleBox[
          ButtonBox["Prog",
            ButtonFunction:>Module[ {}, 
                CompoundExpression[ {}, 
                  SetDelayed[ 
                    txt[ 
                      Pattern[ u, Blank[ List]], 
                      Pattern[ opts, BlankNullSequence[]]], 
                    Cell[ 
                      BoxData[ 
                        FormBox[ 
                          ToBoxes[ 
                            Apply[ SequenceForm, 
                              Map[ TraditionalForm, u]]], TraditionalForm]], 
                      "Text", FontSlant -> "Italic", FontSize -> 17, 
                      FontWeight -> "Bold", opts]], 
                  SetDelayed[ 
                    bon[ 
                      Pattern[ amam, Blank[]], 
                      Pattern[ opts, BlankNullSequence[]]], 
                    StyleForm[ 
                      StyleForm[ amam, FontFamily -> Times], FontFamily -> 
                      Times, FontSlant -> Italic, opts]], 
                  SetDelayed[ 
                    frmt[ 
                      Pattern[ amam, Blank[]], 
                      Pattern[ jj, Blank[]], 
                      Pattern[ opts, BlankNullSequence[]]], 
                    Cell[ 
                      BoxData[ 
                        ToBoxes[ 
                          StyleForm[ 
                            StyleForm[ amam, FontFamily -> Times], FontFamily -> 
                            Times, FontSlant -> Italic]]], "Text", FontSize -> 
                      16, CellTags -> ToString[ jj], opts]], 
                  SetDelayed[ 
                    princ1[ 
                      Pattern[ M, Blank[ List]]], 
                    Module[ {conv1, rss}, 
                      CompoundExpression[ {
                        SetDelayed[ 
                          conv1[ 
                            Pattern[ LL, Blank[ List]]], 
                          Module[ {entr, LLX}, 
                            CompoundExpression[ {
                              Set[ entr, 
                                Select[ LL, Or[ 
                                    Not[ 
                                      SameQ[ #, 0]], 
                                    Not[ 
                                      Less[ 
                                        N[ 
                                        Abs[ #]], 
                                        Power[ 10, -16]]], 
                                    Not[ 
                                      SameQ[ 
                                        Simplify[ #], 0]]]&, 1]], 
                              Set[ LLX, 
                                If[ 
                                  SameQ[ entr, {}], LL, 
                                  Map[ Factor, 
                                    Times[ LL, 
                                      Power[ 
                                        Part[ entr, 1], -1]]]]]}, LLX]]], 
                        Set[ rss, 
                          Map[ conv1, M]]}, rss]]], 
                  SetDelayed[ 
                    spros[ 
                      Pattern[ pant, Blank[]], 
                      Pattern[ UU, Blank[]], 
                      Optional[ 
                        Pattern[ tam, Blank[]], {250, 150}]], 
                    Module[ {di\[AAcute]logo}, 
                      CompoundExpression[ {
                        CompoundExpression[ 
                          SetDelayed[ 
                            di\[AAcute]logo[ 
                              Pattern[ pantalla, Blank[]]], 
                            NotebookPut[ 
                              Notebook[ {
                                Cell[ 
                                  Switch[ 
                                    Head[ pantalla], String, 
                                    TextData[ pantalla], 
                                    Alternatives[ BoxData, TextData], 
                                    pantalla, 
                                    Blank[], 
                                    BoxData[ 
                                      ToBoxes[ pantalla]]], "Text", FontSize -> 
                                  14, FontFamily -> Times, FontSlant -> 
                                  Italic, FontWeight -> Bold, FontColor -> 
                                  RGBColor[ 1, 1, 0], Background -> RGBColor[ 
                                  0, 0, 0], Editable -> False], 
                                Cell[ 
                                UU, "Text", CellFrame -> True, Background -> 
                                  RGBColor[ 
                                  0, .99610900000000002, .99610900000000002], 
                                  Evaluatable -> False, ShowCellTags -> False,
                                   CellTags -> "LaEntrada", CellMargins -> {{
                                  1, 1}, {1, 1}}, Deletable -> False, 
                                  TextAlignment -> Left, FontFamily -> Times, 
                                  FontWeight -> Bold, FontSlant -> Italic, 
                                  FontSize -> 16, GridBoxOptions -> {
                                  RowSpacings -> 0, RowMinHeight -> 0}], 
                                Cell[ 
                                  BoxData[ 
                                    ButtonBox[ 
                                    "OK", ButtonFunction :> SetOptions[ 
                                        ButtonNotebook[], Visible -> False], 
                                      ButtonFrame -> "DialogBox", Background -> 
                                      RGBColor[ 1, 0, 0]]], "Input", 
                                  CellMargins -> {{1, 1}, {1, 1}}, Active -> 
                                  True, Editable -> False, Deletable -> False,
                                   TextAlignment -> Center]}, ShowCellBracket -> 
                                False, WindowFrame -> "MovableModalDialog", 
                                Background -> 
                                RGBColor[ .99610900000000002, \
.99610900000000002, 0], WindowFloating -> True, WindowSize -> tam, 
                                WindowTitle -> "VENTANA DE DIALOGO", 
                                WindowMargins -> {{Automatic, 100}, {
                                Automatic, 30}}, WindowFrameElements -> {}, 
                                WindowElements -> {"VerticalScrollBar", 
                                "HorizontalScrollBar"}]]], Null]}, 
                        Module[ {togd\[AAcute], resultado}, 
                          CompoundExpression[ 
                            Set[ togd\[AAcute], 
                              di\[AAcute]logo[ pant]], 
                            NotebookFind[ 
                            togd\[AAcute], "LaEntrada", All, CellTags], 
                            Which[ 
                              SameQ[ 
                                NotebookFind[ 
                                togd\[AAcute], 
                                  "\[SelectionPlaceholder]"], $Failed], Null, 
                              
                              SameQ[ 
                                NotebookFind[ 
                                togd\[AAcute], "\[Placeholder]"], $Failed], 
                              Null, 
                              Not[ 
                                SameQ[ 
                                  NotebookFind[ 
                                  togd\[AAcute], 
                                    "\[SelectionPlaceholder]"], $Failed]], 
                              NotebookFind[ 
                              togd\[AAcute], "\[SelectionPlaceholder]", 
                                Before], 
                              Not[ 
                                SameQ[ 
                                  NotebookFind[ 
                                  togd\[AAcute], "\[Placeholder]"], $Failed]],
                               
                              NotebookFind[ 
                              togd\[AAcute], "\[Placeholder]", Before]], 
                            While[ 
                              SameQ[ 
                                Options[ togd\[AAcute], Visible], {Visible -> 
                                True}], 
                              Do[ Null, {250}]], 
                            NotebookFind[ 
                            togd\[AAcute], "LaEntrada", All, CellTags], 
                            Set[ resultado, 
                              NotebookRead[ togd\[AAcute]]], 
                            NotebookClose[ togd\[AAcute]], 
                            ToExpression[ 
                              Part[ resultado, 1]]]]]]], 
                  SetDelayed[ 
                    TakeRows[ 
                      PatternTest[Pattern[ mat, Blank[]], MatrixQ], 
                      Pattern[ part, Blank[]]], 
                    Take[ mat, part]], 
                  SetDelayed[ 
                    TakeColumns[ 
                      PatternTest[Pattern[ mat, Blank[]], MatrixQ], 
                      Pattern[ part, Blank[]]], 
                    Map[ Take[ #, part]&, mat]], 
                  SetOptions[ $Output, PageWidth -> Infinity], 
                  SetDelayed[ 
                    del[ 
                      Pattern[ M, Blank[]]], 
                    Union[ 
                      Flatten[ 
                        Map[ Position[ M, #]&, 
                          Select[ M, SameQ[ 
                              Apply[ Plus, 
                                Abs[ 
                                  N[ #]]], 0]&]]]]], 
                  SetDelayed[ 
                    etiq[ 
                      Pattern[ M, Blank[]], 
                      Optional[ 
                        Pattern[ nc, Blank[]], 0]], 
                    Module[ {m, n, xs, bs, hs, fs, Col}, 
                      CompoundExpression[ {
                        Set[ m, 
                          Part[ 
                            Dimensions[ M], 1]], 
                        Set[ n, 
                          Part[ 
                            Dimensions[ M], 2]], 
                        Set[ xs, 
                          Array[ Times[ "x", #]&, nc]], 
                        Set[ bs, 
                          Array[ Times[ "b", #]&, 
                            Plus[ n, 
                              Times[ -1, nc]]]], 
                        Set[ hs, 
                          Join[ xs, bs]], 
                        Set[ fs, 
                          Array[ Times[ "f", #]&, m]], 
                        Set[ Col, 
                          Array[ Times[ "c", #]&, n]], 
                        Set[ Fil, 
                          Array[ Times[ "f", #]&, m]]}, 
                        If[ 
                          SameQ[ nc, 0], 
                          MatrixForm[ 
                          M, TableHeadings -> {fs, Col, {}}, 
                            TableAlignments -> {Right, Right}, 
                            TableSpacing -> {1, 2}], 
                          MatrixForm[ 
                          M, TableHeadings -> {fs, hs, {}}, 
                            TableAlignments -> {Right, Right}, 
                            TableSpacing -> {1, 2}]]]]], 
                  SetDelayed[ 
                    fac[ 
                      Pattern[ M, Blank[]]], 
                    MapAll[ Factor[ #]&, M]], 
                  SetDelayed[ 
                    bloque[ 
                      Pattern[ M1, Blank[]], 
                      Pattern[ M2, Blank[]]], 
                    AppendRows[ M1, M2]], 
                  SetDelayed[ 
                    ampl[ 
                      Pattern[ M, Blank[]]], 
                    etiq[ 
                      bloque[ M, 
                        IdentityMatrix[ 
                          Length[ M]]]]], 
                  SetDelayed[ 
                    int[ 
                      Pattern[ i, Blank[]], 
                      Pattern[ j, Blank[]], 
                      Pattern[ A, Blank[]], 
                      Optional[ 
                        Pattern[ nc, Blank[]], 0]], 
                    Module[ {f1, f2, A1, A2}, 
                      CompoundExpression[ {
                        Set[ f1, 
                          Part[ A, i]], 
                        Set[ f2, 
                          Part[ A, j]], 
                        Set[ A1, 
                          ReplaceHeldPart[ A, 
                            Hold[ f2], i]], 
                        Set[ A2, 
                          ReplaceHeldPart[ A1, 
                            Hold[ f1], j]]}, 
                        etiq[ 
                          Chop[ A2, 
                            Power[ 10, -4]], nc]]]], 
                  SetDelayed[ 
                    div[ 
                      Pattern[ i, Blank[]], 
                      Pattern[ j, Blank[]], 
                      Pattern[ A, Blank[]], 
                      Optional[ 
                        Pattern[ nc, Blank[]], 0]], 
                    Module[ {mf, A1}, 
                      CompoundExpression[ {
                        Set[ mf, 
                          Times[ 
                            Times[ 1, 
                              Part[ A, i]], 
                            Power[ 
                              Part[ A, i, j], -1]]], 
                        Set[ A1, 
                          ReplaceHeldPart[ A, 
                            Hold[ mf], i]]}, 
                        etiq[ 
                          Chop[ 
                            fac[ A1], 
                            Power[ 10, -4]]]], nc]], 
                  SetDelayed[ 
                    mul[ 
                      Pattern[ i, Blank[]], 
                      Pattern[ k, Blank[]], 
                      Pattern[ A, Blank[]], 
                      Optional[ 
                        Pattern[ nc, Blank[]], 0]], 
                    Module[ {mf, A1}, 
                      CompoundExpression[ {
                        Set[ mf, 
                          Times[ k, 
                            Part[ A, i]]], 
                        Set[ A1, 
                          ReplaceHeldPart[ A, 
                            Hold[ mf], i]]}, 
                        etiq[ 
                          Chop[ 
                            fac[ A1], 
                            Power[ 10, -4]], nc]]]], 
                  SetDelayed[ 
                    sumar[ 
                      Pattern[ i, Blank[]], 
                      Pattern[ k, Blank[]], 
                      Pattern[ j, Blank[]], 
                      Pattern[ A, Blank[]], 
                      Optional[ 
                        Pattern[ nc, Blank[]], 0]], 
                    Module[ {f1, f2, A1}, 
                      CompoundExpression[ {
                        Set[ f1, 
                          Times[ k, 
                            Part[ A, i]]], 
                        Set[ f2, 
                          Plus[ f1, 
                            Part[ A, j]]], 
                        Set[ A1, 
                          fac[ 
                            ReplaceHeldPart[ A, 
                              Hold[ f2], j]]]}, 
                        etiq[ 
                          Chop[ A1, 
                            Power[ 10, -4]], nc]]]], 
                  SetDelayed[ 
                    ceros[ 
                      Pattern[ i, Blank[]], 
                      Pattern[ Fk, Blank[]], 
                      Pattern[ A, Blank[]], 
                      Optional[ 
                        Pattern[ nc, Blank[]], 0]], 
                    Module[ {sumar, elim, matfi}, 
                      CompoundExpression[ {
                        CompoundExpression[ 
                          SetDelayed[ 
                            sumar[ {
                              Pattern[ j, Blank[]], 
                              Pattern[ k, Blank[]]}, 
                              Pattern[ AA, Blank[]]], 
                            Module[ {f1, f2, A1}, 
                              CompoundExpression[ {
                                Set[ f1, 
                                  Times[ -1, 
                                    Times[ 
                                      Part[ AA, j, k], 
                                      Part[ AA, i]]]], 
                                Set[ f2, 
                                  Plus[ f1, 
                                    Part[ AA, j]]], 
                                Set[ A1, 
                                  ReplaceHeldPart[ AA, 
                                    Hold[ f2], j]]}, A1]]], 
                          SetDelayed[ 
                            elim[ 
                              Pattern[ AM, Blank[]], 1], 
                            sumar[ {i, 
                              Part[ Fk, 1]}, AM]], 
                          SetDelayed[ 
                            elim[ 
                              Pattern[ AM, Blank[]], 
                              Pattern[ jj, Blank[]]], 
                            Set[ 
                              elim[ AM, jj], 
                              sumar[ {
                                Part[ Fk, jj], i}, 
                                elim[ AM, 
                                  Plus[ jj, -1]]]]], 
                          Set[ matfi, 
                            fac[ 
                              elim[ A, 
                                Length[ Fk]]]]]}, 
                        etiq[ 
                          Chop[ matfi, 
                            Power[ 10, -4]], nc]]]], 
                  SetDelayed[ 
                    uno[ 
                      Pattern[ i, Blank[]], 
                      Pattern[ j, Blank[]], 
                      Pattern[ A, Blank[]], 
                      Optional[ 
                        Pattern[ nc, Blank[]], 0]], 
                    Module[ {fn, A1}, 
                      CompoundExpression[ {
                        Set[ fn, 
                          Times[ 
                            Times[ 1, 
                              Part[ A, i]], 
                            Power[ 
                              Part[ A, i, j], -1]]], 
                        Set[ A1, 
                          ReplaceHeldPart[ A, 
                            Hold[ fn], i]]}, 
                        etiq[ 
                          Chop[ 
                            fac[ A1], 
                            Power[ 10, -4]], nc]]]], 
                  SetDelayed[ 
                    edinitz[ 
                      Pattern[ M, Blank[]], 
                      Optional[ 
                        Pattern[ nc, Blank[]], 0]], 
                    Module[ {uno, fac, odin, A1}, 
                      CompoundExpression[ {
                        CompoundExpression[ 
                          SetDelayed[ 
                            uno[ 
                              Pattern[ i, Blank[]], 
                              Pattern[ A, Blank[]]], 
                            Module[ {fn, A2}, 
                              CompoundExpression[ {
                                Set[ fn, 
                                  If[ 
                                    Or[ 
                                      SameQ[ 
                                        Part[ A, i, i], 0], 
                                      SameQ[ 
                                        Part[ A, i, i], 0.0]], 
                                    Part[ A, i], 
                                    Times[ 
                                      Times[ 1, 
                                        Part[ A, i]], 
                                      Power[ 
                                        Part[ A, i, i], -1]]]], 
                                Set[ A2, 
                                  ReplaceHeldPart[ A, 
                                    Hold[ fn], i]]}, 
                                Chop[ 
                                  fac[ A2], 
                                  Power[ 10, -4]]]]], 
                          SetDelayed[ 
                            fac[ 
                              Pattern[ SS, Blank[]]], 
                            MapAll[ Factor[ #]&, SS]]], 
                        SetDelayed[ 
                          odin[ 1], 
                          uno[ 1, M]], 
                        SetDelayed[ 
                          odin[ 
                            Pattern[ jj, Blank[]]], 
                          Set[ 
                            odin[ jj], 
                            uno[ jj, 
                              odin[ 
                                Plus[ jj, -1]]]]], 
                        Set[ A1, 
                          etiq[ 
                            fac[ 
                              odin[ 
                                Length[ M]]], nc]]}, A1]]], 
                  SetDelayed[ 
                    nuli[ 
                      Pattern[ i, Blank[]], 
                      Pattern[ j, Blank[]], 
                      Pattern[ A, Blank[]], 
                      Optional[ 
                        Pattern[ nc, Blank[]], 0]], 
                    Module[ {pr, a1, f1, A1, A2}, 
                      CompoundExpression[ {
                        SetDelayed[ 
                          pr[ 
                            Pattern[ uu, Blank[]]], 
                          SetPrecision[ 
                            N[ uu], 20]], 
                        Set[ a1, 
                          Part[ A, i, j]], 
                        SetDelayed[ 
                          f1[ 
                            Pattern[ s, Blank[]]], 
                          Plus[ 
                            Times[ -1, 
                              Times[ 
                                Part[ A, s, j], 
                                Part[ A, i]]], 
                            Times[ a1, 
                              Part[ A, s]]]], 
                        SetDelayed[ 
                          A1[ 1], 
                          If[ 
                            SameQ[ i, 1], A, 
                            ReplaceHeldPart[ A, 
                              Hold[ 
                                f1[ 1]], 1]]], 
                        SetDelayed[ 
                          A1[ 
                            Pattern[ kk, Blank[]]], 
                          Set[ 
                            A1[ kk], 
                            If[ 
                              SameQ[ kk, i], 
                              A1[ 
                                Plus[ kk, -1]], 
                              ReplaceHeldPart[ 
                                A1[ 
                                  Plus[ kk, -1]], 
                                Hold[ 
                                  f1[ kk]], kk]]]], 
                        Set[ A2, 
                          fac[ 
                            A1[ 
                              Length[ A]]]]}, 
                        etiq[ 
                          Chop[ A2, 
                            Power[ 10, -5]], nc]]]], 
                  SetDelayed[ 
                    ecua[ 
                      Pattern[ M, Blank[]], 
                      Pattern[ vd, Blank[]], 
                      Optional[ 
                        Pattern[ vl, Blank[]], {}]], 
                    Module[ {pos, tam, linc, lc, lb, M1, M2}, 
                      CompoundExpression[ {
                        Set[ pos, 
                          Complement[ 
                            Array[ #&, 
                              Length[ M]], 
                            del[ M]]], 
                        Set[ M0, 
                          Part[ M, pos]], 
                        Set[ tam, 
                          Dimensions[ M0]], 
                        Set[ lb, 
                          Part[ 
                            TakeColumns[ M0, {
                              Part[ tam, 2], 
                              Part[ tam, 2]}], pos]], 
                        Set[ M1, 
                          TakeColumns[ M0, 
                            Plus[ 
                              Length[ vd], 
                              Length[ vl]]]], 
                        Set[ M2, 
                          Inner[ Equal, 
                            Dot[ M1, 
                              Union[ vd, vl]], lb, List]]}, {
                        TableForm[ {M2}, TableSpacing -> {4, 2}], 
                        TableForm[ 
                          Flatten[ 
                            fac[ 
                              Solve[ 
                                Flatten[ M2], vd]]]]}]]], Null]],
            ButtonEvaluator->"Local",
            Active->True,
            Background->RGBColor[0.996109, 0, 0]],
          FormatType->TraditionalForm,
          FontFamily->"Courier",
          FontSize->12,
          Background->RGBColor[1, 1, 0]], 


---------------------------------------------------------------------------

        ButtonBox[\(F\_i\[Divide]k\),
          
          ButtonFunction:>
            Module[ {ii, nn, xpr, dms, chstr, sel, preg, Fii, kee, xpr1}, 
              CompoundExpression[ {
                CompoundExpression[ 
                  Set[ ii, 
                    Random[ Integer, {1, 
                      Power[ 2, 100]}]], 
                  Set[ nn, 
                    InputNotebook[]]], 
                CompoundExpression[ 
                  SelectionMove[ nn, All, CellContents], 
                  Set[ xpr, 
                    ToExpression[ 
                      NotebookRead[ nn]]], 
                  Set[ dms, 
                    If[ 
                      MatrixQ[ xpr], 
                      Dimensions[ xpr], {}]]], 
                Set[ chstr, 
                  If[ 
                    SameQ[ dms, {}], {}, 
                    Part[ dms, 1]]], 
                Set[ sel, 
                  NotebookSelection[ nn]], 
                CompoundExpression[ 
                  SetOptions[ 
                  sel, FormatType -> TraditionalForm, Background -> RGBColor[ 
                    1, 1, 0], FontSize -> 16, FontFamily -> "Courier"], 
                  Set[ preg, 
                    spros[ 
                    "Dividir una fila por un n\[UAcute]mero\n o expresi\
\[OAcute]n", 
                      BoxData[ 
                        GridBox[ {{
                          InterpretationBox[ "", 
                            SequenceForm[], Editable -> False], 
                          InterpretationBox[ "", 
                            SequenceForm[], Editable -> False], 
                          InterpretationBox[ "", 
                            SequenceForm[], Editable -> False]}, {
                          StyleBox[ 
                            InterpretationBox[ "", 
                              SequenceForm[], Editable -> False], FontSize -> 
                            1], 
                          GridBox[ {{
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1]}, {
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            InterpretationBox[ 
                              TagBox[ 
                                StyleBox[ 
                                  TagBox[ 
                                    FormBox[ 
                                      TagBox[ 
                                        StyleBox[ 
                                        "Fila", FontFamily -> "Times"], 
                                        StyleForm[ #, FontFamily -> Times]&], 
                                      "TraditionalForm"], TraditionalForm, 
                                    Editable -> True], FontFamily -> "Times", 
                                  FontSize -> 16, FontSlant -> "Italic"], 
                                StyleForm[ #, FontFamily -> Times, FontSize -> 
                                  16, FontSlant -> Italic]&], 
                              StyleForm[ 
                                StyleForm[ Fila, FontFamily -> Times], 
                                FontFamily -> Times, FontSize -> 16, 
                                FontSlant -> Italic], Editable -> False], 
                            "\[SelectionPlaceholder]", 
                            StyleBox[ "\"\[Divide]\"", FontFamily -> "Times"],
                             "\[Placeholder]", 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1]}, {
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], 
                              FontSize -> .10000000000000001], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1]}}], 
                          StyleBox[ 
                            InterpretationBox[ "", 
                              SequenceForm[], Editable -> False], FontSize -> 
                            1]}, {
                          InterpretationBox[ "", 
                            SequenceForm[], Editable -> False], 
                          InterpretationBox[ "", 
                            SequenceForm[], Editable -> False], 
                          InterpretationBox[ "", 
                            SequenceForm[], Editable -> False]}}]]]], 
                  NotebookLocate[ "LaEntrada"], 
                  SelectionMove[ nn, All, CellContents], 
                  Set[ Fii, 
                    Part[ preg, 2, 2, 2, 3]]], 
                CompoundExpression[ 
                  Set[ kee, 
                    Part[ preg, 2, 2, 2, 5]], 
                  Set[ xpr1, 
                    If[ 
                      Or[ 
                        Not[ 
                          LessEqual[ 1, Fii, chstr]], 
                        SameQ[ 
                          Simplify[ kee], 0], 
                        SameQ[ 
                          N[ kee], 0], 
                        Not[ 
                          IntegerQ[ Fii]], 
                        Not[ 
                          Greater[ 
                            N[ Fii], 0]], 
                        SameQ[ xpr, $Failed], 
                        Not[ 
                          MatrixQ[ xpr]]], {}, 
                      mul[ Fii, 
                        Times[ 1, 
                          Power[ kee, -1]], xpr]]]]}, 
                If[ 
                  Or[ 
                    Not[ 
                      LessEqual[ 1, Fii, chstr]], 
                    SameQ[ 
                      Simplify[ kee], 0], 
                    SameQ[ 
                      N[ kee], 0], 
                    Not[ 
                      IntegerQ[ Fii]], 
                    Not[ 
                      Greater[ 
                        N[ Fii], 0]], 
                    SameQ[ xpr, $Failed], 
                    Not[ 
                      MatrixQ[ xpr]]], Null, {
                  If[ 
                    Or[ 
                      SameQ[ $VersionNumber, 4.0999999999999996], 
                      SameQ[ $VersionNumber, 4.0]], 
                    SelectionMove[ nn, After, EvaluationCell], 
                    SelectionMove[ nn, After, Cell]], 
                  NotebookWrite[ nn, 
                    
                    txt[ {"Se divide la fila  ", Fii, "  por  ", kee, "  :"}, 
                      Background -> 
                      RGBColor[ .99610900000000002, .87110699999999996, \
.87110699999999996]]], 
                  NotebookWrite[ nn, 
                    frmt[ xpr1, ii]], 
                  NotebookFind[ nn, 
                    ToString[ ii], All, CellTags], 
                  SelectionMove[ nn, All, CellContents]}]]],
          ButtonEvaluator->"Local",
          Active->True,
          Background->RGBColor[0.996109, 0.996109, 0]], 


---------------------------------------------------------------------------


        ButtonBox["\"\<\\!\\(F\\_i\\)\[Times]k\>\"",
          
          ButtonFunction:>
            Module[ {ii, nn, xpr, dms, chstr, sel, preg, Fii, kee, xpr1}, 
              CompoundExpression[ {
                CompoundExpression[ 
                  Set[ ii, 
                    Random[ Integer, {1, 
                      Power[ 2, 100]}]], 
                  Set[ nn, 
                    InputNotebook[]]], 
                CompoundExpression[ 
                  SelectionMove[ nn, All, CellContents], 
                  Set[ xpr, 
                    ToExpression[ 
                      NotebookRead[ nn]]], 
                  Set[ dms, 
                    If[ 
                      MatrixQ[ xpr], 
                      Dimensions[ xpr], {}]]], 
                Set[ chstr, 
                  If[ 
                    SameQ[ dms, {}], {}, 
                    Part[ dms, 1]]], 
                Set[ sel, 
                  NotebookSelection[ nn]], 
                CompoundExpression[ 
                  SetOptions[ 
                  sel, FormatType -> TraditionalForm, Background -> RGBColor[ 
                    1, 1, 0], FontSize -> 16, FontFamily -> "Courier"], 
                  Set[ preg, 
                    spros[ 
                    "Multiplicar una fila por un n\[UAcute]mero\n o expresi\
\[OAcute]n", 
                      BoxData[ 
                        GridBox[ {{
                          InterpretationBox[ "", 
                            SequenceForm[], Editable -> False], 
                          InterpretationBox[ "", 
                            SequenceForm[], Editable -> False], 
                          InterpretationBox[ "", 
                            SequenceForm[], Editable -> False]}, {
                          StyleBox[ 
                            InterpretationBox[ "", 
                              SequenceForm[], Editable -> False], FontSize -> 
                            1], 
                          GridBox[ {{
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1]}, {
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            InterpretationBox[ 
                              TagBox[ 
                                StyleBox[ 
                                  TagBox[ 
                                    FormBox[ 
                                      TagBox[ 
                                        StyleBox[ 
                                        "Fila", FontFamily -> "Times"], 
                                        StyleForm[ #, FontFamily -> Times]&], 
                                      "TraditionalForm"], TraditionalForm, 
                                    Editable -> True], FontFamily -> "Times", 
                                  FontSize -> 16, FontSlant -> "Italic"], 
                                StyleForm[ #, FontFamily -> Times, FontSize -> 
                                  16, FontSlant -> Italic]&], 
                              StyleForm[ 
                                StyleForm[ Fila, FontFamily -> Times], 
                                FontFamily -> Times, FontSize -> 16, 
                                FontSlant -> Italic], Editable -> False], 
                            "\[SelectionPlaceholder]", 
                            StyleBox[ "\"\[Times]\"", FontFamily -> "Times"], 
                            "\[Placeholder]", 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1]}, {
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1]}}], 
                          StyleBox[ 
                            InterpretationBox[ "", 
                              SequenceForm[], Editable -> False], FontSize -> 
                            1]}, {
                          InterpretationBox[ "", 
                            SequenceForm[], Editable -> False], 
                          InterpretationBox[ "", 
                            SequenceForm[], Editable -> False], 
                          InterpretationBox[ "", 
                            SequenceForm[], Editable -> False]}}]]]], 
                  NotebookLocate[ "LaEntrada"], 
                  SelectionMove[ nn, All, CellContents], 
                  Set[ Fii, 
                    Part[ preg, 2, 2, 2, 3]]], 
                CompoundExpression[ 
                  Set[ kee, 
                    Part[ preg, 2, 2, 2, 5]], 
                  Set[ xpr1, 
                    If[ 
                      Or[ 
                        Not[ 
                          LessEqual[ 1, Fii, chstr]], 
                        SameQ[ 
                          Simplify[ kee], 0], 
                        SameQ[ 
                          N[ kee], 0], 
                        Not[ 
                          IntegerQ[ Fii]], 
                        Not[ 
                          Greater[ 
                            N[ Fii], 0]], 
                        SameQ[ xpr, $Failed], 
                        Not[ 
                          MatrixQ[ xpr]]], {}, 
                      mul[ Fii, kee, xpr]]]]}, 
                If[ 
                  Or[ 
                    Not[ 
                      LessEqual[ 1, Fii, chstr]], 
                    SameQ[ 
                      Simplify[ kee], 0], 
                    SameQ[ 
                      N[ kee], 0], 
                    Not[ 
                      IntegerQ[ Fii]], 
                    Not[ 
                      Greater[ 
                        N[ Fii], 0]], 
                    SameQ[ xpr, $Failed], 
                    Not[ 
                      MatrixQ[ xpr]]], Null, {
                  If[ 
                    Or[ 
                      SameQ[ $VersionNumber, 4.0999999999999996], 
                      SameQ[ $VersionNumber, 4.0]], 
                    SelectionMove[ nn, After, EvaluationCell], 
                    SelectionMove[ nn, After, Cell]], 
                  NotebookWrite[ nn, 
                    
                    txt[ {"Se multiplica la fila  ", Fii, "  por  ", kee, 
                      "  :"}, Background -> 
                      RGBColor[ .99610900000000002, .87110699999999996, \
.87110699999999996]]], 
                  NotebookWrite[ nn, 
                    frmt[ xpr1, ii]], 
                  NotebookFind[ nn, 
                    ToString[ ii], All, CellTags], 
                  SelectionMove[ nn, All, CellContents]}]]],
          ButtonEvaluator->"Local",
          Active->True,
          Background->RGBColor[0.996109, 0.996109, 0]], 

---------------------------------------------------------------------------


        ButtonBox["\"\<\\!\\(F\\_i\\)+k \\!\\(F\\_j\\)\>\"",
          
          ButtonFunction:>
            Module[ {ii, nn, xpr, dms, chstr, nucol, sel, preg, Fii, Fjj, kee,
               xpr1}, 
              CompoundExpression[ {
                CompoundExpression[ 
                  Set[ ii, 
                    Random[ Integer, {1, 
                      Power[ 2, 100]}]], 
                  Set[ nn, 
                    InputNotebook[]]], 
                CompoundExpression[ 
                  SelectionMove[ nn, All, CellContents], 
                  Set[ xpr, 
                    ToExpression[ 
                      NotebookRead[ nn]]], 
                  Set[ dms, 
                    If[ 
                      MatrixQ[ xpr], 
                      Dimensions[ xpr], {}]]], 
                Set[ chstr, 
                  If[ 
                    SameQ[ dms, {}], {}, 
                    Part[ dms, 1]]], 
                Set[ nucol, 
                  If[ 
                    SameQ[ dms, {}], {}, 
                    Part[ dms, 2]]], 
                Set[ sel, 
                  NotebookSelection[ nn]], 
                CompoundExpression[ 
                  SetOptions[ 
                  sel, FormatType -> TraditionalForm, Background -> RGBColor[ 
                    1, 1, 0], FontSize -> 16, FontFamily -> "Courier"], 
                  Set[ preg, 
                    spros[ 
                    "Multiplicar una fila por un n\[UAcute]mero o expresi\
\[OAcute]n y sumar este resultado a otra fila", 
                      BoxData[ 
                        GridBox[ {{
                          StyleBox[ 
                            InterpretationBox[ "", 
                              SequenceForm[], Editable -> False], FontSize -> 
                            1], 
                          StyleBox[ 
                            InterpretationBox[ "", 
                              SequenceForm[], Editable -> False], FontSize -> 
                            1], 
                          StyleBox[ 
                            InterpretationBox[ "", 
                              SequenceForm[], Editable -> False], FontSize -> 
                            1], 
                          StyleBox[ 
                            InterpretationBox[ "", 
                              SequenceForm[], Editable -> False], FontSize -> 
                            1], 
                          StyleBox[ 
                            InterpretationBox[ "", 
                              SequenceForm[], Editable -> False], FontSize -> 
                            1]}, {
                          StyleBox[ 
                            InterpretationBox[ "", 
                              SequenceForm[], Editable -> False], FontSize -> 
                            1], 
                          InterpretationBox[ 
                            TagBox[ 
                              StyleBox[ 
                                TagBox[ 
                                  StyleBox[ 
                                  "\"Multiplicar la fila \[RightArrow]\"", 
                                    FontFamily -> "Times"], 
                                  StyleForm[ #, FontFamily -> Times]&], 
                                FontFamily -> "Times", FontSlant -> "Italic"],
                               StyleForm[ #, FontFamily -> Times, FontSlant -> 
                                Italic]&], 
                            SequenceForm[ 
                              StyleForm[ 
                                StyleForm[ 
                                "Multiplicar la fila \[RightArrow]", 
                                  FontFamily -> Times], FontFamily -> Times, 
                                FontSlant -> Italic]], Editable -> False], 
                          "\[SelectionPlaceholder]", 
                          InterpretationBox[ 
                            TagBox[ 
                              StyleBox[ 
                                TagBox[ 
                                  StyleBox[ 
                                  "\"\[Times]\"", FontFamily -> "Times"], 
                                  StyleForm[ #, FontFamily -> Times]&], 
                                FontFamily -> "Times", FontSlant -> "Italic"],
                               StyleForm[ #, FontFamily -> Times, FontSlant -> 
                                Italic]&], 
                            SequenceForm[ 
                              StyleForm[ 
                                StyleForm[ "\[Times]", FontFamily -> Times], 
                                FontFamily -> Times, FontSlant -> Italic]], 
                            Editable -> False], 
                          StyleBox[ 
                            InterpretationBox[ "", 
                              SequenceForm[], Editable -> False], FontSize -> 
                            1]}, {
                          StyleBox[ 
                            InterpretationBox[ "", 
                              SequenceForm[], Editable -> False], FontSize -> 
                            1], "\[Placeholder]", 
                          InterpretationBox[ 
                            TagBox[ 
                              StyleBox[ 
                                TagBox[ 
                                  StyleBox[ 
                                  "\"y sumar este resultado a la fila\"", 
                                    FontFamily -> "Times"], 
                                  StyleForm[ #, FontFamily -> Times]&], 
                                FontFamily -> "Times", FontSlant -> "Italic"],
                               StyleForm[ #, FontFamily -> Times, FontSlant -> 
                                Italic]&], 
                            SequenceForm[ 
                              StyleForm[ 
                                StyleForm[ 
                                "y sumar este resultado a la fila", 
                                  FontFamily -> Times], FontFamily -> Times, 
                                FontSlant -> Italic]], Editable -> False], 
                          "\[Placeholder]", 
                          StyleBox[ 
                            InterpretationBox[ "", 
                              SequenceForm[], Editable -> False], FontSize -> 
                            1]}, {
                          StyleBox[ 
                            InterpretationBox[ "", 
                              SequenceForm[], Editable -> False], FontSize -> 
                            1], 
                          StyleBox[ 
                            InterpretationBox[ "", 
                              SequenceForm[], Editable -> False], FontSize -> 
                            1], 
                          StyleBox[ 
                            InterpretationBox[ "", 
                              SequenceForm[], Editable -> False], FontSize -> 
                            1], 
                          StyleBox[ 
                            InterpretationBox[ "", 
                              SequenceForm[], Editable -> False], FontSize -> 
                            1], 
                          StyleBox[ 
                            InterpretationBox[ "", 
                              SequenceForm[], Editable -> False], FontSize -> 
                            1]}}]], {500, 150}]], 
                  NotebookLocate[ "LaEntrada"], 
                  SelectionMove[ nn, All, CellContents], 
                  Set[ Fii, 
                    Part[ preg, 2, 3]]], 
                Set[ Fjj, 
                  Part[ preg, 3, 4]], 
                CompoundExpression[ 
                  Set[ kee, 
                    Part[ preg, 3, 2]], 
                  Set[ xpr1, 
                    If[ 
                      Or[ 
                        Not[ 
                          LessEqual[ 1, Fii, chstr]], 
                        Not[ 
                          LessEqual[ 1, Fjj, chstr]], 
                        SameQ[ 
                          Simplify[ kee], 0], 
                        Not[ 
                          IntegerQ[ Fii]], 
                        Not[ 
                          Greater[ 
                            N[ Fii], 0]], 
                        Not[ 
                          IntegerQ[ Fjj]], 
                        Not[ 
                          Greater[ 
                            N[ Fjj], 0]], 
                        SameQ[ xpr, $Failed], 
                        Not[ 
                          MatrixQ[ xpr]]], {}, 
                      sumar[ Fii, kee, Fjj, xpr]]]]}, 
                If[ 
                  Or[ 
                    Not[ 
                      LessEqual[ 1, Fii, chstr]], 
                    Not[ 
                      LessEqual[ 1, Fjj, chstr]], 
                    SameQ[ 
                      Simplify[ kee], 0], 
                    Not[ 
                      IntegerQ[ Fii]], 
                    Not[ 
                      Greater[ 
                        N[ Fii], 0]], 
                    Not[ 
                      IntegerQ[ Fjj]], 
                    Not[ 
                      Greater[ 
                        N[ Fjj], 0]], 
                    SameQ[ xpr, $Failed], 
                    Not[ 
                      MatrixQ[ xpr]]], Null, {
                  If[ 
                    Or[ 
                      SameQ[ $VersionNumber, 4.0999999999999996], 
                      SameQ[ $VersionNumber, 4.0]], 
                    SelectionMove[ nn, After, EvaluationCell], 
                    SelectionMove[ nn, After, Cell]], 
                  NotebookWrite[ nn, 
                    
                    txt[ {"Se multiplica la fila  ", Fii, "  por  ", kee, 
                      " y este resultado se suma a la fila  ", Fjj}, 
                      Background -> 
                      RGBColor[ .99610900000000002, .87110699999999996, \
.87110699999999996]]], 
                  NotebookWrite[ nn, 
                    frmt[ xpr1, ii]], 
                  NotebookFind[ nn, 
                    ToString[ ii], All, CellTags], 
                  SelectionMove[ nn, All, CellContents]}]]],
          ButtonEvaluator->"Local",
          Active->True,
          Background->RGBColor[0.996109, 0.996109, 0]], 


---------------------------------------------------------------------------


        ButtonBox["\"\<\\!\\(F\\_i \[LeftRightArrow] F\\_j\\)\>\"",
          
          ButtonFunction:>
            Module[ {ii, nn, xpr, dms, chstr, sel, preg, Fii, kee, xpr1}, 
              CompoundExpression[ {
                CompoundExpression[ 
                  Set[ ii, 
                    Random[ Integer, {1, 
                      Power[ 2, 100]}]], 
                  Set[ nn, 
                    InputNotebook[]]], 
                CompoundExpression[ 
                  SelectionMove[ nn, All, CellContents], 
                  Set[ xpr, 
                    ToExpression[ 
                      NotebookRead[ nn]]], 
                  Set[ dms, 
                    If[ 
                      MatrixQ[ xpr], 
                      Dimensions[ xpr], {}]]], 
                Set[ chstr, 
                  If[ 
                    SameQ[ dms, {}], {}, 
                    Part[ dms, 1]]], 
                Set[ sel, 
                  NotebookSelection[ nn]], 
                CompoundExpression[ 
                  SetOptions[ 
                  sel, FormatType -> TraditionalForm, Background -> RGBColor[ 
                    1, 1, 0], FontSize -> 16, FontFamily -> "Courier"], 
                  Set[ preg, 
                    spros[ "Intercambio de filas", 
                      BoxData[ 
                        GridBox[ {{
                          InterpretationBox[ "", 
                            SequenceForm[], Editable -> False], 
                          InterpretationBox[ "", 
                            SequenceForm[], Editable -> False], 
                          InterpretationBox[ "", 
                            SequenceForm[], Editable -> False]}, {
                          StyleBox[ 
                            InterpretationBox[ "", 
                              SequenceForm[], Editable -> False], FontSize -> 
                            1], 
                          GridBox[ {{
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1]}, {
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            InterpretationBox[ 
                              TagBox[ 
                                StyleBox[ 
                                  TagBox[ 
                                    FormBox[ 
                                      TagBox[ 
                                        StyleBox[ 
                                        "Filas", FontFamily -> "Times"], 
                                        StyleForm[ #, FontFamily -> Times]&], 
                                      "TraditionalForm"], TraditionalForm, 
                                    Editable -> True], FontFamily -> "Times", 
                                  FontSize -> 16, FontSlant -> "Italic"], 
                                StyleForm[ #, FontFamily -> Times, FontSize -> 
                                  16, FontSlant -> Italic]&], 
                              StyleForm[ 
                                StyleForm[ Fila, FontFamily -> Times], 
                                FontFamily -> Times, FontSize -> 16, 
                                FontSlant -> Italic], Editable -> False], 
                            "\[SelectionPlaceholder]", 
                            StyleBox[ 
                            "\"\[LongLeftRightArrow]\"", FontFamily -> 
                              "Times"], "\[Placeholder]", 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1]}, {
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1]}}], 
                          StyleBox[ 
                            InterpretationBox[ "", 
                              SequenceForm[], Editable -> False], FontSize -> 
                            1]}, {
                          InterpretationBox[ "", 
                            SequenceForm[], Editable -> False], 
                          InterpretationBox[ "", 
                            SequenceForm[], Editable -> False], 
                          InterpretationBox[ "", 
                            SequenceForm[], Editable -> False]}}]]]], 
                  NotebookLocate[ "LaEntrada"], 
                  SelectionMove[ nn, All, CellContents], 
                  Set[ Fii, 
                    Part[ preg, 2, 2, 2, 3]]], 
                CompoundExpression[ 
                  Set[ kee, 
                    Part[ preg, 2, 2, 2, 5]], 
                  Set[ xpr1, 
                    If[ 
                      Or[ 
                        Not[ 
                          LessEqual[ 1, Fii, chstr]], 
                        Not[ 
                          LessEqual[ 1, kee, chstr]], 
                        Not[ 
                          IntegerQ[ Fii]], 
                        Not[ 
                          Greater[ 
                            N[ Fii], 0]], 
                        Not[ 
                          IntegerQ[ kee]], 
                        Not[ 
                          Greater[ 
                            N[ kee], 0]], 
                        SameQ[ xpr, $Failed], 
                        Not[ 
                          MatrixQ[ xpr]]], {}, 
                      int[ Fii, kee, xpr]]]]}, 
                If[ 
                  Or[ 
                    Not[ 
                      LessEqual[ 1, Fii, chstr]], 
                    Not[ 
                      LessEqual[ 1, kee, chstr]], 
                    Not[ 
                      IntegerQ[ Fii]], 
                    Not[ 
                      Greater[ 
                        N[ Fii], 0]], 
                    Not[ 
                      IntegerQ[ kee]], 
                    Not[ 
                      Greater[ 
                        N[ kee], 0]], 
                    SameQ[ xpr, $Failed], 
                    Not[ 
                      MatrixQ[ xpr]]], Null, {
                  If[ 
                    Or[ 
                      SameQ[ $VersionNumber, 4.0999999999999996], 
                      SameQ[ $VersionNumber, 4.0]], 
                    SelectionMove[ nn, After, EvaluationCell], 
                    SelectionMove[ nn, After, Cell]], 
                  NotebookWrite[ nn, 
                    
                    txt[ {"Se intercambian las filas  ", Fii, "  y  ", kee, 
                      "  :"}, Background -> 
                      RGBColor[ .99610900000000002, .87110699999999996, \
.87110699999999996]]], 
                  NotebookWrite[ nn, 
                    frmt[ xpr1, ii]], 
                  NotebookFind[ nn, 
                    ToString[ ii], All, CellTags], 
                  SelectionMove[ nn, All, CellContents]}]]],
          ButtonEvaluator->"Local",
          Active->True,
          Background->RGBColor[0.996109, 0.996109, 0]], 

---------------------------------------------------------------------------


        ButtonBox["\"\<000\>\"",
          
          ButtonFunction:>
            Module[ {ii, nn, xpr, dms, chstr, nucol, sel, preg, Fii, kee, 
              xpr1}, 
              CompoundExpression[ {
                CompoundExpression[ 
                  Set[ ii, 
                    Random[ Integer, {1, 
                      Power[ 2, 100]}]], 
                  Set[ nn, 
                    InputNotebook[]]], 
                CompoundExpression[ 
                  SelectionMove[ nn, All, CellContents], 
                  Set[ xpr, 
                    ToExpression[ 
                      NotebookRead[ nn]]], 
                  Set[ dms, 
                    If[ 
                      MatrixQ[ xpr], 
                      Dimensions[ xpr], {}]]], 
                Set[ chstr, 
                  If[ 
                    SameQ[ dms, {}], {}, 
                    Part[ dms, 1]]], 
                Set[ nucol, 
                  If[ 
                    SameQ[ dms, {}], {}, 
                    Part[ dms, 2]]], 
                Set[ sel, 
                  NotebookSelection[ nn]], 
                CompoundExpression[ 
                  SetOptions[ 
                  sel, FormatType -> TraditionalForm, Background -> RGBColor[ 
                    1, 1, 0], FontSize -> 16, FontFamily -> "Courier"], 
                  Set[ preg, 
                    spros[ 
                    "Indique la posici\[OAcute]n escogida para el pivote", 
                      BoxData[ 
                        GridBox[ {{
                          InterpretationBox[ "", 
                            SequenceForm[], Editable -> False], 
                          InterpretationBox[ "", 
                            SequenceForm[], Editable -> False], 
                          InterpretationBox[ "", 
                            SequenceForm[], Editable -> False]}, {
                          StyleBox[ 
                            InterpretationBox[ "", 
                              SequenceForm[], Editable -> False], FontSize -> 
                            1], 
                          GridBox[ {{
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1]}, {
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            InterpretationBox[ 
                              TagBox[ 
                                StyleBox[ 
                                  TagBox[ 
                                    FormBox[ 
                                      TagBox[ 
                                        StyleBox[ 
                                        "Posici\[OAcute]n", FontFamily -> 
                                        "Times"], 
                                        StyleForm[ #, FontFamily -> Times]&], 
                                      "TraditionalForm"], TraditionalForm, 
                                    Editable -> True], FontFamily -> "Times", 
                                  FontSize -> 16, FontSlant -> "Italic"], 
                                StyleForm[ #, FontFamily -> Times, FontSize -> 
                                  16, FontSlant -> Italic]&], 
                              StyleForm[ 
                                StyleForm[ Fila, FontFamily -> Times], 
                                FontFamily -> Times, FontSize -> 16, 
                                FontSlant -> Italic], Editable -> False], 
                            "\[SelectionPlaceholder]", 
                            StyleBox[ "\";\"", FontFamily -> "Times"], 
                            "\[Placeholder]", 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1]}, {
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1]}}], 
                          StyleBox[ 
                            InterpretationBox[ "", 
                              SequenceForm[], Editable -> False], FontSize -> 
                            1]}, {
                          InterpretationBox[ "", 
                            SequenceForm[], Editable -> False], 
                          InterpretationBox[ "", 
                            SequenceForm[], Editable -> False], 
                          InterpretationBox[ "", 
                            SequenceForm[], Editable -> False]}}]]]], 
                  NotebookLocate[ "LaEntrada"], 
                  SelectionMove[ nn, All, CellContents], 
                  Set[ Fii, 
                    Part[ preg, 2, 2, 2, 3]]], 
                CompoundExpression[ 
                  Set[ kee, 
                    Part[ preg, 2, 2, 2, 5]], 
                  Set[ xpr1, 
                    If[ 
                      Or[ 
                        Not[ 
                          LessEqual[ 1, Fii, chstr]], 
                        Not[ 
                          LessEqual[ 1, kee, nucol]], 
                        SameQ[ 
                          Simplify[ 
                            Part[ xpr, Fii, kee]], 0], 
                        Not[ 
                          IntegerQ[ Fii]], 
                        Not[ 
                          Greater[ 
                            N[ Fii], 0]], 
                        SameQ[ xpr, $Failed], 
                        Not[ 
                          MatrixQ[ xpr]], 
                        Not[ 
                          IntegerQ[ kee]], 
                        Not[ 
                          Greater[ 
                            N[ kee], 0]], 
                        SameQ[ 
                          Simplify[ 
                            Part[ xpr, Fii, kee]], 0]], {}, 
                      nuli[ Fii, kee, xpr]]]]}, 
                If[ 
                  Or[ 
                    Not[ 
                      LessEqual[ 1, Fii, chstr]], 
                    Not[ 
                      LessEqual[ 1, kee, nucol]], 
                    Not[ 
                      IntegerQ[ Fii]], 
                    Not[ 
                      Greater[ 
                        N[ Fii], 0]], 
                    SameQ[ xpr, $Failed], 
                    Not[ 
                      MatrixQ[ xpr]], 
                    Not[ 
                      IntegerQ[ kee]], 
                    Not[ 
                      Greater[ 
                        N[ kee], 0]]], Null, {
                  If[ 
                    Or[ 
                      SameQ[ $VersionNumber, 4.0999999999999996], 
                      SameQ[ $VersionNumber, 4.0]], 
                    SelectionMove[ nn, After, EvaluationCell], 
                    SelectionMove[ nn, After, Cell]], 
                  NotebookWrite[ nn, 
                    
                    txt[ {"Se pivotea en la posici\[OAcute]n  (", Fii, 
                      "  ,  ", kee, ")  :"}, Background -> 
                      RGBColor[ .99610900000000002, .87110699999999996, \
.87110699999999996]]], 
                  NotebookWrite[ nn, 
                    frmt[ xpr1, ii]], 
                  NotebookFind[ nn, 
                    ToString[ ii], All, CellTags], 
                  SelectionMove[ nn, All, CellContents]}]]],
          ButtonEvaluator->"Local",
          Active->True,
          Background->RGBColor[0, 1, 1]], 

---------------------------------------------------------------------------


        ButtonBox["111",
          ButtonFunction:>Module[ {nn, sel, preg, xpr, xpr1}, 
              CompoundExpression[ {
                Set[ nn, 
                  InputNotebook[]], 
                CompoundExpression[ 
                  SelectionMove[ nn, All, CellContents], 
                  Set[ sel, 
                    NotebookSelection[ nn]]], 
                CompoundExpression[ 
                  SetOptions[ 
                  sel, FormatType -> TraditionalForm, Background -> RGBColor[ 
                    1, 1, 0], FontSize -> 16, FontFamily -> "Courier"], 
                  SelectionMove[ nn, All, CellContents], 
                  Set[ xpr, 
                    ToExpression[ 
                      NotebookRead[ nn]]], 
                  Set[ xpr1, 
                    If[ 
                      MatrixQ[ xpr], 
                      etiq[ 
                        princ1[ xpr]], {}]], Null]}, 
                If[ 
                  Not[ 
                    MatrixQ[ xpr]], Null, {
                  If[ 
                    Or[ 
                      SameQ[ $VersionNumber, 4.0999999999999996], 
                      SameQ[ $VersionNumber, 4.0]], 
                    SelectionMove[ nn, After, EvaluationCell], 
                    SelectionMove[ nn, After, Cell]], 
                  NotebookWrite[ nn, 
                    
                    txt[ {"Se convierten en 1 las entradas principales de la \
matriz"}, Background -> 
                      RGBColor[ .99610900000000002, .84766900000000001, \
.84766900000000001]]], 
                  NotebookWrite[ nn, 
                    ToBoxes[ 
                      StyleForm[ 
                      xpr1, FontFamily -> "Courier", FontSize -> 16, 
                        Background -> RGBColor[ 1, 1, 0]]]], 
                  SelectionMove[ nn, All, CellContents]}]]],
          ButtonEvaluator->"Local",
          Active->True,
          Background->RGBColor[0, 0.996109, 0.996109]], 

--------------------------------------------------------------------------- 

        ButtonBox["pivote",
          
          ButtonFunction:>
            Module[ {ii, nn, xpr, dms, chstr, nucol, sel, preg, Fii, kee, 
              xpr1}, 
              CompoundExpression[ {
                CompoundExpression[ 
                  Set[ ii, 
                    Random[ Integer, {1, 
                      Power[ 2, 100]}]], 
                  Set[ nn, 
                    InputNotebook[]]], 
                CompoundExpression[ 
                  SelectionMove[ nn, All, CellContents], 
                  Set[ xpr, 
                    ToExpression[ 
                      NotebookRead[ nn]]], 
                  Set[ dms, 
                    If[ 
                      MatrixQ[ xpr], 
                      Dimensions[ xpr], {}]]], 
                Set[ chstr, 
                  If[ 
                    SameQ[ dms, {}], {}, 
                    Part[ dms, 1]]], 
                Set[ nucol, 
                  If[ 
                    SameQ[ dms, {}], {}, 
                    Part[ dms, 2]]], 
                Set[ sel, 
                  NotebookSelection[ nn]], 
                CompoundExpression[ 
                  SetOptions[ 
                  sel, FormatType -> TraditionalForm, Background -> RGBColor[ 
                    1, 1, 0], FontSize -> 16, FontFamily -> "Courier"], 
                  Set[ preg, 
                    spros[ 
                    "Indique la posici\[OAcute]n escogida para el pivote ", 
                      BoxData[ 
                        GridBox[ {{
                          InterpretationBox[ "", 
                            SequenceForm[], Editable -> False], 
                          InterpretationBox[ "", 
                            SequenceForm[], Editable -> False], 
                          InterpretationBox[ "", 
                            SequenceForm[], Editable -> False]}, {
                          StyleBox[ 
                            InterpretationBox[ "", 
                              SequenceForm[], Editable -> False], FontSize -> 
                            1], 
                          GridBox[ {{
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1]}, {
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            InterpretationBox[ 
                              TagBox[ 
                                StyleBox[ 
                                  TagBox[ 
                                    FormBox[ 
                                      TagBox[ 
                                        StyleBox[ 
                                        "Posici\[OAcute]n", FontFamily -> 
                                        "Times"], 
                                        StyleForm[ #, FontFamily -> Times]&], 
                                      "TraditionalForm"], TraditionalForm, 
                                    Editable -> True], FontFamily -> "Times", 
                                  FontSize -> 16, FontSlant -> "Italic"], 
                                StyleForm[ #, FontFamily -> Times, FontSize -> 
                                  16, FontSlant -> Italic]&], 
                              StyleForm[ 
                                StyleForm[ Fila, FontFamily -> Times], 
                                FontFamily -> Times, FontSize -> 16, 
                                FontSlant -> Italic], Editable -> False], 
                            "\[SelectionPlaceholder]", 
                            StyleBox[ "\";\"", FontFamily -> "Times"], 
                            "\[Placeholder]", 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1]}, {
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1]}}], 
                          StyleBox[ 
                            InterpretationBox[ "", 
                              SequenceForm[], Editable -> False], FontSize -> 
                            1]}, {
                          InterpretationBox[ "", 
                            SequenceForm[], Editable -> False], 
                          InterpretationBox[ "", 
                            SequenceForm[], Editable -> False], 
                          InterpretationBox[ "", 
                            SequenceForm[], Editable -> False]}}]]]], 
                  NotebookLocate[ "LaEntrada"], 
                  SelectionMove[ nn, All, CellContents], 
                  Set[ Fii, 
                    Part[ preg, 2, 2, 2, 3]]], 
                CompoundExpression[ 
                  Set[ kee, 
                    Part[ preg, 2, 2, 2, 5]], 
                  Set[ xpr1, 
                    If[ 
                      Or[ 
                        Not[ 
                          LessEqual[ 1, Fii, chstr]], 
                        Not[ 
                          LessEqual[ 1, kee, nucol]], 
                        SameQ[ 
                          Simplify[ 
                            Part[ xpr, Fii, kee]], 0], 
                        Not[ 
                          IntegerQ[ Fii]], 
                        Not[ 
                          Greater[ 
                            N[ Fii], 0]], 
                        SameQ[ xpr, $Failed], 
                        Not[ 
                          MatrixQ[ xpr]], 
                        Not[ 
                          IntegerQ[ kee]], 
                        Not[ 
                          Greater[ 
                            N[ kee], 0]], 
                        SameQ[ 
                          Simplify[ 
                            Part[ xpr, Fii, kee]], 0]], {}, 
                      uno[ Fii, kee, xpr]]]]}, 
                If[ 
                  Or[ 
                    Not[ 
                      LessEqual[ 1, Fii, chstr]], 
                    Not[ 
                      LessEqual[ 1, kee, nucol]], 
                    SameQ[ 
                      Simplify[ 
                        Part[ xpr, Fii, kee]], 0], 
                    Not[ 
                      IntegerQ[ Fii]], 
                    Not[ 
                      Greater[ 
                        N[ Fii], 0]], 
                    SameQ[ xpr, $Failed], 
                    Not[ 
                      MatrixQ[ xpr]], 
                    Not[ 
                      IntegerQ[ kee]], 
                    Not[ 
                      Greater[ 
                        N[ kee], 0]], 
                    SameQ[ 
                      Simplify[ 
                        Part[ xpr, Fii, kee]], 0]], Null, {
                  If[ 
                    Or[ 
                      SameQ[ $VersionNumber, 4.0999999999999996], 
                      SameQ[ $VersionNumber, 4.0]], 
                    SelectionMove[ nn, After, EvaluationCell], 
                    SelectionMove[ nn, After, Cell]], 
                  NotebookWrite[ nn, 
                    
                    txt[ {"Se convierte en uno el elemento que ocupa la \
posici\[OAcute]n  (", Fii, "  ,  ", kee, ")  :"}, Background -> 
                      RGBColor[ .99610900000000002, .87110699999999996, \
.87110699999999996]]], 
                  NotebookWrite[ nn, 
                    frmt[ xpr1, ii]], 
                  NotebookFind[ nn, 
                    ToString[ ii], All, CellTags], 
                  SelectionMove[ nn, All, CellContents]}]]],
          ButtonEvaluator->"Local",
          Active->True,
          Background->RGBColor[0, 1, 1]], 
        ButtonBox["FER",
          ButtonFunction:>Module[ {nn, sel, preg, xpr, xpr1}, 
              CompoundExpression[ {
                Set[ nn, 
                  InputNotebook[]], 
                CompoundExpression[ 
                  SelectionMove[ nn, All, CellContents], 
                  Set[ sel, 
                    NotebookSelection[ nn]]], 
                CompoundExpression[ 
                  SetOptions[ 
                  sel, FormatType -> TraditionalForm, Background -> RGBColor[ 
                    1, 1, 0], FontSize -> 16, FontFamily -> "Courier"], 
                  SelectionMove[ nn, All, CellContents], 
                  Set[ xpr, 
                    ToExpression[ 
                      NotebookRead[ nn]]], 
                  Set[ xpr1, 
                    If[ 
                      MatrixQ[ xpr], 
                      etiq[ 
                        RowReduce[ xpr]], {}]], Null]}, 
                If[ 
                  Not[ 
                    MatrixQ[ xpr]], Null, {
                  If[ 
                    Or[ 
                      SameQ[ $VersionNumber, 4.0999999999999996], 
                      SameQ[ $VersionNumber, 4.0]], 
                    SelectionMove[ nn, After, EvaluationCell], 
                    SelectionMove[ nn, After, Cell]], 
                  NotebookWrite[ nn, 
                    Cell[ 
                      BoxData[ 
                        TagBox[ 
                          StyleBox[ 
                            
                            RowBox[ {"La", "Forma", "Escalonada", "Reducida", 
                              
                              RowBox[ {"(", "FER", ")"}], "de", "la", 
                              "matriz", 
                              RowBox[ {"es", ":"}]}], FontFamily -> "Courier",
                             FontSize -> 16, FontWeight -> "Bold", FontColor -> 
                            RGBColor[ 1, 1, 0]], 
                          StyleForm[ #, FontSize -> 16, FontFamily -> Courier,
                             FontWeight -> Bold, FontColor -> RGBColor[ 
                            1, 1, 0]]&]], "Text", Background -> GrayLevel[ 
                      0]]], 
                  NotebookWrite[ nn, 
                    ToBoxes[ 
                      StyleForm[ 
                      xpr1, FontFamily -> "Courier", FontSize -> 16, 
                        Background -> RGBColor[ 1, 1, 0]]]], 
                  SelectionMove[ nn, All, CellContents]}]]],
          ButtonEvaluator->"Local",
          Active->True,
          Background->RGBColor[0, 0.996109, 0.996109]], 
        ButtonBox["mat",
          ButtonFunction:>Module[ {nn, sel, preg, xpr, xpr1}, 
              CompoundExpression[ {
                Set[ nn, 
                  InputNotebook[]], 
                CompoundExpression[ 
                  SelectionMove[ nn, All, CellContents], 
                  Set[ sel, 
                    NotebookSelection[ nn]]], 
                CompoundExpression[ 
                  SetOptions[ 
                  sel, FormatType -> TraditionalForm, Background -> RGBColor[ 
                    1, 1, 0], FontSize -> 16, FontFamily -> "Courier"], 
                  SelectionMove[ nn, All, CellContents], 
                  Set[ xpr, 
                    ToExpression[ 
                      NotebookRead[ nn]]], 
                  Set[ xpr1, 
                    If[ 
                      MatrixQ[ xpr], 
                      etiq[ xpr], Null]], Null]}, 
                If[ 
                  Not[ 
                    MatrixQ[ xpr]], Null, {
                  If[ 
                    Or[ 
                      SameQ[ $VersionNumber, 4.0999999999999996], 
                      SameQ[ $VersionNumber, 4.0]], 
                    SelectionMove[ nn, After, EvaluationCell], 
                    SelectionMove[ nn, After, Cell]], 
                  NotebookWrite[ nn, 
                    Cell[ 
                      BoxData[ 
                        TagBox[ 
                          StyleBox[ 
                            
                            RowBox[ {"Se", "convierte", "la", "matriz", "a", 
                              "la", "forma", 
                              RowBox[ {"tradicional", ":"}]}], FontFamily -> 
                            "Courier", FontSize -> 16, FontWeight -> "Bold", 
                            FontColor -> RGBColor[ 1, 1, 0]], 
                          StyleForm[ #, FontSize -> 16, FontFamily -> Courier,
                             FontWeight -> Bold, FontColor -> RGBColor[ 
                            1, 1, 0]]&]], "Text", Background -> GrayLevel[ 
                      0]]], 
                  NotebookWrite[ nn, 
                    ToBoxes[ 
                      StyleForm[ 
                      xpr1, FontFamily -> "Courier", FontSize -> 16, 
                        Background -> RGBColor[ 1, 1, 0]]]], 
                  SelectionMove[ nn, All, CellContents]}]]],
          ButtonEvaluator->"Local",
          Active->True,
          Background->RGBColor[0, 0.996109, 0.996109]], 
        ButtonBox["matamp",
          ButtonFunction:>Module[ {nn, sel, preg, xpr, xpr1}, 
              CompoundExpression[ {
                Set[ nn, 
                  InputNotebook[]], 
                CompoundExpression[ 
                  SelectionMove[ nn, All, CellContents], 
                  Set[ sel, 
                    NotebookSelection[ nn]]], 
                CompoundExpression[ 
                  SetOptions[ 
                  sel, FormatType -> TraditionalForm, Background -> RGBColor[ 
                    1, 1, 0], FontSize -> 16, FontFamily -> "Courier"], 
                  SelectionMove[ nn, All, CellContents], 
                  Set[ xpr, 
                    ToExpression[ 
                      NotebookRead[ nn]]], 
                  Set[ xpr1, 
                    If[ 
                      MatrixQ[ xpr], 
                      ampl[ xpr], Null]], Null]}, 
                If[ 
                  Not[ 
                    MatrixQ[ xpr]], Null, {
                  If[ 
                    Or[ 
                      SameQ[ $VersionNumber, 4.0999999999999996], 
                      SameQ[ $VersionNumber, 4.0]], 
                    SelectionMove[ nn, After, EvaluationCell], 
                    SelectionMove[ nn, After, Cell]], 
                  NotebookWrite[ nn, 
                    Cell[ 
                      BoxData[ 
                        TagBox[ 
                          StyleBox[ 
                            RowBox[ {
                              RowBox[ {"La", "matriz", "ampliada"}], ",", 
                              
                              RowBox[ {"obtenida", "al", "agregar", "a", "la",
                                 "derecha", "la", "matriz", 
                                "id\[EAcute]ntica"}], ",", 
                              RowBox[ {"es", ":"}]}], FontFamily -> "Courier",
                             FontSize -> 16, FontWeight -> "Bold", FontColor -> 
                            RGBColor[ 1, 1, 0]], 
                          StyleForm[ #, FontSize -> 16, FontFamily -> Courier,
                             FontWeight -> Bold, FontColor -> RGBColor[ 
                            1, 1, 0]]&]], "Text", Background -> GrayLevel[ 
                      0]]], 
                  NotebookWrite[ nn, 
                    ToBoxes[ 
                      StyleForm[ 
                      xpr1, FontFamily -> "Courier", FontSize -> 16, 
                        Background -> RGBColor[ 1, 1, 0]]]], 
                  SelectionMove[ nn, All, CellContents]}]]],
          ButtonEvaluator->"Local",
          Active->True,
          Background->RGBColor[1, 0, 0]], 
        ButtonBox["ecua",
          
          ButtonFunction:>
            Module[ {ii, nn, xpr, dms, chstr, nucol, sel, preg, VL, VS, xpr1},
               
              CompoundExpression[ {
                CompoundExpression[ 
                  Set[ ii, 
                    Random[ Integer, {1, 
                      Power[ 2, 100]}]], 
                  Set[ nn, 
                    InputNotebook[]]], 
                CompoundExpression[ 
                  SelectionMove[ nn, All, CellContents], 
                  Set[ xpr, 
                    ToExpression[ 
                      NotebookRead[ nn]]], 
                  Set[ dms, 
                    If[ 
                      MatrixQ[ xpr], 
                      Dimensions[ xpr], {}]]], 
                Set[ chstr, 
                  If[ 
                    SameQ[ dms, {}], {}, 
                    Part[ dms, 1]]], 
                Set[ nucol, 
                  If[ 
                    SameQ[ dms, {}], {}, 
                    Part[ dms, 2]]], 
                Set[ sel, 
                  NotebookSelection[ nn]], 
                CompoundExpression[ 
                  SetOptions[ 
                  sel, FormatType -> TraditionalForm, Background -> RGBColor[ 
                    1, 1, 0], FontSize -> 16, FontFamily -> "Courier"], 
                  Set[ preg, 
                    spros[ "Indique las variables libres y las ligadas : ", 
                      BoxData[ 
                        GridBox[ {{
                          InterpretationBox[ "", 
                            SequenceForm[], Editable -> False], 
                          InterpretationBox[ "", 
                            SequenceForm[], Editable -> False], 
                          InterpretationBox[ "", 
                            SequenceForm[], Editable -> False]}, {
                          StyleBox[ 
                            InterpretationBox[ "", 
                              SequenceForm[], Editable -> False], FontSize -> 
                            1], 
                          GridBox[ {{
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1]}, {
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            InterpretationBox[ 
                              TagBox[ 
                                StyleBox[ 
                                  TagBox[ 
                                    StyleBox[ 
                                    "\"Variables Ligadas\[Rule]\"", 
                                      FontFamily -> "Times"], 
                                    StyleForm[ #, FontFamily -> Times]&], 
                                  FontFamily -> "Times", FontSlant -> 
                                  "Italic"], 
                                StyleForm[ #, FontFamily -> Times, FontSlant -> 
                                  Italic]&], 
                              SequenceForm[ 
                                StyleForm[ 
                                  StyleForm[ 
                                  "Variables Ligadas\[Rule]", FontFamily -> 
                                    Times], FontFamily -> Times, FontSlant -> 
                                  Italic]], Editable -> False], 
                            RowBox[ {"{", "\[SelectionPlaceholder]", "}"}], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1]}, {
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            InterpretationBox[ 
                              TagBox[ 
                                StyleBox[ 
                                  TagBox[ 
                                    StyleBox[ 
                                    "\"Variables Libres\[Rule]\"", FontFamily -> 
                                      "Times"], 
                                    StyleForm[ #, FontFamily -> Times]&], 
                                  FontFamily -> "Times", FontSlant -> 
                                  "Italic"], 
                                StyleForm[ #, FontFamily -> Times, FontSlant -> 
                                  Italic]&], 
                              SequenceForm[ 
                                StyleForm[ 
                                  StyleForm[ 
                                  "Variables Libres\[Rule]", FontFamily -> 
                                    Times], FontFamily -> Times, FontSlant -> 
                                  Italic]], Editable -> False], 
                            RowBox[ {"{", "\[Placeholder]", "}"}], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1]}, {
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1], 
                            StyleBox[ 
                              InterpretationBox[ "", 
                                SequenceForm[], Editable -> False], FontSize -> 
                              1]}}], 
                          StyleBox[ 
                            InterpretationBox[ "", 
                              SequenceForm[], Editable -> False], FontSize -> 
                            1]}, {
                          InterpretationBox[ "", 
                            SequenceForm[], Editable -> False], 
                          InterpretationBox[ "", 
                            SequenceForm[], Editable -> False], 
                          InterpretationBox[ "", 
                            SequenceForm[], Editable -> False]}}]], {400, 
                      200}]], 
                  NotebookLocate[ "LaEntrada"], 
                  SelectionMove[ nn, All, CellContents], 
                  Set[ VL, 
                    Part[ preg, 2, 2, 2, 3]]], 
                CompoundExpression[ 
                  Set[ VS, 
                    Part[ preg, 2, 2, 3, 3]], 
                  Set[ xpr1, 
                    If[ 
                      Or[ 
                        Not[ 
                          SameQ[ 
                            Head[ VL], List]], 
                        Not[ 
                          SameQ[ 
                            Head[ VS], List]], 
                        Not[ 
                          MatrixQ[ xpr]], 
                        Not[ 
                          SameQ[ 
                            Plus[ 
                              Length[ 
                                Union[ VL]], 
                              Length[ 
                                Union[ 
                                  Complement[ VS, {\[Placeholder]}]]]], 
                            Plus[ nucol, -1]]], 
                        MemberQ[ VL, \[SelectionPlaceholder]], 
                        MemberQ[ VL, \[Placeholder]]], {}, 
                      ecua[ xpr, VL, 
                        If[ 
                          SameQ[ VS, {\[Placeholder]}], {}, VS]]]]]}, 
                If[ 
                  Or[ 
                    Not[ 
                      SameQ[ 
                        Head[ VL], List]], 
                    Not[ 
                      SameQ[ 
                        Head[ VS], List]], 
                    Not[ 
                      MatrixQ[ xpr]], 
                    Not[ 
                      SameQ[ 
                        Plus[ 
                          Length[ 
                            Union[ VL]], 
                          Length[ 
                            Union[ 
                              Complement[ VS, {\[Placeholder]}]]]], 
                        Plus[ nucol, -1]]], 
                    MemberQ[ VL, \[SelectionPlaceholder]], 
                    MemberQ[ VL, \[Placeholder]]], Null, {
                  If[ 
                    Or[ 
                      SameQ[ $VersionNumber, 4.0999999999999996], 
                      SameQ[ $VersionNumber, 4.0]], 
                    SelectionMove[ nn, After, EvaluationCell], 
                    SelectionMove[ nn, After, Cell]], 
                  CompoundExpression[ 
                    NotebookWrite[ nn, 
                      
                      txt[ {"Sistema de ecuaciones :"}, Background -> 
                        RGBColor[ .99610900000000002, .87110699999999996, \
.87110699999999996]]], 
                    NotebookWrite[ nn, 
                      frmt[ 
                        Part[ xpr1, 1], ii]]], 
                  NotebookWrite[ nn, 
                    
                    txt[ {"Se despejan las variables ligadas ", VL, 
                      " en t\[EAcute]rminos de las variables libres  ", VS, 
                      " :"}, Background -> 
                      RGBColor[ .99610900000000002, .87110699999999996, \
.87110699999999996]]], 
                  NotebookWrite[ nn, 
                    frmt[ 
                      Part[ xpr1, 2], ii]], 
                  NotebookFind[ nn, 
                    ToString[ ii], All, CellTags], 
                  SelectionMove[ nn, All, Cell]}]]],
          ButtonEvaluator->"Local",
          Active->True,
          Background->RGBColor[1, 0, 0]], 
        ButtonBox["\"\<\[Times]mens\>\"",
          ButtonFunction:>Module[ {nn}, 
              CompoundExpression[ {
                Set[ nn, 
                  InputNotebook[]], 
                NotebookFind[ nn, "Message", All, CellStyle]}, 
                NotebookDelete[ nn]]],
          ButtonEvaluator->Automatic,
          Active->True,
          Background->RGBColor[0.753918, 0.753918, 0]], 
        StyleBox[
          ButtonBox["\"\<\[Times]\>\"",
            ButtonFunction:>NotebookClose[ 
                ButtonNotebook[]],
            ButtonEvaluator->Automatic,
            Active->True,
            Background->RGBColor[0, 0.996109, 0]],
          FontSize->12]}
      }]\)
