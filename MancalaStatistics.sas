/* The following is the SAS program used to generate the graphs and statistics. Below is a list of matches that data was generated from. */
/*	RandomAI vs RandomAI
    VectorAI vs RandomAI
    VectorAI vs VectorAI
    LeftmostAI vs RandomAI
    LeftmostAI vs VectorAI
    LeftmostAI vs LeftmostAI
		RightmostAI vs RandomAI
    RightmostAI vs VectorAI
    RightmostAI vs LeftmostAI
    RightmostAI vs RightmostAI
	*/	
	
ods rtf file="W:\MyStat318\AI\output.doc" startpage=never gtitle;

proc format;
	value gameoutcome 0 = 'Tie'
					1 = 'Player 1'
					2 = 'Player 2'
					., -999 = 'Missing';
	value matchgroupfmt
					0 = 'RandomAI vs RandomAI'
					1 = 'VectorAI vs RandomAI'
					2 = 'VectorAI vs VectorAI'
					3 = 'LeftmostAI vs RandomAI'
					4 = 'LeftmostAI vs VectorAI'
					5 = 'LeftmostAI vs LeftmostAI'
					6 = 'RightmostAI vs RandomAI'
					7 = 'RightmostAI vs VectorAI'
					8 = 'RightmostAI vs LeftmostAI'
					9 = 'RightmostAI vs RightmostAI';
run;

/* Read in the data */
data matchdata;
	infile 'W:\MyStat318\AI\Data.txt' DLM=',';
	input MatchGroup Player1 : $20. Player2 : $20. FinishedFirstNum WinnerNum WinnerNumPieces NumTurns;

	if FinishedFirstNum = 1 then FinishedFirst = Player1;
	else FinishedFirst = Player2;

	if WinnerNum = 1 then Winner = Player1;
	else if WinnerNum = 2 then Winner = Player2;
	else if WinnerNum = 0 then Winner = 'Tie';

	if WinnerNum = 2 then Loser = Player1;
	else if WinnerNum = 1 then Loser = Player2;
	else if WinnerNum = 0 then Loser = 'Tie';

	MatchName = CATX(' vs ', OF Player1-Player2);

	format WinnerNum FinishedFirstNum gameoutcome. ;
	Label WinnerNum ='Game Winner' FinishedFirst ='Finished First';
run;

/* RandomAI - Base stats */
ods rtf text='RandomAI vs RandomAI Statistics';
proc sort  data=matchdata out=randomvrandom;
	where matchgroup = 0;
	by MatchName WinnerNum;
run;

proc freq data=work.randomvrandom;
	tables MatchName*WinnerNum   / crosslist norow nocol OUTPCT out=randomvrandomfreq;
	title 'RandomAI vs RandomAI - Win Counts and Percentages';
	Label WinnerNum ='Game Winner';
run;

data work.randomvrandomfreq;
	set work.randomvrandomfreq;
	pct_row_prop = pct_row / 100;
run;

proc sgplot data=randomvrandomfreq noautolegend;
	vbar WinnerNum / response=pct_row_prop group=MatchName 
		groupdisplay=cluster categoryorder=respdesc datalabel dataskin=pressed;
	format WinnerNum gameoutcome. pct_row_prop PERCENTN10.1;
	label WinnerNum ='RandomAI vs RandomAI' pct_row_prop='Percentage of Games';
	title 'RandomAI - Player1 vs Player2 Comparison';
run; 

/* RandomAI vs VectorAI */
ods rtf text='RandomAI vs VectorAI Statistics';
proc sort  data=matchdata out=randomvvector;
	where matchgroup = 1;
	by MatchName WinnerNum;
run;

proc freq data=work.randomvvector;
	tables MatchName*WinnerNum   / crosslist OUTPCT out=randomvvectorfreq;
	tables Winner / out=work.randomvvectorfreq2;
	title 'RandomAI vs VectorAI Win Counts and Percentages';
	Label WinnerNum ='Game Winner';
run;

data work.randomvvectorfreq;
	set work.randomvvectorfreq;
	pct_row_prop = pct_row / 100;
	percent_prop = percent /100;
run;

data work.randomvvectorfreq2;
	set work.randomvvectorfreq2;
	percent_prop = percent /100;
run;

