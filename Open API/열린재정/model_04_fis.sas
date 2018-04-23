%let dir=D:\OneDrive\Github\SAS-Projects\0002\sas7bdat\;
%let lib=json;
%let String01=WBQMR1000052520180323030651FWHGU;/*apiKey*/
%let var_want=FSCL_YY
OFFC_CD
OFFC_NM
FSCL_CD
FSCL_NM
ACCT_CD
ACCT_NM
FLD_CD
FLD_NM
SECT_CD
SECT_NM
PGM_CD
PGM_NM
ACTV_CD
ACTV_NM
CITM_CD
CITM_NM
ANEXP_BDGAMT_F
ANEXP_BDGAMT_M
PREY_BFWAMT
OVR_EP_AMT
RSVF_EP_DCS_IAMT
RSVF_EP_DCS_MAMT
BDTR_IAMT
BDTR_MAMT
AVDV_IAMT
AVDV_MAMT
FNT_IAMT
FNT_MAMT
ANEXP_BDG_CAMT
EP_AMT
EP_NAMT
NEXT_YY_BFWAMT
DUSEAMT
;

libname &lib "&dir";

%macro json(String05, date_s, date_e);

	%do date_want=&date_s %to &date_e;
	data L001_&date_want;run;

		%let string02=1;
		%do %until (&check=200);

		%let url=&string05?FSCL_YY=&date_want&key=&string01&type=json&pindex=&string02&psize=1000;

		filename out "&dir.SeriesDataOut.txt" recfm=v lrecl=999999999;
		proc http out=out url="&url" method="post" ct="application/json";
		run;

		data raw;
		infile "&dir.SeriesDataOut.txt" dsd lrecl=999999999 dlm='{}[]:,';
		input raw : $2000.@@;
		if _n_=5 then call symput('check', scan(raw,2));
		run;

		data temp;
		merge raw raw(firstobs=2 rename=(raw=_raw));
		if mod(_n_,2) eq 0;
		run;

		data temp;
		set temp;
		if raw='' then group+1;
		run;

		proc transpose data=temp out=data_one(drop=_:);
		by group;
		id raw;
		var _raw;
		run;

		data L001_&date_want;
		set L001_&date_want data_one;
		run;

		%let string02=%eval(&string02+1);

		%end;

	%end;

%mend;

%json(String05=http://openapi.openfiscaldata.go.kr/ExpendituresSettlement, date_s=2000, date_e=2018);

/*변수명, 변수 형태 변경_start*/
data combine;
set L001_2000-L001_2018;
keep &var_want;
if FSCL_YY="" then delete;
run;
/*변수명, 변수 형태 변경_end*/

proc sql;
create table &lib..longdata_004 as
select input(FSCL_YY, best32.) as FSCL_YY label="회계연도"
, OFFC_CD as OFFC_CD label="소관"
, OFFC_NM as OFFC_NM label="소관명"
, FSCL_CD as FSCL_CD label="회계"
, FSCL_NM as FSCL_NM label="회계명"
, ACCT_CD as ACCT_CD label="계정"
, ACCT_NM as ACCT_NM label="계정명"
, FLD_CD as FLD_CD label="분야"
, FLD_NM as FLD_NM label="분야명"
, SECT_CD as SECT_CD label="부문"
, SECT_NM as SECT_NM label="부문명"
, PGM_CD as PGM_CD label="프로그램"
, PGM_NM as PGM_NM label="프로그램명"
, ACTV_CD as ACTV_CD label="단위사업"
, ACTV_NM as ACTV_NM label="단위사업명"
, CITM_CD as CITM_CD label="지출목"
, CITM_NM as CITM_NM label="지출목명"
, input(ANEXP_BDGAMT_F, best32.) as ANEXP_BDGAMT_F label="세출예산액/당초지출계획액(원)"
, input(ANEXP_BDGAMT_M, best32.) as ANEXP_BDGAMT_M label="세출예산액/수정지출계획액(원)"
, input(PREY_BFWAMT, best32.) as PREY_BFWAMT label="전년도이월액(원)"
, input(OVR_EP_AMT, best32.) as OVR_EP_AMT label="초과지출승인액(원)"
, input(RSVF_EP_DCS_IAMT, best32.) as RSVF_EP_DCS_IAMT label="예비비지출결정증액(원)"
, input(RSVF_EP_DCS_MAMT, best32.) as RSVF_EP_DCS_MAMT label="예비비지출결정감액(원)"
, input(BDTR_IAMT, best32.) as BDTR_IAMT label="전용증액(원)"
, input(BDTR_MAMT, best32.) as BDTR_MAMT label="전용감액(원)"
, input(AVDV_IAMT, best32.) as AVDV_IAMT label="이용증액(원)"
, input(AVDV_MAMT, best32.) as AVDV_MAMT label="이용감액(원)"
, input(FNT_IAMT, best32.) as FNT_IAMT label="이체증액(원)"
, input(FNT_MAMT, best32.) as FNT_MAMT label="이체감액(원)"
, input(ANEXP_BDG_CAMT, best32.) as ANEXP_BDG_CAMT label="세출예산현액/지출계획현액(원)"
, input(EP_AMT, best32.) as EP_AMT label="지출액(원)"
, input(EP_NAMT, best32.) as EP_NAMT label="지출순액(원)"
, input(NEXT_YY_BFWAMT, best32.) as NEXT_YY_BFWAMT label="다음년도이월액(원)"
, input(DUSEAMT, best32.) as DUSEAMT label="불용액(원)"
from combine;
quit;
run;
