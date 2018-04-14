%macro env(url);

filename out temp;
filename map temp;
filename map_re temp;
proc http url="&url"
method="get" out=out;
run;
libname raw xmlv2 xmlfileref=out xmlmap=map automap=replace;

	data map;
	 infile map dsd  lrecl=999999999;
	 input raw: $2000.@@;
	run;

	data map_re;
	set map;
	if index(raw,'<LENGTH>')^=0 then raw='<LENGTH>2000</LENGTH>';
	run;

	data _null_;
	set map_re;
	file map_re;
	put raw;
	run;

libname raw xmlv2 xmlfileref=out xmlmap=map_re;

data &lib .data;
set raw.data;
run;

%mend;
