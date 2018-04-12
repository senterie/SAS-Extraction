%macro env(url);

data test;
url=tranwrd("&url",'key=',"key=&apiKey");
call symput('url_full',url);
run;

filename out temp;
proc http url="&url_full"
method="get" out=out;
run;
libname raw xmlv2 xmlfileref=out xmlmap="&lib\xmlmap.map" automap=replace;

data "&lib.data";
set raw.data;
run;

%mend;
