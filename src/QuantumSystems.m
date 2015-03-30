(* ::Package:: *)

(* ::Title:: *)
(*QuantumUtils for Mathematica*)
(*Quantum Systems Package*)


(* ::Subsection::Closed:: *)
(*Copyright and License Information*)


(* ::Text:: *)
(*This package is part of QuantumUtils for Mathematica.*)
(**)
(*Copyright (c) 2015 and later, Christopher J. Wood, Christopher E. Granade, Ian N. Hincks*)
(**)
(*Redistribution and use in source and binary forms, with or withoutmodification, are permitted provided that the following conditions are met:*)
(*1. Redistributions of source code must retain the above copyright notice, this  list of conditions and the following disclaimer.*)
(*2. Redistributions in binary form must reproduce the above copyright notice,  this list of conditions and the following disclaimer in the documentation  and/or other materials provided with the distribution.*)
(*3. Neither the name of quantum-utils-mathematica nor the names of its  contributors may be used to endorse or promote products derived from  this software without specific prior written permission.*)
(**)
(*THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THEIMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE AREDISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLEFOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIALDAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS ORSERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVERCAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USEOF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.*)


(* ::Subsection::Closed:: *)
(*Preamble*)


BeginPackage["QuantumSystems`",{"Predicates`","Tensor`"}];


Needs["UnitTesting`"];
Needs["QUDevTools`"]


$Usages = LoadUsages[FileNameJoin[{$QUDocumentationPath, "api-doc", "QuantumSystems.nb"}]];


(* ::Section::Closed:: *)
(*Usage Declaration*)


(* ::Subsection::Closed:: *)
(*States, Operators and Gates*)


Unprotect[Spin,Cavity,QState,CGate,KetForm,VecForm,Ket,Bra,KetBra];


AssignUsage[Spin,$Usages];
AssignUsage[Cavity,$Usages];
AssignUsage[QState,$Usages];
AssignUsage[KetForm,$Usages];
AssignUsage[VecForm,$Usages];
AssignUsage[CGate,$Usages];


(* ::Subsection::Closed:: *)
(*Symbolic Evaluation*)


Unprotect[Op,QPower,QExpand,QSimplifyComAlgebra,QSimplifyAlgebra,QSimplifyIdentity,QSimplifyPower,QSimplifyNormalOrder,QSimplify,ClearQSimplifyCache];


AssignUsage[QExpand,$Usages];
AssignUsage[QPower,$Usages];
AssignUsage[QSimplifyAlgebra,$Usages];
AssignUsage[QSimplifyComAlgebra,$Usages];
AssignUsage[QSimplifyIdentity,$Usages];
AssignUsage[QSimplifyPower,$Usages];
AssignUsage[QSimplifyNormalOrder,$Usages];
AssignUsage[QSimplify,$Usages];
AssignUsage[ClearQSimplifyCache,$Usages];


(* ::Subsection::Closed:: *)
(*State Measures*)


Unprotect[EntropyH,EntropyS,RelativeEntropyS,MutualInformationS];
Unprotect[Purity,PNorm,Fidelity,EntangledQ,Concurrence,EntanglementF];


AssignUsage[EntropyH,$Usages];
AssignUsage[EntropyS,$Usages];
AssignUsage[RelativeEntropyS,$Usages];
AssignUsage[MutualInformationS,$Usages];


AssignUsage[Purity,$Usages];
AssignUsage[PNorm,$Usages];
AssignUsage[Fidelity,$Usages];


AssignUsage[EntangledQ,$Usages];
AssignUsage[Concurrence,$Usages];
AssignUsage[EntanglementF,$Usages];


(* ::Subsection::Closed:: *)
(*Random Matrices*)


Unprotect[RandomUnitary,RandomDensity,RandomHermitian];


AssignUsage[RandomUnitary,$Usages];
AssignUsage[RandomDensity,$Usages];
AssignUsage[RandomHermitian,$Usages];


(* ::Subsection::Closed:: *)
(*Error Messages*)


(* ::Subsubsection::Closed:: *)
(*States and Operators*)


Spin::spin = "Total spin value must be an non-negative integer or half-integer; `1` received.";
Cavity::dim = "Cavity dimension must be a positive integer.";


VecForm::fail = "Unable to parse input.";
KetForm::input = "Input must be a rank 1 or 2 array.";


(* ::Subsubsection::Closed:: *)
(*Symbolic Evaluation*)


QSimplifyComAlgebra::alg = "Algebra matrix must be upper triangular, lower triangular, or skew-symmetric.";
QSimplifyComAlgebra::ragls = "Invalid algebra input list.";
QSimplifyComAlgebra::len = "Commutator algebra matrix does not match number of operators.";


(* ::Subsubsection::Closed:: *)
(*Quantum Gates*)


CGate::dims = "Input dimensions must be an integer or list of integers";
CGate::targctrl = "Targets and Control subsystem lists must not intersect.";
CGate::gates = "Gate must be matrix or a list of matrices of same length as list of targets.";
CGate::ctrlval = "Control values must be integer or list of integers same length as controls list.";


(* ::Subsubsection::Closed:: *)
(*Measures*)


Fidelity::input = "Input must be satisfy either SquareMatrixQ or GeneralVectorQ.";


EntropyS::sqmat = "Input must be a square matrix.";
MutualInformationS::sqmat = "Input must be a square matrix.";
MutualInformationS::dims = "Computed subsystem dimensions not integers manually specify dimensions.";
RelativeEntropyS::sqmat = "Input must be a square matrix.";


Purity::sqmat = "Input must be a square matrix.";


EntangledQ::input = "Input must be satisfy either SquareMatrixQ or GeneralVectorQ.";


Concurrence::input = "Input must be satisfy either SquareMatrixQ or GeneralVectorQ.";
Concurrence::dim = "Concurrence currently only works for 2-qubit states.";
EntanglementF::input = "Input must be satisfy either SquareMatrixQ or GeneralVectorQ.";
EntanglementF::dim = "Concurrence currently only works for 2-qubit states.";


(* ::Section::Closed:: *)
(*Implementation*)


Begin["`Private`"];


(* ::Subsection::Closed:: *)
(*States and Operators*)


(* ::Subsubsection::Closed:: *)
(*Spin Operators*)


SpinQ[S_]:=IntegerQ[2*S]&&NonNegative[2*S]


Clear[SpinZ,SpinP]

SpinZ[S_]:=SpinZ[S]=DiagonalMatrix[SparseArray[Range[S,-S,-1]]];

