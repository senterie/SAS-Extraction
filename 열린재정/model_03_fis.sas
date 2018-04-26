%let dir=D:\OneDrive\Github\SAS-Projects\0002\;
%let lib=json;
%let String01=WBQMR1000052520180323030651FWHGU;/*apiKey*/
%let var_want=FSCL_YY
EXE_M
OFFC_CD
OFFC_NM
FSCL_CD
FSCL_NM
FLD_CD
FLD_NM
SECT_CD
SECT_NM
PGM_CD
PGM_NM
ACTV_CD
ACTV_NM
ANEXP_BDG_CAMT
EP_AMT
THISM_AGGR_EP_AMT
;

libname &lib "&dir";

%macro json(data_final, String05, date_s, date_e);

	%do date_want=&date_s %to &date_e;
	data L001_&date_want;run;

		%let string02=1;
		%do %until (&check=200);

		%let url=&string05?OFFC_CD=&date_want&key=&string01&type=json&pindex=&string02&psize=1000;

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

%json(data_final=longdata_001, String05=http://openapi.openfiscaldata.go.kr/VWFOEM, date_s=161, date_e=163);

/*변수명, 변수 형태 변경_start*/
data &lib .longdata_001;
set L001_0-L001_200;
label FSCL_YY=	회계년도;
label EXE_M	=집행월;
label OFFC_CD=	소관;
label OFFC_NM	=소관명;
label FSCL_CD	=회계;
label FSCL_NM	=회계명;
label FLD_CD	=분야코드;
label FLD_NM	=분야명;
label SECT_CD	=부문코드;
label SECT_NM	=부문명;
label PGM_CD	=프로그램코드;
label PGM_NM	=프로그램명;
label ACTV_CD	=단위사업코드;
label ACTV_NM	=단위사업명;
label ANEXP_BDG_CAMT=	예산(원);
label EP_AMT	=당월집행액(원);
label THISM_AGGR_EP_AMT	=누계집행액(원);
keep &var_want;
if FSCL_YY="" then delete;
run;
/*변수명, 변수 형태 변경_end*/
