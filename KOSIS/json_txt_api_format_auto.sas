%let dir=C:\json\;
%let lib=C:\json\; 
%let filename=SeriesDataOut.txt;
%let year_s=1997;  
%let year_e=2017;
%let data_final=Format_test;
%let var_want=FSCL_YY OFFC_NM REVN_BDG_CAMT RC_AMT REVN_RC_AMT ANEXP_BDG_CAMT EP_AMT ANEXP_EP_AMT ELUC_BFWAMT DUSEAMT;
libname json "&lib"; 

	/*apiKey*/ %let String01=WBQMR1000052520180323030651FWHGU;
	/*orgId*/ %let String02=1;
	/*tblId*/ %let String03=100;
	/*objL1*/ %let String04=json;
	

/*테이블 하나 만들기(초기 데이터)_start*/
%let url=
http://openapi.openfiscaldata.go.kr/DepartRevenExpenSettle?FSCL_YY=2013&key=&string01&type=&string04&pindex=&string02&psize=&string03
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
	http://openapi.openfiscaldata.go.kr/DepartRevenExpenSettle?FSCL_YY=&year&key=&string01&type=&string04&pindex=&string02&psize=&string03
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
if FSCL_YY="" then delete;
label FSCL_YY=회계연도;
label OFFC_NM=소관명;
label REVN_BDG_CAMT=(세입)예산현액;
label RC_AMT=(세입)수납액(원);
label REVN_RC_AMT=(세입)증감액(원);
label ANEXP_BDG_CAMT=(세출)예산현액(원);
label EP_AMT=(세출)지출액(원);
label ANEXP_EP_AMT=(세출)증감액(원);
label ELUC_BFWAMT=다음년도이월액(원);
label DUSEAMT=불용액(원);
keep &var_want;
run;
/*변수명, 변수 형태 변경_end*/
