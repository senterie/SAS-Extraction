%let lib=C:\Json\; 
libname json "&lib";
%let url01=http://kosis.kr/openapi/statisticsList.do?method=getList;
%let url02=NjdhZTg3ZTM1OGEzZGMyOGIyZWE0ZmIxZTBiMDg0ZTg=;/*apiKey*/

%macro KOSIS_LIST(url03);

filename out temp;proc http url="&url01&apiKey=&url02&vwCd=&url03&format=json&jsonVD=Y" method="get" out=out;run;
libname raw json fileref=out;

data &url03._list;
set raw.root;
LIST_URL=cats("&url01&apiKey=&url02&vwCd=&url03&parentListId=",LIST_ID,"&format=json&jsonVD=Y");
run;

%mend;

%KOSIS_LIST(url03=MT_ZTITLE);
