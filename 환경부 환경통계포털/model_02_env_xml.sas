%let lib=C:\Xml\;
libname xml "&lib";

%include '\model_02_env_macro.sas';/*동일 directory 내의 sas를 불러오는 방법을 모르겠습니다. 현재는 env_macro가 있는 위치를 다 작성하여야 합니다.*/

%env(http://stat.me.go.kr/nesis/mesp/searchApi/searchApiMainAction.do?task=C&key=8NfRsp8czHw0JtyP5AQ5Yg%3D%3D&tblID=DT_106N_03_0200145&startDate=201501&endDate=201704&dateType=M&point=default&dataType=data);

/*불러들어온 파일인 xml.data의 한글 변수들이 잘려나갑니다. 현재 해결방법을 찾지 못 하여 잠정 보류합니다.*/
