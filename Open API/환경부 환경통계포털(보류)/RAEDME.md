>APIKey: 8NfRsp8czHw0JtyP5AQ5Yg%3D%3D(개인용)

>메타자료 주소구조<br>
http://stat.me.go.kr/nesis/mesp/searchApi/searchApiMainAction.do?task=C&key=8NfRsp8czHw0JtyP5AQ5Yg%3D%3D
<br>&tblID=DT_106N_18_0100013
<br>&dataType=meta

>통계자료 주소구조<br>
http://stat.me.go.kr/nesis/mesp/searchApi/searchApiMainAction.do?task=C&key=8NfRsp8czHw0JtyP5AQ5Yg%3D%3D
<br>&tblID=DT_106N_18_0100013
<br>&startDate=2014
<br>&endDate=2014
<br>&dateType=Y
<br>&point=default
<br>&dataType=data

  env_macro.sas와 env_xml.sas가 한 묶음입니다. env_xml로 env_macro에 작성된 매크로를 불러들이고 env_xml에서 필요한 매크로와 변수를 입력하여 실행하면 원하는 통계데이터를 읽어들일 수 있도록 작성하였습니다.

### Model_01

  >현재 제공되는 주소를 입력하면 미리 등록된 APIKey를 주소의 '&key=' 뒤에 자동으로 추가하여 주소를 생성 후 테이블로 추출하는 과정을 만들려고 하였으나, tranwrd 혹은 translate로 조합된 주소를 이용하여 xmlv2로 불러올 경우 오류가 발생하여 xml 라이브러리 안에 Hearder와 message만 생성되는 현상이 있어서 해결하지 못 하고 있습니다.

### Model_02

  >libname xmlv2로 불러온 자료를 proc sql 혹은 data를 이용하여 읽어들이면
  <br>**WARNING: Data truncation occurred on variable data_LeftHakmok1 Column length=3 Additional length=9.**
  <br>과 같은 명령어가 뜨면서 자료가 잘려서 나옵니다.

---

libname xmlv2를 이용할 때 data파일에서 length를 한글의 글자수로 읽어와서 결국 proc copy 혹은 data로 data파일을 불러올 때 한글 변수가 절반 밖에 읽어들어오지 않는 문제가 발생하였습니다. 이 문제를 해결하지 못하여, 환경부 환경통계포털 api 제작은 당분간 보류합니다.
