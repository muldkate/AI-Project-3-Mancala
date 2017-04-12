
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
	value winlosstie 0 = 'Win'
					1 = 'Loss'
					2 = 'Tie';
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
	Label WinnerNum ='Game Winner' FinishedFirst ='Finished First' Player1='Player 1';
run;

ods rtf text='Player 1 vs Player 2 Statistics';
proc sort  data=matchdata out=overall;
	by MatchName WinnerNum;
run;

proc freq data=work.overall;
	tables WinnerNum   / crosslist out=overallfreq;
	title 'Overall - Win Counts and Percentages';
	Label WinnerNum ='Game Winner';
run;

data work.overallfreq;
	set work.overallfreq;
	pct_prop = percent / 100;
run;

proc sgplot data=overallfreq noautolegend;
	vbar WinnerNum / response=pct_prop 
		groupdisplay=cluster datalabel dataskin=pressed;
	format WinnerNum gameoutcome. pct_prop PERCENTN10.1;
	label WinnerNum ='Game Winner' pct_prop='Percentage of Games';
	title 'Overall - Player1 vs Player2 Comparison';
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
		groupdisplay=cluster datalabel dataskin=pressed;
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
	tables Player1*WinnerNum   / crosslist OUTPCT out=randomvvectorfreq;
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

proc sgpanel data=randomvvectorfreq;
	panelby Player1;
	vbar WinnerNum / response=pct_row_prop groupdisplay=cluster datalabel dataskin=pressed ;
	format pct_row_prop PERCENT10.2;
	label WinnerNum ='Game Winner' pct_row_prop='Percentage of Games';
	title 'RandomAI vs VectorAI - Player1 vs Player2 Comparison';
run; 

proc sgplot data=randomvvectorfreq2;
	vbar Winner / response=percent_prop datalabel dataskin=pressed;
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
		groupdisplay=cluster datalabel dataskin=pressed;
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
	tables Player1*WinnerNum   / crosslist OUTPCT out=leftmostvrandomfreq;
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

proc sgpanel data=leftmostvrandomfreq;
	panelby Player1;
	vbar WinnerNum / response=pct_row_prop groupdisplay=cluster datalabel dataskin=pressed ;
	format pct_row_prop PERCENT10.2;
	label WinnerNum ='Game Winner' pct_row_prop='Percentage of Games';
	title 'LeftmostAI vs RandomAI - Player1 vs Player2 Comparison';
run; 

proc sgplot data=leftmostvrandomfreq2;
	vbar Winner / response=percent_prop datalabel dataskin=pressed;
	format percent_prop PERCENT10.2;
	label  Winner ='Game Winner' percent_prop='Percentage of Games';
	title 'LeftmostAI vs RandomAI - Win Loss Comparison';
run;

/* LeftmostAI vs VectorAI */
ods rtf text='LeftmostAI vs VectorAI Statistics';
proc sort  data=matchdata out=leftmostvvector;
	where matchgroup = 4;
	by MatchName WinnerNum;
run;

proc freq data=work.leftmostvvector;
	tables Player1*WinnerNum   / crosslist OUTPCT out=leftmostvvectorfreq;
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

proc sgpanel data=leftmostvvectorfreq;
	panelby Player1;
	vbar WinnerNum / response=pct_row_prop  datalabel dataskin=pressed ;
	format pct_row_prop PERCENT10.2;
	label WinnerNum ='Game Winner' pct_row_prop='Percentage of Games';
	title 'LeftmostAI vs VectorAI - Player1 vs Player2 Comparison';
run; 

proc sgplot data=leftmostvvectorfreq2;
	vbar Winner / response=percent_prop datalabel dataskin=pressed;
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
	vbar WinnerNum / response=pct_row_prop datalabel dataskin=pressed;
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
	tables Player1*WinnerNum   / crosslist OUTPCT out=rightmostvrandomfreq;
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

proc sgpanel data=rightmostvrandomfreq;
	panelby Player1;
	vbar WinnerNum / response=pct_row_prop datalabel dataskin=pressed ;
	format pct_row_prop PERCENT10.2;
	label WinnerNum ='Game Winner' pct_row_prop='Percentage of Games';
	title 'RightmostAI vs RandomAI - Player1 vs Player2 Comparison';
run; 

proc sgplot data=rightmostvrandomfreq2;
	vbar Winner / response=percent_prop datalabel dataskin=pressed;
	format percent_prop PERCENT10.2;
	label  Winner ='Game Winner' percent_prop='Percentage of Games';
	title 'RightmostAI vs RandomAI - Win Loss Comparison';
run;

/* RightmostAI vs VectorAI */
ods rtf text='RightmostAI vs VectorAI Statistics';
proc sort  data=matchdata out=rightmostvvector;
	where matchgroup = 7;
	by MatchName WinnerNum;
run;

proc freq data=work.rightmostvvector;
	tables Player1*WinnerNum   / crosslist OUTPCT out=rightmostvvectorfreq;
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

proc sgpanel data=rightmostvvectorfreq;
	panelby Player1;
	vbar WinnerNum / response=pct_row_prop datalabel dataskin=pressed ;
	format pct_row_prop PERCENT10.2;
	label WinnerNum ='Game Winner' pct_row_prop='Percentage of Games';
	title 'RightmostAI vs VectorAI - Player1 vs Player2 Comparison';
run; 

proc sgplot data=rightmostvvectorfreq2;
	vbar Winner / response=percent_prop datalabel dataskin=pressed;
	format percent_prop PERCENT10.2;
	label  Winner ='Game Winner' percent_prop='Percentage of Games';
	title 'RightmostAI vs VectorAI - Win Loss Comparison';
