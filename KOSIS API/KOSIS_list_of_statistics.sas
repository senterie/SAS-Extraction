%let lib=C:\Json\; 
libname json "&lib";
%let url01=http://kosis.kr/openapi/statisticsList.do?method=getList;
%let url02=NjdhZTg3ZTM1OGEzZGMyOGIyZWE0ZmIxZTBiMDg0ZTg=;/*apiKey*/
%let url03=MT_ZTITLE

%let url=http://kosis.kr/openapi/statisticsList.do?method=getList&apiKey=NjdhZTg3ZTM1OGEzZGMyOGIyZWE0ZmIxZTBiMDg0ZTg=&vwCd=MT_ZTITLE&format=json&jsonVD=Y;

filename out temp;proc http url="&url" method="get" out=out;run;
libname raw json fileref=out;

proc datasets lib=raw;run;
proc print data=raw.alldata(obs=100); run;
proc print data=raw.root(obs=100); run;



proc sql;
create table json.List01 as
select b.*, &url01&apiKey=&url02&vwCd=&url03&parentListId=&format=json&jsonVD=Y
from raw.root as b;
run;
