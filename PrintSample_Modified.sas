/* Selection options are FIRST (first rows) or RANDOM (random sample) */
%let selection=RANDOM;
%let table=sashelp.cars;
%let nrows=20;
%let varlist=_all_;


/* GET TOTAL ROW COUNT FROM TABLE */
	
	proc sql noprint;
	    select count(*) format=comma15. into :N from &table;
	quit;

/* SELECT FIRST n ROWS */
%if &selection=FIRST %then %do;
	title1 color="#545B66" "Sample from &table";
	title2 height=3 "First &nrows of &N Rows";
	data sample;
	    set &table(obs=&nrows keep=&varlist);
	run;
%end;

/* SELECT RANDOM SAMPLE OF &nrows ROWS */

%else %do;
	title1 color="red" "Sample from &table";
	title2 height=3 "Random Sample &nrows of &N Rows";
	
	proc surveyselect data=&table(keep=&varlist) 
	                  method=srs n=&nrows
	                  out=sample noprint;
	run;  
%end; 

/* PRINT SAMPLE */

	footnote height=3 "Created %sysfunc(today(),nldatew.) at %sysfunc(time(), nltime.)";
	proc print data=sample noobs;
	run;
	title;
	footnote;