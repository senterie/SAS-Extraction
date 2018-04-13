%LET lib=C:\Work01\; 
%LET filename=01.xlsx;
%LET NofTotalVar= 16;  
%LET NofFixVar= 2;  
%LET StartVar= 3;   
libname c "&lib"; 
FILENAME IMPDATA "&lib&filename";


proc import datafile=IMPDATA DBMS =xlsx replace out=c.tp1;sheet = "data";run;
proc import datafile=IMPDATA DBMS =xlsx replace out=c.label;sheet = "label";run;

data c.label1;set c.label;	format label1 $char30. label2 $char30. label $char60. sep $char1.;sep='^';label=catx(sep,label1,label2);drop sep;run;	

FILENAME GENCODE1"&lib.gencode1.sas";
DATA _NULL_;SET  C.label1 END=eof;FILE gencode1;IF _n_ = 1 THEN DO;PUT     "Data c.tp2;set c.tp1;format v&StartVar-v&NofTotalVar;";end;put var "=PUT("v", 30.3);";if eof then put "keep var1-var&NofTotalVar;run;";run;
%include gencode1; 

FILENAME GENCODE2  "&lib.gencode2.sas";
DATA _NULL_;SET  C.label1 END=eof;FILE gencode2;IF _n_ = 1 THEN DO;PUT "proc datasets LIB=C nolist;modify tp2;";end;if indexc(label,"'")=0 then put "label "var" ='"label"';";if eof then put "quit;";run;
%include gencode2;

data raw;set c.tp2;array all var&StartVar-var&NofTotalVar;do i=1 to dim(all);value1=all[i];label=vlabel(all(i));output;end;keep var1-var&NofFixVar i value1 label;run;
data c.longdata;set raw;label1=scan(label,1,'^');label2=scan(label,2,'^');if value1 = "-" or "."  then value1="";value=input(value1, 30.);keep var1-var&NofFixVar label1 label2 value;run;

proc tabulate data=c.LongData out=c.Final;class var1-var&NofFixVar label1 label2;var value;table var1=""*var2="", label2=""*label1=""*value="";run; 


