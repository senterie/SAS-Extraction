%let lib=xml;
%let dir=C:\Xml\;
libname &lib "&dir";

%include 'D:\OneDrive\Github\SAS\단편 프로젝트 모음\환경부 환경통계포털 PM10 미세먼지 시도 및 연도별 비교\env_macro.sas';/*동일 directory 내의 sas를 불러오는 방법을 모르겠습니다. 현재는 env_macro가 있는 위치를 다 작성하여야 합니다.*/

%env(/*95년도부터 15년도까지 연도별 PM10 시도별 미세먼지 관측자료*/

data=PM10_95_15, 
url=http://stat.me.go.kr/nesis/mesp/searchApi/searchApiMainAction.do?task=C&key=8NfRsp8czHw0JtyP5AQ5Yg%3D%3D&tblID=DT_106N_03_0200029&startDate=1995&endDate=2015&dateType=Y&point=default&dataType=data

);

%env(/*01년도부터 17년도까지 월별 PM10 시도별 미세먼지 관측자료*/

data=PM10_01_17_02, 
url=http://stat.me.go.kr/nesis/mesp/searchApi/searchApiMainAction.do?task=C&key=8NfRsp8czHw0JtyP5AQ5Yg%3D%3D&tblID=DT_106N_03_0200045&startDate=201001&endDate=201709&dateType=M&point=default&dataType=data

);