run;

/* RightmostAI vs LeftmostAI */
ods rtf text='RightmostAI vs LeftmostAI Statistics';
proc sort  data=matchdata out=rightmostvleftmost;
	where matchgroup = 8;
	by MatchName WinnerNum;
run;

proc freq data=work.rightmostvleftmost;
	tables Player1*WinnerNum   / crosslist OUTPCT out=rightmostvleftmostfreq;
	tables Winner / out=work.rightmostvleftmostfreq2;
	title 'RightmostAI vs LeftmostAI - Win Counts and Percentages';
	Label WinnerNum ='Game Winner';
run;

data work.rightmostvleftmostfreq;
	set work.rightmostvleftmostfreq;
	pct_row_prop = pct_row / 100;
	percent_prop = percent /100;
run;

data work.rightmostvleftmostfreq2;
	set work.rightmostvleftmostfreq2;
	percent_prop = percent /100;
run;

proc sgpanel data=rightmostvleftmostfreq;
	panelby Player1;
	vbar WinnerNum / response=pct_row_prop datalabel dataskin=pressed ;
	format pct_row_prop PERCENT10.2;
	label WinnerNum ='Game Winner' pct_row_prop='Percentage of Games';
	title 'RightmostAI vs LeftmostAI - Player1 vs Player2 Comparison';
run; 

proc sgplot data=rightmostvleftmostfreq2;
	vbar Winner / response=percent_prop categoryorder=respdesc datalabel dataskin=pressed;
	format percent_prop PERCENT10.2;
	label  Winner ='Game Winner' percent_prop='Percentage of Games';
	title 'RightmostAI vs LeftmostAI - Win Loss Comparison';
run;

/* RightmostAI */
ods rtf text='RightmostAI vs RightmostAI Statistics';
proc sort  data=matchdata out=rightmostvrightmost;
	where matchgroup = 9;
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
		groupdisplay=cluster datalabel dataskin=pressed;
	format WinnerNum gameoutcome. pct_row_prop PERCENTN10.1;
	label WinnerNum ='RightmostAI vs RightmostAI' pct_row_prop='Percentage of Games';
	title 'RightmostAI - Player1 vs Player2 Comparison';
run; 

/* Number of Turns Per Game */
ods rtf text='Number of Turns Per Game';
proc univariate data=work.matchdata noprint;
	histogram NumTurns / endpoints = 0 to 100 by 2;
	inset n mean median std min max / position=NE;
	title "Number of Turns Per Game";
	label NumTurns='Number of Turns';
run;

proc univariate data=work.matchdata noprint;
	by MatchGroup;
	histogram NumTurns / endpoints = 0 to 100 by 2 vaxis=0 to 100 by 10;
	inset n mean median std min max / position=NE;
	title "Number of Turns Per Game";
	label NumTurns='Number of Turns' matchgroup='Match';
	format MatchGroup matchgroupfmt.;
run;

/* Finished first vs Winner */
ods rtf text='Finished first vs Winner Comparison - All Games';
title 'Finished First vs Winner Comparison  - All Games';
proc freq data=work.matchdata;
	tables FinishedFirstNum * WinnerNum / crosslist nocol  norow outpct out=work.finishedfirstfreq;
	title 'Finished First vs Winner Comparison  - All Games';
run;

data work.finishedfirstfreq;
	set work.finishedfirstfreq;
	percent_prop = percent / 100;
run;

proc sgpanel data=work.finishedfirstfreq;
	panelby FinishedFirstNum;
	vbar WinnerNum / response=percent_prop datalabel dataskin=pressed ;
	title 'Finished First vs Winner Comparison';
	label FinishedFirstNum='Finished First' percent_prop = 'Percentage';
	format percent_prop PERCENTN10.1;
run;

/* Wins, Losses, Ties Overall */
data work.winslosses work.check;
	set matchdata;
	if Player1 = Winner then do;
		PlayerName = Player1;
		WinLoss = 0;
		output work.winslosses;
		PlayerName = Player2;
		WinLoss = 1;
		output work.winslosses;
	end;
	else if Player2 = Winner then do;
		PlayerName = Player2;
		WinLoss = 0;
		output work.winslosses;
		PlayerName = Player1;
		WinLoss = 1;
		output work.winslosses;
	end;
	else if 'Tie' = Winner then do;
		PlayerName = Player2;
		WinLoss = 2;
		output work.winslosses;
		PlayerName = Player1;
		WinLoss = 2;
		output work.winslosses;
	end;
	keep PlayerName WinLoss ;
run;

proc freq data=work.WINSLOSSES;
	table PlayerName*WinLoss / outpct out=winslossesfreq;
run;

data work.winslossesfreq;
	set work.winslossesfreq;
	pct_row_prop = pct_row / 100;
run;

data attrmap;
   input id $ value $ fillcolor $ ;
   datalines;
WinLoss Win Green    
WinLoss Loss Red 
WinLoss Tie Blue     
;
run;

proc sgpanel data=work.winslossesfreq dattrmap=attrmap;
	panelby PlayerName / columns=4 rows=1 NOVARNAME;
	vbar WinLoss / response=pct_row_prop datalabel dataskin=pressed attrid=WinLoss;
	format WinLoss winlosstie. pct_row_prop PERCENTN10.1;
	label pct_row_prop='Percentage' WinLoss='Game Outcomes' PlayerName='Player Name';
	title 'Overall - Wins vs Losses vs Ties';
run;

ods rtf close;