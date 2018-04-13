%LET lib=D:\OneDrive - 서울대학교\01. 학습\서울대학교\행정대학원\Lecture\2018.01.01\3.1 특강(정책 의사결정과 사회통계)\Work02\;
%LET filename=01.xlsx;
%LET NofTotalVar=22;
%LET NofFixVar= 4;
%LET StartVar= 5;
libname Work02 "&lib";
FILENAME IMPDATA "&lib&filename";

proc import datafile=IMPDATA DBMS=xlsx replace out=Work02.tp1;sheet="data";run;
proc import datafile=IMPDATA DBMS=xlsx replace out=Work02.label;sheet="label";run;

FILENAME GENCODE1"&lib.gencode1.sas";
DATA _NULL_;SET Work02.label END=eof;FILE gencode1;IF _n_=1 THEN DO;PUT"Data Work02.tp2;set Work02.tp1;format v&StartVar-v&NofTotalVar;";end;put var"=PUT(" v", 30.3);";if eof then put "keep var1-var&NofTotalVar;run;";run;
%include gencode1; 

FILENAME GENCODE2  "&lib.gencode2.sas";
DATA _NULL_;SET Work02.label END=eof;FILE gencode2;IF _n_=1 THEN DO;PUT"proc datasets LIB=Work02 nolist;modify tp2;";end;if indexc(label1,"'")=0 then put" label " var"='" label1"';";if eof then put "quit;";run;
%include gencode2;

/*DATA _NULL_ 데이터를 만들지는 마라*/

data raw;set Work02.tp2;array all var&StartVar-var&NofTotalVar;do i=1 to dim(all);value1=all[i];label=vlabel(all(i));output;end;keep var1-var&NofFixVar i value1 label;run;

data Work02.longdata;set raw;format var3$char30.var4$char30.label0$char60.;if var4="" then label0=catx(" ",var3,var4);else label0=cats(var3,"(",var4,")");value=input(value1, 30.);keep var1 var2 label0 label value;run;

proc tabulate data=Work02.LongData out=Work02.Final;class var1 var2 label0 label;var value;	table var1=""*var2="", label=""*label0=""*value="";run; 
