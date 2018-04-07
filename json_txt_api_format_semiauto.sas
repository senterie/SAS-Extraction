%let dir=C:\json\;
%let lib=C:\json\; 
%let filename=SeriesDataOut.txt;
%let year_s=1993;  
%let year_e=2017;
%let data_final=Format_test;
%let var_want=PRD_DE/*연도*/ C1 C1_NM C2/*성별*/ C3_NM/*연령*/ DT/*수*/;/*원하는 변수만 남기기*/
libname json "&lib"; 



/*테이블 하나 만들기(초기 데이터)_start*/
%let url=
http://openapi.openfiscaldata.go.kr/DepartRevenExpenSettle?FSCL_YY=2013
;

filename out "&dir&filename" recfm=v lrecl=999999999;
proc http out=out url="&url" method="post" ct="application/json";
run;

data "&lib.raw";
 infile "&dir&filename" dsd  lrecl=999999999 dlm='{}[]:,';
 input raw : $2000.@@;
run;

data "&lib.temp";
 merge "&lib.raw" "&lib.raw"(firstobs=2 rename=(raw=_raw));
 if mod(_n_,2) eq 0;
run;

data "&lib.temp";
 set "&lib.temp";
 if raw='' then group+1;
run;

proc transpose data="&lib.temp" out="&lib.data_one"(drop=_:);
by group;
id raw;
var _raw;
run;

data "&lib.data_one";set "&lib.data_one"(keep=&var_want);run;
/*테이블 하나 만들기(초기 데이터)_end*/



data "&lib.&data_final";set "&lib.data_one";run;/*초기 데이터(변수 확인용) 연속형 테이블로 바꾸기*/



	/*초기 데이터에 원하는 연도까지 데이터 합치기_start*/
	%macro json;
	%do year=&year_s+1 %to &year_e;

	/*주소*/
	%let url=
	http://kosis.kr/openapi/statisticsData.do?method=getList&apiKey=NjdhZTg3ZTM1OGEzZGMyOGIyZWE0ZmIxZTBiMDg0ZTg=&format=json&jsonVD=Y&userStatsId=idencosmos/101/DT_1B040M1/2/1/20180323133026&prdSe=Y&startPrdDe=&year&endPrdDe=&year
	;
	/*주소*/

	filename out "&dir&filename" recfm=v lrecl=999999999;
	proc http out=out url="&url" method="post" ct="application/json";
	run;

	data "&lib.raw";
	infile "&dir&filename" dsd lrecl=999999999 dlm='{}[]:,';
	input raw : $2000.@@;
	run;

	data "&lib.temp";
	merge "&lib.raw" "&lib.raw"(firstobs=2 rename=(raw=_raw));
	if mod(_n_,2) eq 1;
	run;

	data "&lib.temp";
	set "&lib.temp";
	if raw='' then group+1;
	run;

	proc transpose data="&lib.temp" out="&lib.data_one"(drop=_:);
	by group;
	id raw;
	var _raw;
	run;

	data "&lib.data_one";set "&lib.data_one"(keep=&var_want);run;

	data "&lib.&data_final";
	set "&lib.&data_final" "&lib.data_one";
	run;

	%end;
	%mend json;
	%json
	/*초기 데이터에 원하는 연도까지 데이터 합치기_end*/



/*변수명, 변수 형태 변경_start*/
data "&lib.&data_final";
set "&lib.&data_final";
Year=PRD_DE+0;/*연도*/
Div_num=C1;
Div=C1_NM;
Sex=C2+0;/*성별*/
Old=C3_NM;/*연령*/
Num=DT+0;/*수*/
keep Year Div_num Div Old Num;
run;
/*변수명, 변수 형태 변경_end*/