SpinP[S_]:=SpinP[S]=SparseArray[{#,#+1}->Sqrt[(1+2 S-#) #]&/@Range[2S],{2S+1,2S+1}];

SpinM[S_]:=Transpose[SpinP[S]];

SpinX[S_]:=(SpinP[S]+SpinM[S])/2

SpinY[S_]:=(SpinM[S]-SpinP[S])*I/2

SpinI[S_]:=IdentityMatrix[2S+1,SparseArray];


Clear[SpinTPRules]
SpinTPRules[S_]:= SpinTPRules[S] = 
	MapThread[Rule,
			{{"I","X","Y","Z","P","M"},
			If[S==="Symbolic",
				{Spin["I"],Spin["X"],Spin["Y"],Spin["Z"],Spin["P"],Spin["M"]},
				{SpinI[S],SpinX[S],SpinY[S],SpinZ[S],SpinP[S],SpinM[S]}
			]}
	]


SetAttributes[Spin,HoldAllComplete]

Spin[expr_][S_,SparseArray]:=With[
	{spin=Rationalize[S]},
	If[SpinQ[spin],
		TP[expr,Replace->SpinTPRules[S]],
		Message[Spin::spin,spin]
	]]

Spin[expr_][S_]:=Normal[Spin[expr][S,SparseArray]]
Spin[expr_][S_,Identity]:=Spin[expr][S]
Spin[expr_]["Symbolic"]:=TP[expr,Replace->SpinTPRules["Symbolic"]]


(* ::Text:: *)
(*Short hand for single spin operators*)


Spin[0]:=Spin["I"]
Spin[1]:=Spin["X"]
Spin[2]:=Spin["Y"]
Spin[3]:=Spin["Z"]


(* ::Text:: *)
(*Display Formatting*)


SpinFormatting[Spin[op_]]:=
	With[{str=ToString@Unevaluated[op]},
		Which[
			str=="P", Subscript[Style["S",Italic],"+"],
			str=="M", Subscript[Style["S",Italic],"-"],
			str=="X", Subscript[Style["S",Italic],"x"],
			str=="Y", Subscript[Style["S",Italic],"y"],
			str=="Z", Subscript[Style["S",Italic],"z"],
			str=="I", Subscript["\[DoubleStruckOne]","s"],
			True,"Spin"[str]
	]]


Format[Spin[op_],TraditionalForm]:=SpinFormatting[Spin[op]]


(* ::Subsubsection::Closed:: *)
(*Cavity Operators*)


Clear[CavityA,CavityN]
CavityI[n_Integer]:= IdentityMatrix[n,SparseArray]
CavityA[n_Integer]:= CavityA[n] = DiagonalMatrix[SparseArray@Sqrt[Range[n-1]],1]
CavityC[n_Integer]:= Transpose[CavityA[n]]
CavityN[n_Integer]:= CavityN[n] = DiagonalMatrix[SparseArray@Range[0,n-1]]


CavityTPRules[n_]:= CavityTPRules[n] =	 
	MapThread[Rule,
			{{"I","a","c","n","N"},
			If[n==="Symbolic",
				{Cavity["I"],Cavity["a"],Cavity["c"],Cavity["n"],Cavity["n"]},
				{CavityI[n],CavityA[n],CavityC[n],CavityN[n],CavityN[n]}
			]}
	]


SetAttributes[Cavity,HoldAllComplete]
Cavity[expr_][n_Integer,SparseArray]:=
	If[Positive[n],
		TP[expr,Replace->CavityTPRules[n]],
		Message[Cavity::int]
	]

Cavity[expr_][n_Integer]:=Normal[Cavity[expr][n,SparseArray]]
Cavity[expr_][n_Integer,Identity]:=Cavity[expr][n]
Cavity[expr_]["Symbolic"]:=TP[expr,Replace->CavityTPRules["Symbolic"]]


(* ::Text:: *)
(*Display Formatting*)


CavityFormatting[Cavity[op_]]:=
	With[{str=ToString@Unevaluated[op]},
		Which[
			str=="a", Style["a",Italic],
			str=="c", Superscript[Style["a",Italic],"\[Dagger]"],
			str=="n"||str=="N", Style["N",Italic],
			str=="I", Subscript["\[DoubleStruckOne]","c"],
			True, "Cavity"[str]
	]]


Format[Cavity[op_],TraditionalForm]:=CavityFormatting[Cavity[op]]


(* ::Subsubsection::Closed:: *)
(*Quantum States*)


SetAttributes[QState,HoldAllComplete];


Options[QState]:={VectorQ->False, ColumnVectorQ->False};


QState[expr__,opts:OptionsPattern[]]:=
	Which[
		AllMatchQ[{_,_,_},{expr}],
			CircleTimes@@Map[QStateBloch,{expr}],
		TrueQ[OptionValue[VectorQ]],
			TP[Unevaluated[expr],Replace->$QStateVecRules],
		TrueQ[OptionValue[ColumnVectorQ]],
			Partition[TP[Unevaluated[expr],Replace->$QStateVecRules],1],
		True,TP[Unevaluated[expr],Replace->$QStateMatRules]
	]


QStateBloch[{x_,y_,z_}]:={{1+z,x-I*y},{x+I*y,1-z}}/2;


(* ::Text:: *)
(*Rules for state vectors*)


$QStateVecZp={1,0};
$QStateVecZm={0,1};
$QStateVecXp={1,1}/Sqrt[2];
$QStateVecXm={1,-1}/Sqrt[2];
$QStateVecYp={1,I}/Sqrt[2];
$QStateVecYm={1,-I}/Sqrt[2];
$QStateVecBell1={1,0,0,1}/Sqrt[2];
$QStateVecBell2={0,1,1,0}/Sqrt[2];
$QStateVecBell3={0,1,-1,0}/Sqrt[2];
$QStateVecBell4={1,0,0,-1}/Sqrt[2];


$QStateVecRules={
"Zp"->$QStateVecZp, "H"->$QStateVecZp,
"Zm"->$QStateVecZm, "V"->$QStateVecZm,
"Xp"->$QStateVecXp, "D"->$QStateVecXp,
"Xm"->$QStateVecXm, "A"->$QStateVecXm,
"Yp"->$QStateVecYp, "R"->$QStateVecYp,
"Ym"->$QStateVecYm, "L"->$QStateVecYm,
"Bell1"->$QStateVecBell1, "B1"->$QStateVecBell1,
"Bell2"->$QStateVecBell2, "B2"->$QStateVecBell2,
"Bell3"->$QStateVecBell3, "B3"->$QStateVecBell3,
"Bell4"->$QStateVecBell4, "B4"->$QStateVecBell4};


(* ::Text:: *)
(*Rules for density matrices*)


$QStateMatZp=Projector[$QStateVecZp];
$QStateMatZm=Projector[$QStateVecZm];
$QStateMatXp=Projector[$QStateVecXp];
$QStateMatXm=Projector[$QStateVecXm];
$QStateMatYp=Projector[$QStateVecYp];
$QStateMatYm=Projector[$QStateVecYm];
$QStateMatBell1=Projector[$QStateVecBell1];
$QStateMatBell2=Projector[$QStateVecBell2];
$QStateMatBell3=Projector[$QStateVecBell3];
$QStateMatBell4=Projector[$QStateVecBell4];
$QStateMixed={{1/2,0},{0,1/2}};


$QStateMatRules={
"I"->$QStateMixed,
"Zp"->$QStateMatZp, "H"->$QStateMatZp,
"Zm"->$QStateMatZm, "V"->$QStateMatZm,
"Xp"->$QStateMatXp, "D"->$QStateMatXp,
"Xm"->$QStateMatXm, "A"->$QStateMatXm,
"Yp"->$QStateMatYp, "R"->$QStateMatYp,
"Ym"->$QStateMatYm, "L"->$QStateMatYm,
"Bell1"->$QStateMatBell1, "B1"->$QStateMatBell1,
"Bell2"->$QStateMatBell2, "B2"->$QStateMatBell2,
"Bell3"->$QStateMatBell3, "B3"->$QStateMatBell3,
"Bell4"->$QStateMatBell4, "B4"->$QStateMatBell4};


(* ::Subsubsection::Closed:: *)
(*Bra-Ket Notation*)


(* ::Text:: *)
(*Converting arrays to Bra-Ket Notation.*)


KetForm[op_,subdims___]:=
	With[{dims=Dimensions[op]},
	Which[
		GeneralVectorQ[op],
			KetFormVector[Ket,op,subdims],
		RowVectorQ[op],
			KetFormVector[Bra,op,subdims],
		MatrixQ[op],
			KetFormMatrix[op,subdims],
		True,
			Message[KetForm::input]
	]]


(* ::Text:: *)
(*Display Formatting*)


Format[KetBra[{a__},{b__}]]:=
	DisplayForm[
	RowBox[{"\[LeftBracketingBar]",
		Sequence@@Map[AdjustmentBox[#,BoxMargins->{{0,0},{0.5,0.5}}]&,{a}],
		AdjustmentBox["\[RightAngleBracket]",BoxMargins->{{0,-0.5},{0,0}}],
		"\[LeftAngleBracket]",
		Sequence@@Map[AdjustmentBox[#,BoxMargins->{{0,0},{0.5,0.5}}]&,{b}],
		"\[RightBracketingBar]"}]]


(* ::Text:: *)
(*Conversion Utility functions*)


KetBasis[ds_List]:=Tuples@Map[Table[Subscript[i, #],{i,0,#-1}]&,ds]


KetAutoDim[d_]:=
	Which[
		IntegerQ[Log[2,d]],
			ConstantArray[2,Log[2,d]],
		IntegerQ[Log[3,d]],
			ConstantArray[3,Log[3,d]],
		True,d]


(* ::Text:: *)
(*Converting vectors to KetForm*)


KetFormVector[ket_,vec_,ds_List]:=Flatten[vec].(ket@@@KetBasis[ds]);
KetFormVector[ket_,vec_,d_Integer]:=
	With[{ds=ConstantArray[d,Log[d,Length[Flatten[vec]]]]},
		KetFormVector[ket,vec,ds]
	]
KetFormVector[ket_,vec_]:=
	With[{d=KetAutoDim[Length[Flatten[vec]]]},
		KetFormVector[ket,vec,d]
	]


(* ::Text:: *)
(*Converting matrices to KetForm*)


KetFormMatrix[mat_,dsL_List,dsR_List]:=
Flatten[mat].(KetBra@@@Tuples[{KetBasis[dsL],KetBasis[dsR]}]);

KetFormMatrix[mat_,ds_List]:=KetFormMatrix[mat,ds,ds];

KetFormMatrix[mat_,d_Integer]:=
	With[{n=Log[d,Length[mat]]},
		If[IntegerQ[Log[d,Length[mat]]],
			KetFormMatrix[mat,ConstantArray[d,n]],
			KetFormMatrix[mat,{First[Dimensions[mat]]},{Last[Dimensions[mat]]}]]
	];

KetFormMatrix[mat_]:=
	With[{dims=KetAutoDim/@Dimensions[mat]},
		KetFormMatrix[mat,Sequence@@dims]
	]


(* ::Subsubsection::Closed:: *)
(*Vec Form*)


(* ::Text:: *)
(*Converting Spin, Cavity and Bra-Ket notation to arrays.*)


KetDimensions[Subscript[num_,dim_]]:={dim,1+num};
KetDimensions[num_]:={2,1+num};


Options[VecForm]:={Spin->1/2,Cavity->2,SparseArray->False};


VecForm[obj_,opts:OptionsPattern[VecForm]]:=
	With[{f=If[OptionValue[SparseArray],SparseArray,Identity]},
	Which[
		(* Linear Algebra *)
		NumericQ[obj],obj,
		ListQ[obj],f@obj,
		StringQ[obj],obj,
		MatchQ[obj,Plus[_,__]],
			VecForm[First[obj],opts]+VecForm[Rest[obj],opts],
		MatchQ[obj,Times[_?CoefficientQ,__]],
			obj/.{Times[a_?CoefficientQ,b__]:>Times[a,VecForm[Times[b],opts]]},
		MatchQ[obj,CircleTimes[_,__]],
			CircleTimes@@Map[VecForm[#,opts]&,List@@obj],
		MatchQ[obj,Dot[_,__]],
			Dot@@Map[VecForm[#,opts]&,List@@obj],
		MatchQ[obj,QPower[_,_]],
			MatrixPower[VecForm[First@obj,opts],VecForm[Last@obj,opts]],
		(* Bra-Ket *)
		MatchQ[obj,Ket[{__}]],
			Partition[CircleTimes@@Apply[Composition[f,UnitVector],Map[KetDimensions,First@obj],{1}],1],
		MatchQ[obj,Ket[__]],
			Partition[CircleTimes@@Apply[Composition[f,UnitVector],Map[KetDimensions,List@@obj],{1}],1],
		MatchQ[obj,Bra[{__}]],
			ConjugateTranspose[VecForm[Ket@@First[obj],opts]],
		MatchQ[obj,Bra[__]],
			ConjugateTranspose[VecForm[Ket@@obj,opts]],
		MatchQ[obj,KetBra[{__},{__}]],
			CircleTimes[VecForm[Ket@@First[obj]],VecForm[Bra@@Last[obj],opts]],
		(* Spin-Cavity *)
		MatchQ[obj,Spin[__]],
			obj[OptionValue[Spin],f],
		MatchQ[obj,Cavity[__]],
			obj[OptionValue[Cavity],f],
		(* Symbolic *)
		CoefficientQ[obj],obj,
		(* Failure *)
		True,
			Message[VecForm::fail]
]]

VecForm[a__,opts:OptionsPattern[VecForm]]:=Map[VecForm[#,opts]&,{a}]


(* ::Subsection::Closed:: *)
(*Symbolic Evaluation*)


(* ::Subsubsection::Closed:: *)
(*Symbolic Operators*)


(* ::Text:: *)
(*Use container Op for symbolic operators*)


(* ::Text:: *)
(*QPower for powers of symbolic operators*)


QPower[a_]:=a
QPower[arg_,1]:=arg
QPower[arg_?CoefficientQ,n_]:=Power[arg,n]
QPower[arg_?MatrixQ,n_]:=MatrixPower[arg,n]
QPower[QPower[arg_,m_],n_]:=QPower[arg,m+n]
QPower[Times[x_?CoefficientQ,xs__],n_]:=QPower[x,n]*QPower[Times[xs],n]
QPower[Times[xs__,x_?CoefficientQ],n_]:=QPower[x,n]*QPower[Times[xs],n]


(* ::Text:: *)
(*Hide QPower from displayed equations*)


Format[QPower[arg_,n_]]:=arg^n;


(* ::Text:: *)
(*Parsing symbolic Spin-Cavity expressions*)


QExpand[expr_]:=expr//.{
	Spin[arg_]:> Spin[arg]["Symbolic"],
	Cavity[arg_]:> Cavity[arg]["Symbolic"]
}


(* ::Subsubsection::Closed:: *)
(*QSimplify*)


Options[QSimplify]:={
	Spin->True,
	Cavity->True,
	"SpinAlgebra"->Automatic,
	"CavityAlgebra"->Automatic,
	"SpinHalf"->False,
	"OrderSpin"->False,
	"OrderCavity"->True,
	TimeConstraint->1};


QSimplify[expr_,rules_?ListQ,opts:OptionsPattern[QSimplify]]:= QSimplifyCached[expr,rules,opts]
QSimplify[expr_,opts:OptionsPattern[QSimplify]]:= QSimplify[expr,{},opts]


QSimplify[Com[a_,b_,n_?Positive],rules_?ListQ,opts:OptionsPattern[]]:=QSimplify[Com[a,QSimplify[Com[a,b],opts],n-1],rules,opts]
QSimplify[ACom[a_,b_,n_?Positive],rules_?ListQ,opts:OptionsPattern[]]:=QSimplify[ACom[a,QSimplify[ACom[a,b],opts],n-1],rules,opts]


(* ::Text:: *)
(*Memoized function for QSimplify*)


Clear[QSimplifyCached]


ClearQSimplifyCache[]:=(
	DownValues[QSimplifyCached]=Part[DownValues[QSimplifyCached],{-1}];
	DownValues[QSimplifyRules]=Part[DownValues[QSimplifyRules],{-1}];)


QSimplifyCached[expr_,rules_,opts:OptionsPattern[QSimplify]]:=
	QSimplifyCached[expr,rules,opts]=
	With[{replaceRules=Join[rules,QSimplifyRules[opts]]},
	Simplify[
	ReplaceRepeated[
			Simplify[QExpand[expr],TimeConstraint->OptionValue[TimeConstraint]],
			replaceRules
		],
	TimeConstraint->OptionValue[TimeConstraint]]]


(* ::Text:: *)
(*Replacement rules for QSimplify*)


Clear[QSimplifyRules]


QSimplifyRules[opts:OptionsPattern[QSimplify]]:=
	QSimplifyRules[opts]=
		Join[
			QSimplifySpinRules[opts],
			QSimplifyCavityRules[opts],
			QSimplifyPower[Op],
			$QSimplifyLinearAlgebra
		]


QSimplifySpinRules[opts:OptionsPattern[QSimplify]]:=
	If[OptionValue[Spin],
		Join[
			If[OptionValue["SpinHalf"],$QSimplifySpinHalf,{}],
			Which[
				OptionValue["SpinAlgebra"]==="PM", $QSimplifySpinPM,
				OptionValue["SpinAlgebra"]==="XY", $QSimplifySpinXY,
				True,{}],
			$QSimplifySpin,
			If[OptionValue["OrderSpin"],$QSimplifySpinOrdering,{}]
		],{}]


QSimplifyCavityRules[opts:OptionsPattern[QSimplify]]:=
	If[OptionValue[Cavity],
		Join[
			If[OptionValue["OrderCavity"],$QSimplifyCavityOrdering,{}],
			Which[
				OptionValue["CavityAlgebra"]==="n", $QSimplifyCavityN,
				OptionValue["CavityAlgebra"]==="ac", $QSimplifyCavityAC,
				True,{}],
			$QSimplifyCavity,{}
		],{}]


(* ::Subsubsection::Closed:: *)
(*Algebra Constructors*)


(* ::Text:: *)
(*Combined Constructor*)


Options[QSimplifyAlgebra]:={Identity->Automatic,"NormalOrder"->False}


QSimplifyAlgebra[opLabel_,ops_?ListQ,algebra_,opts:OptionsPattern[QSimplifyAlgebra]]:=
	With[{
		id=OptionValue[Identity],
		order=OptionValue["NormalOrder"]},
	Join[
		QSimplifyPower[opLabel],
		Which[
			id===Automatic,QSimplifyIdentity[opLabel["I"]],
			id===None,{},
			True,QSimplifyIdentity[id]
		],
		QSimplifyComAlgebra[ops,algebra],
		Which[
			SameQ[order,False],{},
			MemberQ[{True,Automatic},order],QSimplifyNormalOrder[opLabel,ops],
			True,QSimplifyNormalOrder[opLabel,order]
		]
	]]


(* ::Text:: *)
(*Commutator constructors*)


QSimplifyComAlgebra[ops_List,algebra_]:=
	With[{mat=ComAlgebraMatrix[algebra]},
	If[Length[mat]===Length[ops],
		Select[
			Flatten[
				MapThread[
					RuleDelayed,
					{Outer[Com[#1,#2]&,ops,ops],
					ComAlgebraMatrix[algebra]},2]
			],
		Not[MatchQ[#,0:>_]]&],
		Message[QSimplifyComAlgebra::len]
	]]


ComAlgebraMatrix[algebra_]:=
	Which[
		And[ListQ[algebra],{1}===Dimensions[algebra]],
			ComAlgebraMatrixRagged[{algebra}],
		And[MatrixQ[algebra],{1,1}===Dimensions[algebra]],
			ComAlgebraMatrixRagged[algebra],
		MatrixQ[algebra],
			ComAlgebraMatrixSkew[algebra],
		ListQ[algebra],
			ComAlgebraMatrixRagged[algebra],
		True,
			ComAlgebraMatrixRagged[{{algebra}}]
	]


(* ::Text:: *)
(*Constructing algebra matrix for skew, upper or lower triangular matrices*)


ComAlgebraMatrixSkew[mat_?MatrixQ]:=
With[{utri=UpperTriangularize[mat,1],ltri=LowerTriangularize[mat,-1]},
Which[
	AllMatchQ[0,Flatten[utri]], ltri-Transpose[ltri],
	AllMatchQ[0,Flatten[ltri]], utri-Transpose[utri],
	AllMatchQ[0,Flatten[utri+Transpose[ltri]]], utri+ltri,
	True, Message[QSimplifyComAlgebra::alg]
]]


(* ::Text:: *)
(*Constructing algebra matrix for ragged lists*)


ComAlgebraMatrixRagged[raggedls_]:=
	With[{d=Length[First@raggedls]},
	If[Flatten[Dimensions/@raggedls]===Range[d,1,-1],
		ComAlgebraMatrixSkew[PadRight[PadLeft[raggedls,{d,d+1}],{d+1,d+1}]],
		Message[QSimplifyComAlgebra::ragls]]
	]


(* ::Text:: *)
(*Identity operator constructor*)


QSimplifyIdentity[id_]:=
	{Dot[id,op_]:> op,
	Dot[id,QPower[op_,m_]]:> QPower[op,m],
	Dot[op_,id]:> op,
	Dot[QPower[op_,m_],id]:> QPower[op,m],
	QPower[id,n_]:> id,
	Com[id,s_]:> 0,
	Com[s_,id]:> 0};


(* ::Text:: *)
(*Operator power constructor*)


QSimplifyPower[container_]:={
	Power[op_container,n_]:> QPower[op,n],
	MatrixPower[op_container,n_]:> QPower[op,n]};


(* ::Text:: *)
(*Normal Ordering constructors*)


NormalOrderRight[opls_List,op_]:=Join[
	Map[{
	op.#:>#.op+Com[op,#],
	op.QPower[#,m_]:> QPower[#,m].op+Com[op,QPower[#,m]],
	QPower[op,n_].#:> #.QPower[op,n]+Com[QPower[op,n],#],
	QPower[op,n_].QPower[#,m_]:> QPower[#,m].QPower[op,n]+Com[QPower[op,n],QPower[#,m]]
	}&,opls]];


NormalOrderRight[container_,op_]:={
	op.container[s_]:>container[s].op+Com[op,container[s]],
	op.QPower[container[s_],m_]:> QPower[container[s],m].op+Com[op,QPower[container[s],m]],
	QPower[op,n_].container[s_]:> container[s].QPower[op,n]+Com[QPower[op,n],container[s]],
	QPower[op,n_].QPower[container[s_],m_]:> QPower[container[s],m].QPower[op,n]+Com[QPower[op,n],QPower[container[s],m]]
	};


NormalOrderLeft[opls_List,op_]:=Join[
	Map[{
	#.op:> op.#+Com[#,op],
	#.QPower[op,n_]:> QPower[op,n].#+Com[#,QPower[op,n]],
	QPower[#,m_].op:> op.QPower[#,m]+Com[QPower[#,m],op],
	QPower[#,m_].QPower[op,n_]:> QPower[op,n].QPower[#,m]+Com[QPower[#,m],QPower[op,n]]
	}&,opls]];


NormalOrderLeft[container_,op_]:={
	container[s_].op:> op.container[s]+Com[container[s],op],
	container[s_].QPower[op,n_]:> QPower[op,n].container[s]+Com[container[s],QPower[op,n]],
	QPower[container[s_],m_].op:> op.QPower[container[s],m]+Com[QPower[container[s],m],op],
	QPower[container[s_],m_].QPower[op,n_]:> QPower[op,n].QPower[container[s],m]+Com[QPower[container[s],m],QPower[op,n]]
};


NormalOrderList[ops_]:=
	If[Length[ops]<2,{},
		Flatten@Join[
			NormalOrderLeft[Rest[ops],First[ops]],
			NormalOrderRight[ops[[2;;-2]],Last[ops]],
			NormalOrderList[ops[[2;;-2]]]
		]
	];


QSimplifyNormalOrder[container_,ops_List]:=
Join[
	NormalOrderLeft[container,First[ops]],
	NormalOrderRight[container,Last[ops]],
	NormalOrderList[ops[[2;;-2]]]
];


(* ::Subsubsection::Closed:: *)
(*Linear Algebra Rules*)


$QSimplifyLinearAlgebra={
(* Times *)
Times[Plus[a_,b__],c_]:>Expand[Times[Plus[a,b],c]],
(* Dot *)
Dot[a_,n_?CoefficientQ]:> n*Dot[a],
Dot[n_?CoefficientQ,b_]:> n*Dot[b],
Dot[a_,Plus[b_,c__]]:> Dot[a,b]+Dot[a,Plus[c]],
Dot[Plus[a_,b__],c_]:> Dot[a,c]+Dot[Plus[b],c],
Dot[a_,Times[b_?CoefficientQ,c__]]:> b*Dot[a,Times[c]],
Dot[a_,Times[c__,b_?CoefficientQ]]:> b*Dot[a,Times[c]],
Dot[Times[a_?CoefficientQ,b__],c_]:> a*Dot[Times[b],c],
Dot[Times[b__,a_?CoefficientQ],c_]:> a*Dot[Times[b],c],
Dot[a_,a_]:> QPower[a,2],
Dot[QPower[a_,n_],a_]:> QPower[a,n+1],
Dot[a_,QPower[a_,n_]]:> QPower[a,n+1],
Dot[QPower[a_,m_],QPower[a_,n_]]:> QPower[a,n+m],
Dot[CircleTimes[a1_,b1__],CircleTimes[a2_,b2__]]:> CircleTimes@@MapThread[Dot,{{a1,b1},{a2,b2}}],
(* CircleTimes *)
KroneckerProduct[a_,b__]:> CircleTimes[a,b],
CircleTimes[Plus[a_,b__],c_]:> Plus@@Map[CircleTimes[#,c]&,{a,b}],
CircleTimes[c_,Plus[a_,b__]]:> Plus@@Map[CircleTimes[c,#]&,{a,b}],
CircleTimes[Times[a_?CoefficientQ,b__],c_]:> a*CircleTimes[Times[b],c],
CircleTimes[Times[b__,a_?CoefficientQ],c_]:> a*CircleTimes[Times[b],c],
CircleTimes[c_,Times[a_?CoefficientQ,b__]]:> a*CircleTimes[c,Times[b]],
CircleTimes[c_,Times[b__,a_?CoefficientQ]]:> a*CircleTimes[c,Times[b]],
(* Transpose *)
Transpose[a_?CoefficientQ]:> a,
Transpose[Transpose[a_]]:> a,
Transpose[Plus[a_,b__]]:> Plus@@Map[Transpose,{a,b}],
Transpose[Times[a_,b__]]:> Times@@Map[Transpose,{a,b}],
Transpose[Dot[a_,b__]]:> Dot@@Map[Transpose,Reverse[{a,b}]],
Transpose[CircleTimes[a__]]:>CircleTimes@@Map[Transpose,a],
(* ConjugateTranspose *)
ConjugateTranspose[a_?CoefficientQ]:> Conjugate[a],
ConjugateTranspose[ConjugateTranspose[a_]]:> a,
ConjugateTranspose[a_]:> Transpose[Conjugate[a]],
Conjugate[Transpose[a_]]:> Transpose[Conjugate[a]],
(* Conjugate *)
Conjugate[Plus[a_,b__]]:>Plus@@Map[Conjugate,{a,b}],
Conjugate[Times[a_,b__]]:>Times@@Map[Conjugate,{a,b}],
Conjugate[Dot[a_,b__]]:>Dot@@Map[Conjugate,{a,b}],
Conjugate[CircleTimes[a__]]:>CircleTimes@@Map[Conjugate,{a}],
(* Com *)
Com[a_?CoefficientQ,b_]:> 0,
Com[a_,b_?CoefficientQ]:> 0,
Com[Plus[a_,b__],c_]:> Plus@@Map[Com[#,c]&,{a,b}],
Com[c_,Plus[a_,b__]]:> Plus@@Map[Com[c,#]&,{a,b}],
Com[Times[a_?CoefficientQ,b__],c_]:> a*Com[Times[b],c],
Com[Times[b__,a_?CoefficientQ],c_]:> a*Com[Times[b],c],
Com[c_,Times[a_?CoefficientQ,b__]]:> a*Com[c,Times[b]],
Com[c_,Times[b__,a_?CoefficientQ]]:> a*Com[c,Times[b]],
Com[Dot[a_,b__],c_]:> Dot[a,Com[Dot[b],c]]+Dot[Com[a,c],Dot[b]],
Com[a_,Dot[b_,c__]]:> Dot[Com[a,b],Dot[c]]+Dot[b,Com[a,Dot[c]]],
Com[QPower[a_,n_],b_]:> Dot[a,Com[QPower[a,n-1],b]]+Dot[Com[a,b],QPower[a,n-1]],
Com[a_,QPower[b_,n_]]:> Dot[b,Com[a,QPower[b,n-1]]]+Dot[Com[a,b],QPower[b,n-1]],
Com[CircleTimes[a1_,b1__],CircleTimes[a2_,b2__]]:> 
	CircleTimes[Com[a1,a2],Dot[CircleTimes[b1],CircleTimes[b2]]]
	+CircleTimes[Dot[a1,a2],Com[CircleTimes[b1],CircleTimes[b2]]],
Com[a_,b_,n_?Positive]:> Com[a,Com[a,b],n-1],
(* ACom *)
ACom[a_,b_]:> a.b+b.a,
ACom[a_,b_,n_?Positive]:> ACom[a,ACom[a,b],n-1]
	};


(* ::Subsubsection::Closed:: *)
(*Spin Rules*)


$QSimplifySpin=
Join[
QSimplifyAlgebra[Spin,
	{Spin["X"],Spin["Y"],Spin["Z"],Spin["P"],Spin["M"]},
	{{I*Spin["Z"],-I*Spin["Y"],-Spin["Z"],Spin["Z"]},
	{I*Spin["X"],-I*Spin["Z"],-I*Spin["Z"]},
	{Spin["P"],-Spin["M"]},
	{2Spin["Z"]}}],
{(* ConjugateTranspose *)
ConjugateTranspose[Spin["I"]]:> Spin["I"],
ConjugateTranspose[Spin["X"]]:> Spin["X"],
ConjugateTranspose[Spin["Y"]]:> Spin["Y"],
ConjugateTranspose[Spin["Z"]]:> Spin["Z"],
ConjugateTranspose[Spin["P"]]:> Spin["M"],
ConjugateTranspose[Spin["M"]]:>Spin["P"],
(* Transpose *)
Transpose[Spin["I"]]:> Spin["I"],
Transpose[Spin["X"]]:> Spin["X"],
Transpose[Spin["Y"]]:> -Spin["Y"],
Transpose[Spin["Z"]]:> Spin["Z"],
Transpose[Spin["P"]]:> Spin["M"],
Transpose[Spin["M"]]:>Spin["P"],
(* Conjugate *)
Conjugate[Spin["I"]]:> Spin["I"],
Conjugate[Spin["X"]]:> Spin["X"],
Conjugate[Spin["Y"]]:> -Spin["Y"],
Conjugate[Spin["Z"]]:> Spin["Z"],
Conjugate[Spin["P"]]:> Spin["P"],
Conjugate[Spin["M"]]:>Spin["M"]
}];


(* ::Text:: *)
(*Spin Algebra Convention*)


(* X and Y expand to P and M *)
$QSimplifySpinPM={
Spin["X"]:> (Spin["P"]+Spin["M"])/2,
Spin["Y"]:> (-I*Spin["P"]+I*Spin["M"])/2
};
(* P and M expand to X and Y *)
$QSimplifySpinXY={
Spin["P"]:> Spin["X"]+I*Spin["Y"],
Spin["M"]:> Spin["X"]-I*Spin["Y"]
};


(* ::Text:: *)
(*Additional Spin 1/2 rules*)


$QSimplifySpinHalf={
ACom[Spin["X"],Spin["Y"]]:> 0,
ACom[Spin["X"],Spin["Z"]]:> 0,
ACom[Spin["Y"],Spin["X"]]:> 0,
ACom[Spin["Y"],Spin["Z"]]:> 0,
ACom[Spin["Z"],Spin["X"]]:> 0,
ACom[Spin["Z"],Spin["Y"]]:> 0,

Spin["X"].Spin["X"]:> Spin["I"]/4,
Spin["X"].Spin["Y"]:> I*Spin["Z"]/2,
Spin["X"].Spin["Z"]:> -I*Spin["Y"]/2,
Spin["X"].Spin["P"]:> Spin["I"]/4-Spin["Z"]/2,
Spin["X"].Spin["M"]:> Spin["I"]/4+Spin["Z"]/2,

Spin["Y"].Spin["X"]:> -I*Spin["Z"]/2,
Spin["Y"].Spin["Y"]:> Spin["I"]/4,
Spin["Y"].Spin["Z"]:> I*Spin["X"]/2,
Spin["Y"].Spin["P"]:> I*Spin["I"]/4-I*Spin["Z"]/2,
Spin["Y"].Spin["M"]:> -I*Spin["I"]/4-I*Spin["Z"]/2,

Spin["Z"].Spin["X"]:> I*Spin["Y"]/2,
Spin["Z"].Spin["Y"]:> -I*Spin["X"]/2,
Spin["Z"].Spin["Z"]:> Spin["I"]/4,
Spin["Z"].Spin["P"]:> Spin["P"]/2,
Spin["Z"].Spin["M"]:> -Spin["M"]/2,

Spin["P"].Spin["X"]:> Spin["I"][1/2]/4+Spin["Z"][1/2]/2,
Spin["P"].Spin["Y"]:> I*Spin["I"][1/2]/4+I*Spin["Z"][1/2]/2,
Spin["P"].Spin["P"]:> 0,
Spin["P"].Spin["M"]:> Spin["Z"]+Spin["I"]/2,
Spin["P"].Spin["Z"]:> -Spin["P"]/2,

Spin["M"].Spin["X"]:> Spin["I"][1/2]/4-Spin["Z"][1/2]/2,
Spin["M"].Spin["Y"]:> -I*Spin["I"][1/2]/4+I*Spin["Z"][1/2]/2,
Spin["M"].Spin["P"]:> -Spin["Z"]+Spin["I"]/2,
Spin["M"].Spin["M"]:> 0,
Spin["M"].Spin["Z"]:> Spin["M"]/2,

QPower[Spin["X"],n_?Positive]:> If[EvenQ[n],Spin["I"]/2^n,Spin["X"]/2^(n-1)],
QPower[Spin["Y"],n_?Positive]:> If[EvenQ[n],Spin["I"]/2^n,Spin["Y"]/2^(n-1)],
QPower[Spin["Z"],n_?Positive]:> If[EvenQ[n],Spin["I"]/2^n,Spin["Z"]/2^(n-1)],
QPower[Spin["P"]+Spin["M"],n_?Positive]:> If[EvenQ[n],Spin["I"],Spin["P"]+Spin["M"]],
QPower[Spin["P"]-Spin["M"],n_?Positive]:> If[EvenQ[n],Spin["I"],Spin["P"]-Spin["M"]],
QPower[Spin["M"]-Spin["P"],n_?Positive]:> If[EvenQ[n],Spin["I"],Spin["M"]-Spin["P"]],
QPower[Spin["P"],n_?Positive]:> If[n===1,Spin["P"],0],
QPower[Spin["M"],n_?Positive]:> If[n===1,Spin["M"],0]
};


(* ::Text:: *)
(*Spin Normal Ordering*)


$QSimplifySpinOrdering=QSimplifyNormalOrder[Spin,{Spin["Z"],Spin["X"],Spin["Y"],Spin["P"],Spin["M"]}];


(* ::Subsubsection::Closed:: *)
(*Cavity Rules*)


$QSimplifyCavity=Join[
QSimplifyAlgebra[Cavity,
	{Cavity["a"],Cavity["c"],Cavity["n"]},
	{{Cavity["I"],Cavity["a"]},{-Cavity["c"]}}],
{(* ConjugateTranspose *)
ConjugateTranspose[Cavity["I"]]:> Cavity["I"],
ConjugateTranspose[Cavity["n"]]:> Cavity["n"],
ConjugateTranspose[Cavity["a"]]:> Cavity["c"],
ConjugateTranspose[Cavity["c"]]:> Cavity["a"],

(* Transpose *)
Transpose[Cavity["I"]]:> Cavity["I"],
Transpose[Cavity["n"]]:> Cavity["n"],
Transpose[Cavity["a"]]:> Cavity["c"],
Transpose[Cavity["c"]]:> Cavity["a"],

(* Conjugate *)
Conjugate[Cavity["I"]]:> Cavity["I"],
Conjugate[Cavity["n"]]:> Cavity["n"],
Conjugate[Cavity["a"]]:> Cavity["a"],
Conjugate[Cavity["c"]]:> Cavity["c"]
}];


(* ::Text:: *)
(*Normal Ordering of operators*)


$QSimplifyCavityOrdering=QSimplifyNormalOrder[Cavity,{Cavity["N"],Cavity["c"],Cavity["a"]}];


(* ::Text:: *)
(*Replace ladder operators with number operator where possible.*)


$QSimplifyCavityN={
	Cavity["c"].Cavity["a"]:> Cavity["n"],
	Cavity["c"].QPower[Cavity["a"],m_?Positive]:> Cavity["n"].QPower[Cavity["a"],m-1],
	QPower[Cavity["c"],m_?Positive].Cavity["a"]:> QPower[Cavity["c"],m-1].Cavity["n"],
	QPower[Cavity["c"],m_?Positive].QPower[Cavity["a"],n_?Positive]:> 
		Which[
			m==n,QPower[Cavity["n"],m],
			m>n, QPower[Cavity["c"],m-n].QPower[Cavity["n"],n],
			m<n,QPower[Cavity["n"],m].QPower[Cavity["a"],n-m]]
};


(* ::Text:: *)
(*Replace cavity number operators with ladder operators*)


$QSimplifyCavityAC={Cavity["n"]:> Cavity["c"].Cavity["a"]};


(* ::Subsection::Closed:: *)
(*Quantum Gates*)


(* ::Subsubsection::Closed:: *)
(*Controlled Gates*)


Options[CGate]={Control->1};


CGate[gate_,targ_,ctrl_,opts:OptionsPattern[]]:=
	With[{
		d=If[MatrixQ[gate],
			Length[gate],
			Length[First[gate]]]},
		CGate[d,gate,targ,ctrl,opts]
	]


CGate[dims_,gate_,targ_,ctrl_,opts:OptionsPattern[]]:=
	If[
		CGateArgTests[dims,gate,targ,ctrl],
		If[IntegerQ[dims],	
			CGate[ConstantArray[dims,Max[targ,ctrl]],gate,targ,ctrl,opts],
		With[{
			gates=If[MatrixQ[gate],{gate},gate],
			targs=If[IntegerQ[targ],{targ},targ],
			ctrls=If[IntegerQ[ctrl],{ctrl},ctrl]},
			CGateConstructor[dims,gates,targs,ctrls,CGateControl[ctrls,OptionValue[Control]]]
		]]	
	,Null]


(* ::Subsubsection::Closed:: *)
(*Controlled-Gate Utility Functions*)


(* ::Text:: *)
(*Extacting option value*)


CGateControl[ctrls_List,ctrlval_]:=
	Which[
		IntegerQ[ctrlval],
			ConstantArray[ctrlval,Length[ctrls]],
		And[
			AllQ[IntegerQ,ctrlval],
			Length[ctrlval]===Length[ctrls]],
				ctrlval,
		True,Message[CGate::ctrlval]]


(* ::Text:: *)
(*Tests if inputs are valid and returns appropriate error message if not.*)


CGateArgTests[dims_,gate_,targs_,ctrls_]:=
	Which[
		Not[Or[IntegerQ[dims],AllQ[IntegerQ,dims]]],
			Message[CGate::dims];False,
		Not[Intersection[Flatten[{targs}],Flatten[{ctrls}]]==={}],
			Message[CGate::targctrl];False,
		Not[Or[
				And[AllQ[MatrixQ,gate],Length[gate]===Length[Flatten[{targs}]]],
				And[MatrixQ[gate],IntegerQ[targs]]]],
			Message[CGate::gates]; False,
		True, True
		]


(* ::Text:: *)
(*Constructs a piece of a controlled gate for a set of gates on a set of targets for a set of control vals on a set of controls.*)


CGatePart[dims_,{gates_,targs_},{ctrls_,ctrlvals_}]:=
	With[{
		ids=Complement[Range[Length[dims]],ctrls,targs]},
	CircleTimes@@Permute[
			Join[gates,
				MapThread[
					Projector[UnitVector[#1,#2+1]]&,
					{Part[dims,ctrls],ctrlvals}],
				Map[IdentityMatrix,Part[dims,ids]]
			],
			Flatten[{targs,ctrls,ids}]]
	]


(* ::Text:: *)
(*Function for constructing the actual controlled gate.*)


CGateConstructor[dims_,gates_List,targs_List,ctrls_List,ctrlvals_List]:=
	Block[{dtargs,dctrls,notctrls,gateOp,idOp},
		dtargs=Part[dims,targs];
		dctrls=Part[dims,ctrls];
		notctrls=Complement[Tuples[Range[0,#-1]&/@dctrls],{ctrlvals}];
		gateOp=CGatePart[dims,
					{gates,targs},
					{ctrls,ctrlvals}];
		idOp=Total@Map[
				CGatePart[dims,
					{IdentityMatrix/@dtargs,targs},
					{ctrls,#}]&,
					notctrls];
		gateOp+idOp
]


(* ::Subsection::Closed:: *)
(*State Measures*)


(* ::Subsubsection::Closed:: *)
(*Entropy*)


LogSafeZero[b_:2, x_] := Piecewise[{{0, x == 0}, {x Log[b, x], x != 0}}]


EntropyH[{ps__}]:= Plus@@Map[-LogSafeZero[2,#]&,{ps}]


EntropyS[mat_]:= 
	If[SquareMatrixQ[mat],
		EntropyH[Eigenvalues[mat]],
		Message[EntropyS::sqmat]
	]


MutualInformationS[mat_, {dA_, dB_}]:= 
	If[SquareMatrixQ[mat],
		(EntropyS[PartialTr[mat, {dA, dB},{1}]]
		+EntropyS[PartialTr[mat, {dA, dB},{2}]]
		-EntropyS[mat]),
		Message[MutualInformationS::sqmat]]


MutualInformationS[mat_]:=With[{d=Sqrt@Length[mat]},
	If[IntegerQ[d],
		MutualInformationS[mat,{d,d}],
		Message[MutualInformationS::dims]	
	]]


(* ::Text:: *)
(*Function for computing the matrix-log of singular matrices. It returns -\[Infinity] for zero eigenvalues*)


MatrixLogZero[base_,A_]:=
	With[{sys=Eigensystem[A]},
		Total[
			ReplaceAll[
				Log[base,First[sys]],
				{DirectedInfinity[-1]->-"\[Infinity]",DirectedInfinity[1]->"\[Infinity]"}
			]*Map[Composition[Projector,Normalize],Last[sys]]
	]]


RelativeEntropyS[A_,B_]:=
	If[AllQ[SquareMatrixQ,{A,B}],
		ReplaceAll[
			-EntropyS[A]-Tr[A.MatrixLogZero[2,B]],
			"\[Infinity]"->DirectedInfinity[1]
		],
	Message[RelativeEntropyS::sqmat]
]



(* ::Subsubsection::Closed:: *)
(*Norms*)


TrNorm[A_]:=Total@SingularValueList[A]


PNorm[A_]:=Norm[A];
PNorm[A_,1]:=If[MatrixQ[A],Total@SingularValueList[A],Norm[A,1]];
PNorm[A_,2]:=If[MatrixQ[A],Norm[A,"Frobenius"],Norm[A,2]];
PNorm[A_,p_]:=If[MatrixQ[A],Norm[SingularValueList[A],p],Norm[A,p]];


(* ::Subsubsection::Closed:: *)
(*Purity and Fidelity*)


Purity[A_]:=
	If[SquareMatrixQ[A],
		Tr[A\[HermitianConjugate].A],
		Message[Purity::sqmat]
	]
Purity[A_?MatrixQ,Normalize->True]:=With[{d=Length[A]},d/(d-1) (Purity[A]-1/d)];


Fidelity[A_,B_]:=With[{
		av=GeneralVectorQ[A],
		bv=GeneralVectorQ[B],
		am=MatrixQ[A],
		bm=MatrixQ[B]},
	Which[
		And[av,bv],Abs[Conjugate[Flatten[A]].Flatten[B]],
		And[av,Not[bv],bm], Sqrt[Tr[B.Projector[A]]],
		And[am,Not[av],bv], Sqrt[Tr[A.Projector[B]]],
		And[am,bm],Total@SingularValueList[MatrixPower[A,1/2].MatrixPower[B,1/2]],
		True,Message[Fidelity::input]
	]]


(* ::Subsubsection::Closed:: *)
(*Entanglement Measures*)


EntangledQ[op_,{da_Integer,db_Integer},fn_]:=
	Which[
		GeneralVectorQ[op],EntangledQ[Projector[op],{da,db},fn],
		SquareMatrixQ[op],
			With[{vals=fn[Eigenvalues[MatrixTranspose[op,{da,db,da,db},{1,4,2,3}]]]},
			If[AnyQ[Negative,vals],True,
			If[Length[op]<=6,False,"Indeterminate"]]],
		True,Message[EntangledQ::input]
	]

EntangledQ[op_,{da_Integer,db_Integer}]:=EntangledQ[op,{da,db},Identity]
EntangledQ[op_,fn_]:=With[{d=Sqrt@Length[op]},EntangledQ[op,{d,d},fn]]
EntangledQ[op_]:=EntangledQ[op,Identity]


Concurrence[op_]:=
	If[Length[op]===4,
		Which[
			GeneralVectorQ[op],
				Concurrence[Projector[op]],
			SquareMatrixQ[op],
				With[{vals=Sqrt@Sort[Chop@Eigenvalues[op.TP["YY"].Conjugate[op].TP["YY"]],Greater]},
				Max[{0,(First[vals]-Total@Rest[vals])}]],
			True, Message[Concurrence::input]
		], Message[Concurrence::dim]
	]


EntanglementF[op_]:=
	If[Length[op]===4,
		Which[
			GeneralVectorQ[op],
				EntanglementF[Projector[op]],
			SquareMatrixQ[op],
				With[{val=(1+Sqrt[1-Concurrence[op]^2])/2},
				(-LogSafeZero[val]-LogSafeZero[1-val])],
			True, Message[EntanglementF::input]
		], Message[EntanglementF::dim]
	]


(* ::Subsection::Closed:: *)
(*Random Matrices*)


(* ::Text:: *)
(*Needs updating to being random with respect to proper measures*)


RandomNormal[]:=RandomVariate[NormalDistribution[0,1]]
RandomNormal[dims_]:=RandomVariate[NormalDistribution[0,1],dims]


GinibreMatrix[n_,r_]:=RandomNormal[{n,r}]+I*RandomNormal[{n,r}]


RandomUnitary[n_]:=Orthogonalize[GinibreMatrix[n,n]]


RandomDensity[n_]:=RandomDensity[n,n]
RandomDensity[n_,rank_]:=RandomDensity[n,rank,"HS"]

RandomDensity[n_,rank_,"HS"]:=
	With[{G=GinibreMatrix[n,rank]},
	#/Tr[#]&[G.ConjugateTranspose[G]]
	]

RandomDensity[n_,"HS"]:=RandomDensity[n,n,"HS"]


RandomDensity[n_,rank_,"Bures"]:=
	With[{
		G=GinibreMatrix[n,rank],
		U=RandomUnitary[n],
		id=IdentityMatrix[n]},
	#/Tr[#]&[(id+U).G.ConjugateTranspose[G].(id+ConjugateTranspose[U])]
	]

RandomDensity[n_,"Bures"]:=RandomDensity[n,n,"Bures"]


RandomHermitian[n_,tr_:1]:=With[
	{A=GinibreMatrix[n,n]RandomComplex[{0,1+I},{n,n}]},
	tr*#/Tr[MatrixPower[#.#,1/2]]&[A+ConjugateTranspose[A]]
];


(* ::Subsection::Closed:: *)
(*End Private*)


End[];


(* ::Section::Closed:: *)
(*Unit Testing*)


Begin["UnitTests`"];


(* ::Subsection::Closed:: *)
(*States and Operators*)


(* ::Subsubsection::Closed:: *)
(*Spin Operators*)


TestCase["QuantumSystems:SpinNumbers",
	And[
		Spin[0]===Spin["I"],
		Spin[1]===Spin["X"],
		Spin[2]===Spin["Y"],
		Spin[3]===Spin["Z"]
	]];


TestCase["QuantumSystems:SpinMatrix",
	And[
		Spin["I"][1/2]===IdentityMatrix[2],
		Spin["X"][1/2]==={{0,1},{1,0}}/2,
		Spin["Y"][1/2]==={{0,-I},{I,0}}/2,
		Spin["Z"][1/2]==={{1,0},{0,-1}}/2,
		Spin["P"][1/2]==={{0,1},{0,0}},
		Spin["M"][1/2]==={{0,0},{1,0}},
		Spin["I"][1]===IdentityMatrix[3],
		Spin["X"][1]==={{0,1,0},{1,0,1},{0,1,0}}/Sqrt[2],
		Spin["Y"][1]==={{0,-I,0},{I,0,-I},{0,I,0}}/Sqrt[2],
		Spin["Z"][1]==={{1,0,0},{0,0,0},{0,0,-1}},
		Spin["P"][1]==={{0,1,0},{0,0,1},{0,0,0}}*Sqrt[2],
		Spin["M"][1]==={{0,0,0},{1,0,0},{0,1,0}}*Sqrt[2],
		Spin["XX+YY-2ZZ"][1/2]==={{-1,0,0,0},{0,1,1,0},{0,1,1,0},{0,0,0,-1}}/2
	]];


TestCase["QuantumSystems:SpinSparseArray",
	And[
		Spin["I"][1/2,SparseArray]==IdentityMatrix[2,SparseArray],
		Spin["X"][1/2,SparseArray]==SparseArray[{{0,1},{1,0}}/2],
		Spin["Y"][1/2,SparseArray]==SparseArray[{{0,-I},{I,0}}/2],
		Spin["Z"][1/2,SparseArray]==SparseArray[{{1,0},{0,-1}}/2],
		Spin["P"][1/2,SparseArray]==SparseArray[{{0,1},{0,0}}],
		Spin["M"][1/2,SparseArray]==SparseArray[{{0,0},{1,0}}],
		Spin["I"][1,SparseArray]==IdentityMatrix[3,SparseArray],
		Spin["X"][1,SparseArray]==SparseArray[{{0,1,0},{1,0,1},{0,1,0}}/Sqrt[2]],
		Spin["Y"][1,SparseArray]==SparseArray[{{0,-I,0},{I,0,-I},{0,I,0}}/Sqrt[2]],
		Spin["Z"][1,SparseArray]==SparseArray[{{1,0,0},{0,0,0},{0,0,-1}}],
		Spin["P"][1,SparseArray]==SparseArray[{{0,1,0},{0,0,1},{0,0,0}}*Sqrt[2]],
		Spin["M"][1,SparseArray]==SparseArray[{{0,0,0},{1,0,0},{0,1,0}}*Sqrt[2]],
		Spin["XX+YY-2ZZ"][1/2,SparseArray]==SparseArray[{{-1,0,0,0},{0,1,1,0},{0,1,1,0},{0,0,0,-1}}/2]
	]];


(* ::Subsubsection::Closed:: *)
(*Cavity Operators*)


TestCase["QuantumSystems:CavityMatrix",
	And[
		Cavity["I"][2]===IdentityMatrix[2],
		Cavity["a"][2]==={{0,1},{0,0}},
		Cavity["c"][2]==={{0,0},{1,0}},
		Cavity["n"][2]==={{0,0},{0,1}},
		Cavity["I"][4]===IdentityMatrix[4],
		Cavity["a"][4]===DiagonalMatrix[Sqrt[{1,2,3}],1],
		Cavity["c"][4]===DiagonalMatrix[Sqrt[{1,2,3}],-1],
		Cavity["n"][4]===DiagonalMatrix[{0,1,2,3}],
		Cavity["ac+ca"][2]==={{0,0,0,0},{0,0,1,0},{0,1,0,0},{0,0,0,0}}
	]];


TestCase["QuantumSystems:CavitySparseArray",
	And[
		Cavity["I"][2,SparseArray]==IdentityMatrix[2,SparseArray],
		Cavity["a"][2,SparseArray]==SparseArray[{{0,1},{0,0}}],
		Cavity["c"][2,SparseArray]==SparseArray[{{0,0},{1,0}}],
		Cavity["n"][2,SparseArray]==SparseArray[{{0,0},{0,1}}],
		Cavity["I"][4,SparseArray]==IdentityMatrix[4,SparseArray],
		Cavity["a"][4,SparseArray]==SparseArray[DiagonalMatrix[Sqrt[{1,2,3}],1]],
		Cavity["c"][4,SparseArray]==SparseArray[DiagonalMatrix[Sqrt[{1,2,3}],-1]],
		Cavity["n"][4,SparseArray]==SparseArray[DiagonalMatrix[{0,1,2,3}]],
		Cavity["ac+ca"][2,SparseArray]==SparseArray[{{0,0,0,0},{0,0,1,0},{0,1,0,0},{0,0,0,0}}]
	]];


(* ::Subsubsection::Closed:: *)
(*Quantum States*)


TestCase["QuantumSystems:QStateBloch",
	And[
		QState[{"x","y","z"}]=={{1+"z","x"-I "y"},{"x"+I "y",1-"z"}}/2,
		QState[{"x1","y1","z2"},{"x2","y2","z2"}]=={
			{(1+"z2")^2,("x2"-I "y2") (1+"z2"),("x1"-I "y1") (1+"z2"),("x1"-I "y1") ("x2"-I "y2")},
			{("x2"+I "y2") (1+"z2"),(1-"z2") (1+"z2"),("x1"-I "y1") ("x2"+I "y2"),("x1"-I "y1") (1-"z2")},
			{("x1"+I "y1") (1+"z2"),("x1"+I "y1") ("x2"-I "y2"),(1-"z2") (1+"z2"),("x2"-I "y2") (1-"z2")},
			{("x1"+I "y1") ("x2"+I "y2"),("x1"+I "y1") (1-"z2"),("x2"+I "y2") (1-"z2"),(1-"z2")^2}}/4
	]];


TestCase["QuantumSystems:QStateVector",
	And[
		AllMatchQ[{1,0}, QState[#,VectorQ->True]&/@{"Zp","H"}],
		AllMatchQ[{0,1}, QState[#,VectorQ->True]&/@{"Zm","V"}],
		AllMatchQ[{1,1}/Sqrt[2], QState[#,VectorQ->True]&/@{"Xp","D"}],
		AllMatchQ[{1,-1}/Sqrt[2], QState[#,VectorQ->True]&/@{"Xm","A"}],
		AllMatchQ[{1,I}/Sqrt[2], QState[#,VectorQ->True]&/@{"Yp","R"}],
		AllMatchQ[{1,-I}/Sqrt[2], QState[#,VectorQ->True]&/@{"Ym","L"}],
		AllMatchQ[{1,0,0,1}/Sqrt[2],QState[#,VectorQ->True]&/@{"B1","Bell1"}],
		AllMatchQ[{0,1,1,0}/Sqrt[2],QState[#,VectorQ->True]&/@{"B2","Bell2"}],
		AllMatchQ[{0,1,-1,0}/Sqrt[2],QState[#,VectorQ->True]&/@{"B3","Bell3"}],
		AllMatchQ[{1,0,0,-1}/Sqrt[2],QState[#,VectorQ->True]&/@{"B4","Bell4"}]
	]];


TestCase["QuantumSystems:QStateGeneralVector",
	And[
		AllMatchQ[{{1},{0}}, QState[#,ColumnVectorQ->True]&/@{"Zp","H"}],
		AllMatchQ[{{0},{1}}, QState[#,ColumnVectorQ->True]&/@{"Zm","V"}],
		AllMatchQ[{{1},{1}}/Sqrt[2], QState[#,ColumnVectorQ->True]&/@{"Xp","D"}],
		AllMatchQ[{{1},{-1}}/Sqrt[2], QState[#,ColumnVectorQ->True]&/@{"Xm","A"}],
		AllMatchQ[{{1},{I}}/Sqrt[2], QState[#,ColumnVectorQ->True]&/@{"Yp","R"}],
		AllMatchQ[{{1},{-I}}/Sqrt[2], QState[#,ColumnVectorQ->True]&/@{"Ym","L"}],
		AllMatchQ[{{1},{0},{0},{1}}/Sqrt[2],QState[#,ColumnVectorQ->True]&/@{"B1","Bell1"}],
		AllMatchQ[{{0},{1},{1},{0}}/Sqrt[2],QState[#,ColumnVectorQ->True]&/@{"B2","Bell2"}],
		AllMatchQ[{{0},{1},{-1},{0}}/Sqrt[2],QState[#,ColumnVectorQ->True]&/@{"B3","Bell3"}],
		AllMatchQ[{{1},{0},{0},{-1}}/Sqrt[2],QState[#,ColumnVectorQ->True]&/@{"B4","Bell4"}]
	]];


TestCase["QuantumSystems:QStateDensity",
	And[
		QState["I"]==IdentityMatrix[2]/2,
		AllMatchQ[{{1,0},{0,0}}, QState[#]&/@{"Zp","H"}],
		AllMatchQ[{{0,0},{0,1}}, QState[#]&/@{"Zm","V"}],
		AllMatchQ[{{1,1},{1,1}}/2, QState[#]&/@{"Xp","D"}],
		AllMatchQ[{{1,-1},{-1,1}}/2, QState[#]&/@{"Xm","A"}],
		AllMatchQ[{{1,-I},{I,1}}/2, QState[#]&/@{"Yp","R"}],
		AllMatchQ[{{1,I},{-I,1}}/2, QState[#]&/@{"Ym","L"}],
		AllMatchQ[{{1,0,0,1},{0,0,0,0},{0,0,0,0},{1,0,0,1}}/2,
			QState[#]&/@{"B1","Bell1"}],
		AllMatchQ[{{0,0,0,0},{0,1,1,0},{0,1,1,0},{0,0,0,0}}/2, 
			QState[#]&/@{"B2","Bell2"}],
		AllMatchQ[{{0,0,0,0},{0,1,-1,0},{0,-1,1,0},{0,0,0,0}}/2,
			QState[#]&/@{"B3","Bell3"}],
		AllMatchQ[{{1,0,0,-1},{0,0,0,0},{0,0,0,0},{-1,0,0,1}}/2,
			QState[#]&/@{"B4","Bell4"}]
	]];


(* ::Subsubsection::Closed:: *)
(*Bra-Ket Notation*)


TestCase["QuantumSystems:KetForm",
	And[
		AllMatchQ[Ket[Subscript[0,2],Subscript[0,2]],KetForm/@{{1,0,0,0},{{1},{0},{0},{0}}}],
		KetForm[{{1,0,0,0}}]===Bra[Subscript[0,2],Subscript[0,2]],
		SameQ[KetForm[{"a",0,0,0,0,"b"},{2,3}],
			"a"*Ket[Subscript[0,2],Subscript[0,3]]+"b"*Ket[Subscript[1,2],Subscript[2,3]]],
		SameQ[KetForm[Array["a",{2,2}]],
			"a"[1,1]*KetBra[{Subscript[0,2]},{Subscript[0,2]}]+
			"a"[1,2]*KetBra[{Subscript[0,2]},{Subscript[1,2]}]+
			"a"[2,1]*KetBra[{Subscript[1,2]},{Subscript[0,2]}]+
			"a"[2,2]*KetBra[{Subscript[1,2]},{Subscript[1,2]}]]
	]];


(* ::Subsubsection::Closed:: *)
(*Vec Form*)


TestCase["QuantumSystems:VecForm",
	And[
		SameQ[{{1},{0},{0},{0}},VecForm@Ket[Subscript[0,2],Subscript[0,2]]],
		SameQ[{{1,0,0,0}},VecForm@Bra[Subscript[0,2],Subscript[0,2]]],
		SameQ[{{"a"},{0},{0},{0},{0},{"b"}},
			VecForm["a"*Ket[Subscript[0,2],Subscript[0,3]]+"b"*Ket[Subscript[1,2],Subscript[2,3]]]],
		SameQ[Array["a",{2,2}],VecForm[
			"a"[1,1]*KetBra[{Subscript[0,2]},{Subscript[0,2]}]+
			"a"[1,2]*KetBra[{Subscript[0,2]},{Subscript[1,2]}]+
			"a"[2,1]*KetBra[{Subscript[1,2]},{Subscript[0,2]}]+
			"a"[2,2]*KetBra[{Subscript[1,2]},{Subscript[1,2]}]]],
		SameQ[VecForm[Ket[Subscript[0,2],Subscript[0,2]].Bra[Subscript[0,2],Subscript[0,2]]],
			DiagonalMatrix[{1,0,0,0}]],
		SameQ[VecForm[Spin["Z"],Spin->1],{{1,0,0},{0,0,0},{0,0,-1}}],
		SameQ[VecForm[CircleTimes[Spin["P"],Cavity["a"]],Cavity->3],
			{{0,0,0,0,1,0},{0,0,0,0,0,Sqrt[2]},{0,0,0,0,0,0},
			{0,0,0,0,0,0},{0,0,0,0,0,0},{0,0,0,0,0,0}}]
	]];


(* ::Subsection::Closed:: *)
(*Symbolic Evaluation*)


TestCase["QuantumSystems:QExpand",
	SameQ[QExpand[Spin["3XX+2YY"]]
		3CircleTimes[Spin["X"],Spin["X"]]+2*CircleTimes[Spin["Y"],Spin["Y"]]],
	SameQ[QExpand[Cavity["ac-ca"]]
		CircleTimes[Spin["a"],Spin["c"]]-CircleTimes[Spin["c"],Spin["a"]]]
	];


TestCase["QuantumSystems:QSimplify:Spin",
	And[
		AllMatchQ[
			-I*Spin["Z"],
			{QSimplify[Com[Spin["Y"],Spin["X"]]],
			QSimplify[Com[Spin["Y"],Spin["X"]],"SpinAlgebra"->"PM"],
			QSimplify[Com[Spin["Y"],Spin["X"]],"SpinAlgebra"->"XY"]}],
		AllMatchQ[
			-I*Spin["X"],
			{QSimplify[Com[Spin["Z"],Spin["Y"]]],
			QSimplify[Com[Spin["Z"],Spin["Y"]],"SpinAlgebra"->"XY"]}],
		AllMatchQ[
			-I*Spin["Y"],
			{QSimplify[Com[Spin["X"],Spin["Z"]]],
			QSimplify[Com[Spin["X"],Spin["Z"]],"SpinAlgebra"->"XY"]}],
		AllMatchQ[
			Spin["P"],
			{QSimplify[Com[Spin["Z"],Spin["P"]]],
			QSimplify[Com[Spin["Z"],Spin["P"]],"SpinAlgebra"->"PM"]}],
		SameQ[
			Spin["X"]+I*Spin["Y"],
			QSimplify[Com[Spin["Z"],Spin["P"]],"SpinAlgebra"->"XY"]],
		AllMatchQ[
			-Spin["M"],
			{QSimplify[Com[Spin["Z"],Spin["M"]]],
			QSimplify[Com[Spin["Z"],Spin["M"]],"SpinAlgebra"->"PM"]}],
		SameQ[
			-Spin["X"]+I*Spin["Y"],
			QSimplify[Com[Spin["Z"],Spin["M"]],"SpinAlgebra"->"XY"]],
		AllMatchQ[
			Spin["I"]/4,
			QSimplify[Spin[#]^2,"SpinHalf"->True]&/@{"X","Y","Z"}],
		SameQ[
			QSimplify[Spin["M"].Spin["Z"],"OrderSpin"->True],
			Spin["Z"].Spin["M"]+Spin["M"]],
		SameQ[
			QSimplify[Spin["P"].Spin["Z"],"OrderSpin"->True],
			Spin["Z"].Spin["P"]-Spin["P"]],
		SameQ[
			QSimplify[Spin["M"].Spin["P"],"OrderSpin"->True],
			Spin["P"].Spin["M"]-2 Spin["Z"]]
	]];


TestCase["QuantumSystems:QSimplify:Cavity",
	And[
		QSimplify@Com[Cavity["c"],Cavity["a"]]===-Cavity["I"],
		QSimplify@Com[Cavity["a"],Cavity["n"]]===Cavity["a"],
		QSimplify@Com[Cavity["c"],Cavity["n"]]===-Cavity["c"],
		AllMatchQ[
			"\[Alpha]" Cavity["c"]+Cavity["a"] Conjugate["\[Alpha]"],
		QSimplify[Com[Cavity["n"],"\[Alpha]"Cavity["c"]-Conjugate["\[Alpha]"]Cavity["a"],#]]&/@{1,3}]
	]];


TestCase["QuantumSystems:QSimplify:SpinCavity",
	With[{
		h0="w1"Spin["Z"]\[CircleTimes]Cavity["I"]+"w2"Spin["I"]\[CircleTimes]Cavity["n"],
		hJC=QSimplify[ConjugateTranspose[#]+#&[Spin["P"]\[CircleTimes]Cavity["a"]]],
		hJCm=QSimplify[ConjugateTranspose[#]-#&[Spin["P"]\[CircleTimes]Cavity["a"]]]},
	And[
		QSimplify@Com[h0,hJC,2]==("w1"-"w2")^2*hJC,
		QSimplify@Com[h0,hJC,3]==-("w1"-"w2")^3*hJCm,
		QSimplify@Com[h0,hJC,4]==("w1"-"w2")^4*hJC
	]]];


TestCase["QuantumSystems:QSimplify:Algebra",
	And[
		QSimplify[CircleTimes["\[Omega]"*Op["a"],"\[Lambda]"*Op["b"]]]=="\[Omega]"*"\[Lambda]"*CircleTimes[Op["a"],Op["b"]],
		QSimplify[Dot["\[Omega]"*Op["a"],"\[Lambda]"*Op["b"]]]=="\[Omega]"*"\[Lambda]"*Dot[Op["a"],Op["b"]],
		QSimplify[Com["\[Omega]"*Op["a"],"\[Lambda]"*Op["b"]]]=="\[Omega]"*"\[Lambda]"*Com[Op["a"],Op["b"]],
		QSimplify[CircleTimes["\[Omega]"*Op["a"]+"\[Lambda]"*Op["b"],"\[Mu]"*Op["c"]]]=="\[Mu]"("\[Omega]"*CircleTimes[Op["a"],Op["c"]]+"\[Lambda]"*CircleTimes[Op["b"],Op["c"]]),
		QSimplify[Dot["\[Omega]"*Op["a"]+"\[Lambda]"*Op["b"],"\[Mu]"*Op["c"]]]=="\[Mu]"("\[Omega]"*Op["a"].Op["c"]+"\[Lambda]"*Op["b"].Op["c"]),
		QSimplify[Com["\[Omega]"*Op["a"]+"\[Lambda]"*Op["b"],"\[Mu]"*Op["c"]]]=="\[Mu]"("\[Omega]"*Com[Op["a"],Op["c"]]+"\[Lambda]"*Com[Op["b"],Op["c"]])
	]];


TestCase["QuantumSystems:QSimplifyPower",
	SameQ[
		QSimplify[Op["I"]^3,QSimplifyPower[Op]],
		QPower[Op["I"],3]]
	];


TestCase["QuantumSystems:QSimplifyIdentity",
	SameQ[
		QSimplify[Op["I"].Op["A"],QSimplifyIdentity[Op["I"]]],
		Op["A"]]
	];


TestCase["QuantumSystems:QSimplifyNormalOrder",
	SameQ[
		QSimplify[Op["B"].Op["A"],
			QSimplifyNormalOrder[Op,{Op["A"],Op["B"]}]],
		Op["A"].Op["B"]+Com[Op["B"],Op["A"]]]
	];


TestCase["QuantumSystems:QSimplifyComAlgebra",
	SameQ[
		QSimplify[Com[Op["A"],Op["B"]],
			QSimplifyComAlgebra[{Op["A"],Op["B"]},{{Op["C"]}}]],
		Op["C"]]
	];


TestCase["QuantumSystems:QSimplifyAlgebra",
	And[
		SameQ[
			QSimplify[Com[Dot[Op["I"]^3].Op["A"],Op["B"]],
				QSimplifyAlgebra[Op,{Op["A"],Op["B"]},{{Op["C"]}}]],
			Op["C"]],
		SameQ[
			QSimplify[Com[Dot[Op["id"]^3].Op["A"],Op["B"]],
				QSimplifyAlgebra[Op,{Op["A"],Op["B"]},{{Op["C"]}},Identity->Op["id"]]],
			Op["C"]],
		SameQ[
			QSimplify[Op["B"].Op["A"],
				QSimplifyAlgebra[Op,{Op["A"],Op["B"]},{{Op["C"]}},"NormalOrder"->True]],
			Op["A"].Op["B"]-Op["C"]],
		SameQ[
			QSimplify[Op["B"].Op["A"],
				QSimplifyAlgebra[Op,{Op["A"],Op["B"]},{{Op["C"]}},"NormalOrder"->{Op["B"],Op["A"]}]],
			Op["B"].Op["A"]]
	]];


(* ::Subsection::Closed:: *)
(*Quantum Gates*)


(* ::Text:: *)
(*Still need to test all the possible configurations*)


TestCase["QuantumSystems:CGate",
	And[
		AllMatchQ[
			{{1,0,0,0},{0,1,0,0},{0,0,0,1},{0,0,1,0}},
			{CGate[PauliMatrix[1],2,1],CGate[PauliMatrix[1],2,{1}],
			CGate[{PauliMatrix[1]},{2},1],CGate[{2,2},PauliMatrix[1],2,1],
			CGate[{2,2},PauliMatrix[1],2,{1}],CGate[{2,2},{PauliMatrix[1]},{2},1],
			CGate[PauliMatrix[1],2,1,Control->1],CGate[PauliMatrix[1],2,1,Control->{1}]
			CGate[{2,2},PauliMatrix[1],2,1,Control->1],CGate[{2,2},PauliMatrix[1],2,1,Control->{1}]}
		],
		AllMatchQ[
			{{1,0,0,0,0,0,0,0},{0,1,0,0,0,0,0,0},{0,0,1,0,0,0,0,0},{0,0,0,1,0,0,0,0},
			{0,0,0,0,1,0,0,0},{0,0,0,0,0,1,0,0},{0,0,0,0,0,0,0,1},{0,0,0,0,0,0,1,0}},
			{CGate[PauliMatrix[1],3,{1,2}],CGate[{PauliMatrix[1]},{3},{1,2}],
			CGate[{2,2,2},PauliMatrix[1],3,{1,2}],CGate[{2,2,2},{PauliMatrix[1]},{3},{1,2}],
			CGate[PauliMatrix[1],3,{1,2},Control->1],CGate[PauliMatrix[1],3,{1,2},Control->{1,1}],
			CGate[{2,2,2},PauliMatrix[1],3,{1,2},Control->1],CGate[{2,2,2},PauliMatrix[1],3,{1,2},Control->{1,1}]}
		],
		AllMatchQ[
			{{1,0,0,0,0,0,0,0},{0,1,0,0,0,0,0,0},{0,0,0,1,0,0,0,0},{0,0,1,0,0,0,0,0},
			{0,0,0,0,1,0,0,0},{0,0,0,0,0,1,0,0},{0,0,0,0,0,0,1,0},{0,0,0,0,0,0,0,1}},
			{CGate[{2,2,2},PauliMatrix[1],3,{1,2},Control->{0,1}],
			CGate[PauliMatrix[1],3,{1,2},Control->{0,1}],
			CGate[{PauliMatrix[1]},{3},{1,2},Control->{0,1}]}
		],
		AllMatchQ[
			{{1,0,0,0,0,0,0,0},{0,1,0,0,0,0,0,0},{0,0,1,0,0,0,0,0},{0,0,0,1,0,0,0,0},
			{0,0,0,0,0,0,1,0},{0,0,0,0,0,0,0,-1},{0,0,0,0,1,0,0,0},{0,0,0,0,0,-1,0,0}},
			{CGate[{PauliMatrix[1],PauliMatrix[3]},{2,3},1],
			CGate[{2,2,2},{PauliMatrix[1],PauliMatrix[3]},{2,3},1],
			CGate[{2,2,2},{PauliMatrix[1],PauliMatrix[3]},{2,3},{1}],
			CGate[{2,2,2},{PauliMatrix[1],PauliMatrix[3]},{2,3},1,Control->1]}
		]
	]];


(* ::Subsection::Closed:: *)
(*State Measures*)


TestCase["QuantumSystems:EntropyH",
	And[
		EntropyH[{1,1,1,1}/4]===2,
		EntropyH[{1,1}/2]===1,
		EntropyH[{1,0}]===0
	]];


TestCase["QuantumSystems:EntropyS",
	And[
		EntropyS[IdentityMatrix[2]/2]===1,
		EntropyS[DiagonalMatrix[{1,0}]]===0
	]];


TestCase["QuantumSystems:MutualInformationS",
	With[{bell={{1,0,0,1},{0,0,0,0},{0,0,0,0},{1,0,0,1}}/2,z={{1,0},{0,0}}},
	And[
		MutualInformationS[bell]===2,
		MutualInformationS[KroneckerProduct[z,z]]===0,
		MutualInformationS[KroneckerProduct[z,bell],{2,4}]===0,
		MutualInformationS[KroneckerProduct[z,bell],{4,2}]===2
	]]];


TestCase["QuantumSystems:RelativeEntropyS",
	And[
		RelativeEntropyS[{{1,0},{0,0}},{{1,1},{1,1}}/2]===DirectedInfinity[1],
		RelativeEntropyS[{{1,0},{0,0}},{{1,0},{0,1}}/2]===1,
		RelativeEntropyS[{{1,0},{0,1}}/2,{{1,0},{0,1}}/2]===0
	]];


TestCase["QuantumSystems:PNorm",
	And[
		0===Norm[PNorm[DiagonalMatrix[{3,1}/4],2]-Sqrt@Total[{9,1}/16]],
		1===PNorm[{{1-1/2,0},{0,-1/2}},1],
		2===PNorm[{{1,0},{0,-1}},1]
	]];


TestCase["QuantumSystems:Purity",
	And[
		Purity[IdentityMatrix[2]/2]===1/2,
		Purity[IdentityMatrix[2]/2,Normalize->True]===0,
		Purity[DiagonalMatrix[{1/3,2/3}]]===5/9,
		Purity[{{1,0},{0,0}}]===1
	]];


TestCase["QuantumSystems:Fidelity",
	With[{
		v1={1,0}, v2={1,1}/Sqrt[2], v3={0,1},
		m1={{1,0},{0,0}}, m2={{1,1},{1,1}}/2, m3={{0,0},{0,1}}},
	And[
		AllMatchQ[1/Sqrt[2],{Fidelity[v1,v2],Fidelity[v1,m2],Fidelity[m1,v2],Fidelity[m1,m2]}],
		AllMatchQ[1,{Fidelity[v2,v2],Fidelity[v2,m2],Fidelity[m2,v2],Fidelity[m2,m2]}],
		AllMatchQ[0,{Fidelity[v1,v3],Fidelity[v1,m3],Fidelity[m1,v3],Fidelity[m1,m3]}]
	]]];


TestCase["QuantumSystems:EntangledQ",
	And[
		EntangledQ[{{1,0,0,1},{0,0,0,0},{0,0,0,0},{1,0,0,1}}/2],
		Not@EntangledQ[DiagonalMatrix[{1,0,0,0}]]
	]];


TestCase["QuantumSystems:Concurrence",
	And[
		Concurrence[{{3,0,0,2},{0,1,0,0},{0,0,1,0},{2,0,0,3}}/8]===1/4,
		Concurrence[{{1,0,0,1},{0,0,0,0},{0,0,0,0},{1,0,0,1}}/2]===1,
		Concurrence[{{2,0,0,1},{0,1,0,0},{0,0,1,0},{1,0,0,2}}/6]===0
	]];


TestCase["QuantumSystems:EntanglementF",
	And[
		EntanglementF[{{1,0,0,1},{0,0,0,0},{0,0,0,0},{1,0,0,1}}/2]===1,
		EntanglementF[{{2,0,0,1},{0,1,0,0},{0,0,1,0},{1,0,0,2}}/6]===0
	]];


(* ::Subsection::Closed:: *)
(*Random Matrices*)


TestCase["QuantumSystems:RandomDensity",
	And[
		AllQ[And[Chop[Tr[#]-1]===0,AllQ[#>=0&,Chop@Eigenvalues[#]]]&,
			{RandomDensity[4],RandomDensity[4,1],
			RandomDensity[4,"HS"],RandomDensity[4,1,"HS"],
			RandomDensity[4,"Bures"],RandomDensity[4,1,"Bures"]}],
		Norm@Chop[Eigenvalues[RandomDensity[4,1]]-{1,0,0,0}]===0
	]];


TestCase["QuantumSystems:RandomUnitary",
	0===Norm@Chop[IdentityMatrix[4]-ConjugateTranspose[#].#&@RandomUnitary[4]]
	];


TestCase["QuantumSystems:RandomHermitian",
	0===Norm@Chop[#-ConjugateTranspose[#]&@RandomHermitian[4]]
	];


(* ::Subsection::Closed:: *)
(*End*)


End[];


(* ::Section::Closed:: *)
(*End Package*)


Protect[Spin,Cavity,QState,KetForm,VecForm,Ket,Bra,KetBra];
Protect[Op,QPower,QExpand,QSimplifyIdentity,QSimplifyPower,QSimplifyNormalOrder,QSimplifyComAlgebra,QSimplifyAlgebra,QSimplify,ClearQSimplifyCache];
Protect[CGate];
Protect[EntropyH,EntropyS,RelativeEntropyS,MutualInformationS];
Protect[Purity,PNorm,Fidelity,EntangledQ,Concurrence,EntanglementF];
Protect[RandomUnitary,RandomDensity,RandomHermitian];


EndPackage[];
