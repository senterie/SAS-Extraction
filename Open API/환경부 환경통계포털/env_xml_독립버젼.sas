%let lib=C:\Xml\;
libname xml "&lib";

filename out temp;
proc http url=http://stat.me.go.kr/nesis/mesp/searchApi/searchApiMainAction.do?task=C&key=8NfRsp8czHw0JtyP5AQ5Yg%3D%3D&tblID=DT_106N_03_0200145&startDate=201501&endDate=201704&dateType=M&point=default&dataType=data
method="get" out=out;
run;
libname raw xmlv2 xmlfileref=out xmlmap="&lib\xmlmap.map" automap=replace;

data "&lib.data";
set raw.data;
run;

