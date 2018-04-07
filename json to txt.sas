%let url=https://api.bls.gov/publicAPI/v2/timeseries/data/;
filename in  "c:\somepath\SeriesIn_ex.txt";
filename out "c:\somepath\SeriesDataOut_ex.txt" recfm=v lrecl=32000;
proc http in=in out=out url="&url" method="post" ct="application/json";
run;

data x;
 infile 'c:\somepath\SeriesDataOut_ex.txt' dsd lrecl=30000000 dlm='{}[]:,';
 input x : $2000.@@;
run;
data temp;
 merge x x(firstobs=2 rename=(x=_x));
 if lowcase(x) in ("year","period","periodname","value");
run;
data temp;
 set temp;
 if lowcase(x)='year' then group+1;
run;
proc transpose data=temp out=want(drop=_:);
by group;
id x;
var _x;
run;

