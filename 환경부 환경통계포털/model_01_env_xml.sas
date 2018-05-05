%let apiKey=8NfRsp8czHw0JtyP5AQ5Yg%3D%3D;/*apiKey*/
%let lib=C:\Xml\;
libname xml "&lib";

%include '.\model_01_env_macro.sas';/*동일 directory 내의 sas를 불러오는 방법을 모르겠습니다. 현재는 env_macro가 있는 위치를 다 작성하여야 합니다.*/

%env(url=http://stat.me.go.kr/nesis/mesp/searchApi/searchApiMainAction.do?task=C&key=&tblID=DT_106N_18_0100015&startDate=2014&endDate=2014&dateType=Y&point=default&dataType=data);
