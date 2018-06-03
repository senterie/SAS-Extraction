%macro env(url);

filename out temp;
proc http url="&url"
method="get" out=out;
run;
libname raw xmlv2 xmlfileref=out xmlmap="&lib\xmlmap.map" automap=replace outencoding="euc-kr";

data "&lib.data";
set raw.data;
run;

%mend;
