%let lib=C:\Json\;
%let Str01=2e03c601603e4026ad254a417381f602;/*apiKey*/
libname json "&lib";

%let url=http://stat.molit.go.kr/portal/openapi/service/rest/getList.do?key=&str01&form_id=840&style_num=1&start_dt=2007&end_dt=2007;

filename out temp;proc http url="&url" method="get" out=out;run;
libname raw json fileref=out;

proc datasets lib=raw; quit;
proc print data=raw.alldata(obs=100); run;
proc print data=raw.RESULT_DATA_FORMLIST(obs=100); run;