proc sgplot data=randomvvectorfreq;
	vbar WinnerNum / response=pct_row_prop group=MatchName groupdisplay=cluster categoryorder=respdesc datalabel dataskin=pressed ;
	format pct_row_prop PERCENT10.2;
	label WinnerNum ='Game Winner' pct_row_prop='Percentage of Games';
	title 'RandomAI vs VectorAI - Player1 vs Player2 Comparison';
run; 

proc sgplot data=randomvvectorfreq2;
	vbar Winner / response=percent_prop categoryorder=respdesc datalabel dataskin=pressed;
	format percent_prop PERCENT10.2;
	label  Winner ='Game Winner' percent_prop='Percentage of Games';
	title 'RandomAI vs VectorAI - Win Loss Comparison';
run;

/* VectorAI vs VectorAI*/
ods rtf text='VectorAI vs VectorAI Statistics';
proc sort  data=matchdata out=vectorvvector;
	where matchgroup = 2;
	by MatchName WinnerNum;
run;

proc freq data=work.vectorvvector;
	tables MatchName*WinnerNum   / crosslist norow nocol OUTPCT out=vectorvvectorfreq;
	title 'VectorAI vs VectorAI - Win Counts and Percentages';
	Label WinnerNum ='Game Winner';
run;

data work.vectorvvectorfreq;
	set work.vectorvvectorfreq;
	pct_row_prop = pct_row / 100;
run;

proc sgplot data=vectorvvectorfreq noautolegend;
	vbar WinnerNum / response=pct_row_prop group=MatchName 
		groupdisplay=cluster categoryorder=respdesc datalabel dataskin=pressed;
	format WinnerNum gameoutcome. pct_row_prop PERCENTN10.1;
	label WinnerNum ='VectorAI vs VectorAI' pct_row_prop='Percentage of Games';
	Label WinnerNum ='Game Winner';
run;  

/* LeftmostAI vs RandomAI */
ods rtf text='LeftmostAI vs RandomAI Statistics';
proc sort  data=matchdata out=leftmostvrandom;
	where matchgroup = 3;
	by MatchName WinnerNum;
run;

proc freq data=work.leftmostvrandom;
	tables MatchName*WinnerNum   / crosslist OUTPCT out=leftmostvrandomfreq;
	tables Winner / out=work.leftmostvrandomfreq2;
	title 'LeftmostAI vs RandomAI - Win Counts and Percentages';
	Label WinnerNum ='Game Winner';
run;

data work.leftmostvrandomfreq;
	set work.leftmostvrandomfreq;
	pct_row_prop = pct_row / 100;
	percent_prop = percent /100;
run;

data work.leftmostvrandomfreq2;
	set work.leftmostvrandomfreq2;
	percent_prop = percent /100;
run;

proc sgplot data=leftmostvrandomfreq;
	vbar WinnerNum / response=pct_row_prop group=MatchName groupdisplay=cluster categoryorder=respdesc datalabel dataskin=pressed ;
	format pct_row_prop PERCENT10.2;
	label WinnerNum ='Game Winner' pct_row_prop='Percentage of Games';
	title 'LeftmostAI vs RandomAI - Player1 vs Player2 Comparison';
run; 

proc sgplot data=leftmostvrandomfreq2;
	vbar Winner / response=percent_prop categoryorder=respdesc datalabel dataskin=pressed;
	format percent_prop PERCENT10.2;
	label  Winner ='Game Winner' percent_prop='Percentage of Games';
	title 'RandomAI vs VectorAI - Win Loss Comparison';
run;

/* LeftmostAI vs VectorAI */
ods rtf text='LeftmostAI vs VectorAI Statistics';
proc sort  data=matchdata out=leftmostvvector;
	where matchgroup = 4;
	by MatchName WinnerNum;
run;

proc freq data=work.leftmostvvector;
	tables MatchName*WinnerNum   / crosslist OUTPCT out=leftmostvvectorfreq;
	tables Winner / out=work.leftmostvvectorfreq2;
	title 'LeftmostAI vs VectorAI - Win Counts and Percentages';
	Label WinnerNum ='Game Winner';
run;

data work.leftmostvvectorfreq;
	set work.leftmostvvectorfreq;
	pct_row_prop = pct_row / 100;
	percent_prop = percent /100;
run;

data work.leftmostvvectorfreq2;
	set work.leftmostvvectorfreq2;
	percent_prop = percent /100;
run;

