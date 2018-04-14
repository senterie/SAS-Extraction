%let lib=xml;
%let dir=C:\Xml\;
libname &lib "&dir";

%include '\model_03_env_macro.sas';/*동일 directory 내의 sas를 불러오는 방법을 모르겠습니다. 현재는 env_macro가 있는 위치를 다 작성하여야 합니다.*/

%env(http://stat.me.go.kr/nesis/mesp/searchApi/searchApiMainAction.do?task=C&key=8NfRsp8czHw0JtyP5AQ5Yg%3D%3D&tblID=DT_106N_03_0200145&startDate=201501&endDate=201704&dateType=M&point=default&dataType=data);
