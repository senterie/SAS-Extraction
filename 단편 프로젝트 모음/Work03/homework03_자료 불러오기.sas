%let lib=C:\Json\; 
%let String01=NjdhZTg3ZTM1OGEzZGMyOGIyZWE0ZmIxZTBiMDg0ZTg=;/*apiKey*/
%let var_want=PRD_DE/*연도*/ C1 C1_NM C3_NM/*연령*/ DT/*수*/;/*원하는 변수만 남기기*/
libname json "&lib";

%macro json(data_final, String02, String03, String04, String05, String06, String07, String08, String09, String10, String11, String12, String13, String14, date_s, date_e);
data "&lib.&data_final";run;
	%do date_want=&date_s %to &date_e;
	%let url=http://kosis.kr/openapi/Param/statisticsParameterData.do?method=getList&apiKey=&String01&itmId=&String12&objL1=&String04&objL2=&String05&objL3=&String06&objL4=&String07&objL5=&String08&objL6=&String09&objL7=&String10&objL8=&String11&format=json&jsonVD=Y&prdSe=&String14&startPrdDe=&date_want&endPrdDe=&date_want&loadGubun=&String13&orgId=&String02&tblId=&String03;

	filename out temp;proc http url="&url" method="get" out=out;run;
	libname raw json fileref=out;

	data "&lib.temp";set raw.alldata;if p1='TBL_NM' then group+1;/*자동으로 p1의 첫번째 값을 'TBL_NM'대신 들어가도록 하는 방법을 못 찾겠습니다.*/run;

	proc transpose data="&lib.temp" out="&lib.data_one"(drop=_:);by group;id P1;var Value;run;

	data "&lib.data_one";set "&lib.data_one"(keep=&var_want);run;

	data "&lib.&data_final";set "&lib.&data_final" "&lib.data_one";run;
	%end;
data "&lib.&data_final";set "&lib.&data_final";if _n_=1 then delete;run;
%mend;

%json(data_final=data_state, /*orgId*/String02=101, /*tblId*/ String03=DT_1B040M1, /*objL1*/String04=00+11+21+22+23+24+25+26+29+31+32+33+34+35+36+37+38+39, /*objL2*/String05=0, /*objL3*/String06=ALL, /*objL4*/String07=,/*objL5*/String08=, /*objL6*/String09=, /*objL7*/String10=, /*objL8*/String11=, /*itmId*/String12=all, /*loadGubun*/String13=2, /*prdSe*/String14=Y, date_s=1993, date_e=2017);
%json(data_final=data_city, /*orgId*/String02=101, /*tblId*/ String03=DT_1B040M1, /*objL1*/String04=all, /*objL2*/String05=0, /*objL3*/String06=ALL, /*objL4*/String07=,/*objL5*/String08=, /*objL6*/String09=, /*objL7*/String10=, /*objL8*/String11=, /*itmId*/String12=all, /*loadGubun*/String13=2, /*prdSe*/String14=Y, date_s=1993, date_e=2017);



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

/*변수명, 변수 형태 변경_start*/
data json.data_state;
set json.data_state;
Year=PRD_DE+0;/*연도*/
Div_num=C1;
Div=C1_NM;
Old=C3_NM;
Num=DT+0;/*수*/
keep Year Div_num Div Old Num;
run;
/*변수명, 변수 형태 변경_end*/