proc sgplot data=leftmostvvectorfreq;
	vbar WinnerNum / response=pct_row_prop group=MatchName groupdisplay=cluster categoryorder=respdesc datalabel dataskin=pressed ;
	format pct_row_prop PERCENT10.2;
	label WinnerNum ='Game Winner' pct_row_prop='Percentage of Games';
	title 'LeftmostAI vs VectorAI - Player1 vs Player2 Comparison';
run; 

proc sgplot data=leftmostvvectorfreq2;
	vbar Winner / response=percent_prop categoryorder=respdesc datalabel dataskin=pressed;
	format percent_prop PERCENT10.2;
	label  Winner ='Game Winner' percent_prop='Percentage of Games';
	title 'LeftmostAI vs VectorAI - Win Loss Comparison';
run;

/* LeftmostAI vs LeftmostAI */
ods rtf text='LeftmostAI vs LeftmostAI Statistics';
proc sort  data=matchdata out=leftmostvleftmost;
	where matchgroup = 5;
	by MatchName WinnerNum;
run;

proc freq data=work.leftmostvleftmost;
	tables MatchName*WinnerNum   / crosslist norow nocol OUTPCT out=leftmostvleftmostfreq;
	title 'LeftmostAI vs LeftmostAI -  Win Counts and Percentages';
	Label WinnerNum ='Game Winner';
run;

data work.leftmostvleftmostfreq;
	set work.leftmostvleftmostfreq;
	pct_row_prop = pct_row / 100;
run;

proc sgplot data=leftmostvleftmostfreq noautolegend;
	vbar WinnerNum / response=pct_row_prop group=MatchName 
		groupdisplay=cluster categoryorder=respdesc datalabel dataskin=pressed;
	format WinnerNum gameoutcome. pct_row_prop PERCENTN10.1;
	label WinnerNum ='LeftmostAI vs LeftmostAI' pct_row_prop='Percentage of Games';
	title 'LeftmostAI - Player1 vs Player2 Comparison';
run; 

/* RightmostAI vs RandomAI */
ods rtf text='RightmostAI vs RandomAI Statistics';
proc sort  data=matchdata out=rightmostvrandom;
	where matchgroup = 6;
	by MatchName WinnerNum;
run;

proc freq data=work.rightmostvrandom;
	tables MatchName*WinnerNum   / crosslist OUTPCT out=rightmostvrandomfreq;
	tables Winner / out=work.rightmostvrandomfreq2;
	title 'RightmostAI vs RandomAI Win Counts and Percentages';
	Label WinnerNum ='Game Winner';
run;

data work.rightmostvrandomfreq;
	set work.rightmostvrandomfreq;
	pct_row_prop = pct_row / 100;
	percent_prop = percent /100;
run;

data work.rightmostvrandomfreq2;
	set work.rightmostvrandomfreq2;
	percent_prop = percent /100;
run;

proc sgplot data=rightmostvrandomfreq;
	vbar WinnerNum / response=pct_row_prop group=MatchName groupdisplay=cluster categoryorder=respdesc datalabel dataskin=pressed ;
	format pct_row_prop PERCENT10.2;
	label WinnerNum ='Game Winner' pct_row_prop='Percentage of Games';
	title 'RightmostAI vs RandomAI - Player1 vs Player2 Comparison';
run; 

proc sgplot data=rightmostvrandomfreq2;
	vbar Winner / response=percent_prop categoryorder=respdesc datalabel dataskin=pressed;
	format percent_prop PERCENT10.2;
	label  Winner ='Game Winner' percent_prop='Percentage of Games';
	title 'RightmostAI vs RandomAI - Win Loss Comparison';
run;

/* RightmostAI vs VectorAI */
ods rtf text='Rightmost vs VectorAI Statistics';
proc sort  data=matchdata out=rightmostvvector;
	where matchgroup = 7;
	by MatchName WinnerNum;
run;

proc freq data=work.rightmostvvector;
	tables MatchName*WinnerNum   / crosslist OUTPCT out=rightmostvvectorfreq;
	tables Winner / out=work.rightmostvvectorfreq2;
	title 'RightmostAI vs VectorAI - Win Counts and Percentages';
	Label WinnerNum ='Game Winner';
run;

data work.rightmostvvectorfreq;
	set work.rightmostvvectorfreq;
	pct_row_prop = pct_row / 100;
	percent_prop = percent /100;
run;

data work.rightmostvvectorfreq2;
	set work.rightmostvvectorfreq2;
	percent_prop = percent /100;
run;

