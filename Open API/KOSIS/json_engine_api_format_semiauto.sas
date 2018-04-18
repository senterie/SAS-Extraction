%let lib=C:\Json\; 
%let String01=NjdhZTg3ZTM1OGEzZGMyOGIyZWE0ZmIxZTBiMDg0ZTg=;/*apiKey*/
%let var_want=PRD_DE/*연도*/ C1 C1_NM C3_NM/*연령*/ DT/*수*/;/*원하는 변수만 남기기, 전부 남기고 싶으면 공란*/
libname json "&lib";

%macro json(data_final, date_s, date_e);
data "&lib.&data_final";run;
	%do date_want=&date_s %to &date_e;
	%let url=http://kosis.kr/openapi/statisticsData.do?method=getList&apiKey=NjdhZTg3ZTM1OGEzZGMyOGIyZWE0ZmIxZTBiMDg0ZTg=&format=json&jsonVD=Y&userStatsId=idencosmos/101/DT_1B040M1/2/1/20180323133026&prdSe=Y&startPrdDe=&data_want&endPrdDe=&data_want;
	/*주소는 고정, 연도만 바꾸면서 매크로 작동*/
	filename out temp;proc http url="&url" method="get" out=out;run;
	libname raw json fileref=out;

	data "&lib.temp";set raw.alldata;if p1='TBL_NM' then group+1;/*첫번째 행의 변수와 같으면 +1, 자동으로 p1의 첫번째 값을 'TBL_NM'대신 들어가도록 하는 방법을 못 찾겠습니다.*/run;

	proc transpose data="&lib.temp" out="&lib.data_one"(drop=_:);by group;id P1;var Value;run;

	data "&lib.data_one";set "&lib.data_one"(keep=&var_want);run;

	data "&lib.&data_final";set "&lib.&data_final" "&lib.data_one";run;
	%end;
data "&lib.&data_final";set "&lib.&data_final";if _n_=1 then delete;run;
%mend;

%json(data_final=data_state, date_s=1993, date_e=2017);

/*변수명, 변수 형태 변경_start*/
data json.data_city;
set json.data_city;
Year=PRD_DE+0;/*연도*/
Div_num=C1;
Div=C1_NM;
Old=C3_NM;
Num=DT+0;/*수*/
keep Year Div_num Div Old Num;
run;
/*변수명, 변수 형태 변경_end*/
