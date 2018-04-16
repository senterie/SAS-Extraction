%let dir=C:\json\;
%let lib=json;
%let String01=WBQMR1000052520180323030651FWHGU;/*apiKey*/

libname &lib "&dir";

%macro json(data_final, String05, date_s, date_e);

	%let url=&string05?FSCL_YY=&date_s.&key=&string01&type=json&pindex=1&psize=1000;

	filename out temp;proc http url="&url" method="get" out=out;run;
	libname raw json fileref=out;

	data &lib .&data_final;set raw.Revenuessettled_row;run;

	%do date_want=&date_s %to &date_e;
	%do string02=1 %to 4;

	%let url=&string05?FSCL_YY=&date_want.&key=&string01&type=json&pindex=&string02&psize=1000;

	filename out temp;proc http url="&url" method="get" out=out;run;
	libname raw json fileref=out;

	proc sql;
	create table &lib .&data_final as
	select distinct * from
	(select a.* from &lib .&data_final as a union select b.* from raw.Revenuessettled_row as b)
	quit;
	run;

	%end;
	%end;
%mend;

%json(data_final=longdata_002, String05=http://openapi.openfiscaldata.go.kr/RevenuesSettled, date_s=2012, date_e=2015);

/*2015년도 2번째 페이지에서 오류 ERROR: Invalid JSON in input near line 1 column 101883: Encountered an illegal character.*/

/*변수명, 변수 형태 변경_start*/
data &lib .longdata_002;
set &lib .longdata_002;
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
run;
/*변수명, 변수 형태 변경_end*/