proc sgplot data=rightmostvvectorfreq;
	vbar WinnerNum / response=pct_row_prop group=MatchName groupdisplay=cluster categoryorder=respdesc datalabel dataskin=pressed ;
	format pct_row_prop PERCENT10.2;
	label WinnerNum ='Game Winner' pct_row_prop='Percentage of Games';
	title 'RightmostAI vs VectorAI - Player1 vs Player2 Comparison';
run; 

proc sgplot data=rightmostvvectorfreq2;
	vbar Winner / response=percent_prop categoryorder=respdesc datalabel dataskin=pressed;
	format percent_prop PERCENT10.2;
	label  Winner ='Game Winner' percent_prop='Percentage of Games';
	title 'RightmostAI vs VectorAI - Win Loss Comparison';
run;

/* RightmostAI vs LeftmostAI */
ods rtf text='Rightmost vs VectorAI Statistics';
proc sort  data=matchdata out=rightmostvleftmost;
	where matchgroup = 7;
	by MatchName WinnerNum;
run;

proc freq data=work.rightmostvleftmost;
	tables MatchName*Winner   / crosslist OUTPCT out=rightmostvleftmostfreq;
	tables Winner / out=work.rightmostvleftmostfreq2;
	title 'RightmostAI vs LeftmostAI - Win Counts and Percentages';
	Label WinnerNum ='Game Winner';
run;

data work.rightmostvleftmostfreq;
	set work.rightmostvvectorfreq;
	pct_row_prop = pct_row / 100;
	percent_prop = percent /100;
run;

data work.rightmostvleftmostfreq2;
	set work.rightmostvvectorfreq2;
	percent_prop = percent /100;
run;

proc sgplot data=rightmostvleftmostfreq;
	vbar WinnerNum / response=pct_row_prop group=MatchName groupdisplay=cluster categoryorder=respdesc datalabel dataskin=pressed ;
	format pct_row_prop PERCENT10.2;
	label WinnerNum ='Game Winner' pct_row_prop='Percentage of Games';
	title 'RightmostAI vs LeftmostAI - Player1 vs Player2 Comparison';
run; 

proc sgplot data=randomvvectorfreq2;
	vbar Winner / response=percent_prop categoryorder=respdesc datalabel dataskin=pressed;
	format percent_prop PERCENT10.2;
	label  Winner ='Game Winner' percent_prop='Percentage of Games';
	title 'RightmostAI vs LeftmostAI - Win Loss Comparison';
run;

/* RightmostAI */
ods rtf text='RightmostAI vs RightmostAI Statistics';
proc sort  data=matchdata out=rightmostvrightmost;
	where matchgroup = 0;
	by MatchName WinnerNum;
run;

proc freq data=work.rightmostvrightmost;
	tables MatchName*WinnerNum   / crosslist norow nocol OUTPCT out=rightmostvrightmostfreq;
	title 'RightmostAI vs RightmostAI - Win Counts and Percentages';
	Label WinnerNum ='Game Winner';
run;

data work.rightmostvrightmostfreq;
	set work.rightmostvrightmostfreq;
	pct_row_prop = pct_row / 100;
run;

proc sgplot data=rightmostvrightmostfreq noautolegend;
	vbar WinnerNum / response=pct_row_prop group=MatchName 
		groupdisplay=cluster categoryorder=respdesc datalabel dataskin=pressed;
	format WinnerNum gameoutcome. pct_row_prop PERCENTN10.1;
	label WinnerNum ='RandomAI vs RandomAI' pct_row_prop='Percentage of Games';
	title 'RightmostAI - Player1 vs Player2 Comparison';
run; 

/* # Turns */
ods rtf text='Number of Turns Per Game';
proc univariate data=work.matchdata noprint;
	histogram NumTurns / endpoints = 0 to 100 by 2;
	inset n mean median std min max / position=NE;
	title "Number of Turns Per Game";
	label NumTurns='Number of Turns';
run;

/* Finished first vs Winner */
ods rtf text='Finished first vs Winner Comparison - All Games';
title 'Finished First vs Winner Comparison  - All Games';
proc freq data=work.matchdata;
	tables FinishedFirstNum * WinnerNum / crosslist nocol  norow outpct out=work.finishedfirstfreq;
	title 'Finished First vs Winner Comparison  - All Games';
run;

proc sgplot data=work.finishedfirstfreq;
	vbar WinnerNum / response=percent group=FinishedFirstNum groupdisplay=cluster categoryorder=respdesc datalabel dataskin=pressed ;
	title 'Finished First vs Winner Comparison';
