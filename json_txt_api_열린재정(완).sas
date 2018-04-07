%let dir=D:\OneDrive\SAS\SAS_library\열린재정\data\;
%let lib=D:\OneDrive\SAS\SAS_library\열린재정\; 
%let filename=SeriesDataOut.txt;
%let year_s=2007;  
%let year_e=2018;
%let data_final=longdata_002;
%let var_want=FSCL_YY
OFFC_CD
OFFC_NM
FSCL_CD
FSCL_NM
ACCT_CD
ACCT_NM
IKWAN_CD
IKWAN_NM
IHANG_CD
IHANG_NM
REVN_BDGAMT_F
REVN_BDGAMT_M
FNT_UDAMT
REVN_BDG_CAMT
RD_AMT
RC_AMT
RV_NAMT
NPL_AMT
NRC_AMT
;
libname json "&lib"; 

	/*Key*/ %let String01=WBQMR1000052520180323030651FWHGU;
	/*pIndex*/ %let String02=2;
	/*pSize*/ %let String03=1000;
	/*Type*/ %let String04=json;
	/*요청주소*/ %let String05=http://openapi.openfiscaldata.go.kr/RevenuesSettled;
	

/*테이블 하나 만들기(초기 데이터)_start*/
%let url=
&string05?FSCL_YY=&year_s&key=&string01&type=&string04&pindex=&string02&psize=&string03
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
	&string05?FSCL_YY=&year&key=&string01&type=&string04&pindex=&string02&psize=&string03
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
data "&dir.&data_final";
set "&dir.&data_final" "&lib.&data_final";
if FSCL_YY="" then delete;
label FSCL_YY=회계연도;
label OFFC_CD	=소관;
label OFFC_NM	=소관명;
label FSCL_CD	=회계;
label FSCL_NM	=회계명;
label ACCT_CD	=계정;
label ACCT_NM	=계정명;
label IKWAN_CD=	수입관;
label IKWAN_NM	=수입관명;
label IHANG_CD	=수입항;
label IHANG_NM	=수입항명;
label REVN_BDGAMT_F=	세입예산액/당초수입계획액(원);
label REVN_BDGAMT_M	=세입예산액/수정수입계획액(원);
label FNT_UDAMT=	이체등증감액(원);
label REVN_BDG_CAMT=	세입예산현액/수입계획현액(원);
label RD_AMT	=징수결정액(원);
label RC_AMT	=수납액(원);
label RV_NAMT	=수납순액(원);
label NPL_AMT	=불납결손액(원);
label NRC_AMT	=미수납액(원);
keep &var_want;
run;
/*변수명, 변수 형태 변경_end*/
