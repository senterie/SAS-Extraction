%let dir=D:\OneDrive\SAS\SAS_library\열린재정\data\;
%let lib=D:\OneDrive\SAS\SAS_library\열린재정\; 
%let String01=WBQMR1000052520180323030651FWHGU;/*apiKey*/
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
NRC_AMT;
libname json "&lib";


	/*pSize*/ %let String03=1000;
	/*Type*/ %let String04=json;
	/*요청주소*/ %let String05=http://openapi.openfiscaldata.go.kr/RevenuesSettled;

%macro json(data_final, String05, String04, String03, date_s, date_e);
data "&lib.&data_final";run;
	%do date_want=&date_s %to &date_e;
	%do string02=1 %to 10;
	%let url=&string05?FSCL_YY=&year&key=&string01&type=&string04&pindex=&string02&psize=&string03;

	filename out temp;proc http url="&url" method="get" out=out;run;
	libname raw json fileref=out;

	data "&lib.temp";set raw.alldata;if p1='FSCL_YY' then group+1;/*자동으로 p1의 첫번째 값을 'TBL_NM'대신 들어가도록 하는 방법을 못 찾겠습니다.*/run;

	proc transpose data="&lib.temp" out="&lib.data_one"(drop=_:);by group;id P1;var Value;run;

	data "&lib.data_one";set "&lib.data_one"(keep=&var_want);run;

	data "&lib.&data_final";set "&lib.&data_final" "&lib.data_one";run;
	%end;
	%end;
data "&lib.&data_final";set "&lib.&data_final";if _n_=1 then delete;run;
%mend;

%json(data_final=longdata_002, String03=1000,  String04=json, String05=http://openapi.openfiscaldata.go.kr/RevenuesSettled, date_s=2007, date_e=2017);


/*변수명, 변수 형태 변경_start*/
data "&dir.&data_final";
set "&lib.&data_final";
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