run;

proc freq data=work.matchdata;
	by MatchGroup;
	tables FinishedFirstNum * WinnerNum  / crosslist outpct out=work.finishedfirstfreq2 nocol norow;
	title 'Finished First vs Winner Comparison';
	format MatchGroup matchgroupfmt.;
run;

data work.finishedfirstfreq2;
	set work.finishedfirstfreq2;
	percent_prop = percent / 100;
run;

proc sgplot data=work.finishedfirstfreq2;
	where MatchGroup = 0;
	vbar WinnerNum / response=percent_prop group=FinishedFirstNum groupdisplay=cluster categoryorder=respdesc 
		datalabel dataskin=pressed;
	format percent_prop PERCENTN10.1;
	title 'RandomAI vs RandomAI - Finished First vs Winner Comparison';
run;

proc sgplot data=work.finishedfirstfreq2;
	where MatchGroup = 1;
	vbar WinnerNum / response=percent_prop group=FinishedFirstNum groupdisplay=cluster categoryorder=respdesc 
		datalabel dataskin=pressed;
	format percent_prop PERCENTN10.1;
	title 'VectorAI vs RandomAI - Finished First vs Winner Comparison';
run;

proc sgplot data=work.finishedfirstfreq2;
	where MatchGroup = 2;
	vbar WinnerNum / response=percent_prop group=FinishedFirstNum groupdisplay=cluster categoryorder=respdesc 
		datalabel dataskin=pressed;
	format percent_prop PERCENTN10.1;
	title 'VectorAI vs VectorAI - Finished First vs Winner Comparison';
run;

proc sgplot data=work.finishedfirstfreq2;
	where MatchGroup = 3;
	vbar WinnerNum / response=percent_prop group=FinishedFirstNum groupdisplay=cluster categoryorder=respdesc 
		datalabel dataskin=pressed;
	format percent_prop PERCENTN10.1;
	title 'LeftmostAI vs RandomAI - Finished First vs Winner Comparison';
run;

proc sgplot data=work.finishedfirstfreq2;
	where MatchGroup = 4;
	vbar WinnerNum / response=percent_prop group=FinishedFirstNum groupdisplay=cluster categoryorder=respdesc 
		datalabel dataskin=pressed;
	format percent_prop PERCENTN10.1;
	title 'LeftmostAI vs VectorAI - Finished First vs Winner Comparison';
run;

proc sgplot data=work.finishedfirstfreq2;
	where MatchGroup = 5;
	vbar WinnerNum / response=percent_prop group=FinishedFirstNum groupdisplay=cluster categoryorder=respdesc 
		datalabel dataskin=pressed;
	format percent_prop PERCENTN10.1;
	title 'LeftmostAI vs LeftmostAI - Finished First vs Winner Comparison';
run;

proc sgplot data=work.finishedfirstfreq2;
	where MatchGroup = 6;
	vbar WinnerNum / response=percent_prop group=FinishedFirstNum groupdisplay=cluster categoryorder=respdesc 
		datalabel dataskin=pressed;
	format percent_prop PERCENTN10.1;
	title 'RightmostAI vs RandomAI - Finished First vs Winner Comparison';
run;

proc sgplot data=work.finishedfirstfreq2;
	where MatchGroup = 7;
	vbar WinnerNum / response=percent_prop group=FinishedFirstNum groupdisplay=cluster categoryorder=respdesc 
		datalabel dataskin=pressed;
	format percent_prop PERCENTN10.1;
	title 'RightmostAI vs VectorAI - Finished First vs Winner Comparison';
run;

proc sgplot data=work.finishedfirstfreq2;
	where MatchGroup = 8;
	vbar WinnerNum / response=percent_prop group=FinishedFirstNum groupdisplay=cluster categoryorder=respdesc 
		datalabel dataskin=pressed;
	format percent_prop PERCENTN10.1;
	title 'RightmostAI vs LeftmostAI - Finished First vs Winner Comparison';
run;

proc sgplot data=work.finishedfirstfreq2;
	where MatchGroup = 9;
	vbar WinnerNum / response=percent_prop group=FinishedFirstNum groupdisplay=cluster categoryorder=respdesc 
		datalabel dataskin=pressed;
	format percent_prop PERCENTN10.1;
	title 'RightmostAI vs RightmostAI - Finished First vs Winner Comparison';
run;

ods rtf close;