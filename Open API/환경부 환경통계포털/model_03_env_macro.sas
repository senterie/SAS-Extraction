%macro env(url);

filename out temp;
proc http url="&url"
method="get" out=out;
run;
libname raw xmlv2 xmlfileref=out xmlmap="&dir\xml.map" automap=replace;

	proc import datafile="&dir\xml.map" out=map dbms=dlm replace;
	getnames=no;
	run;

	data map;
	 infile "&dir\xml.map" dsd  lrecl=999999999;
	 input raw: $2000.@@;
	run;

	data map_re;
	set map;
	if index(raw,'<LENGTH>')^=0 then raw='<LENGTH>2000</LENGTH>';
	run;

	data _null_;
	set map_re;
	file "&dir\xml.map_re";
	put raw;
	run;

libname raw xmlv2 xmlfileref=out xmlmap="&dir\xml.map_re";

data &lib .data;
set raw.data;
run;

%mend;
