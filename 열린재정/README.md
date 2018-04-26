>통계자료 주소구조<br>
http://openapi.openfiscaldata.go.kr/
<br>DepartRevenExpenSettle > 필수/테이블에 따라 변경
<br>?FSCL_YY=2013 > 필수/테이블에 따라 변경
<br>&key=WBQMR1000052520180323030651FWHGU > 필수
<br>&type=json > 필수
<br>&pindex=1 > 필수
<br>&psize=1000 > 필수

### Model_01(오류)

>코드에 따라서 일부 페이지에서 오류. '세입/수입 결산 현황'은 2015년도 2번째 페이지에서 오류. 원인 불명. 테이블에 따라서 %macro 내부 Revenuessettled_row 변경 필요. 파일 명칭이 테이블마다 다르게 설정되어 있음.

    ERROR: Invalid JSON in input near line 1 column 101883: Encountered an illegal character.

### Model_02(완성)

>libname json의 경우 일부 페이지 혹은 테이블에서 오류가 발생하여 txt 기반 Api 이용. SAS 9.4 TS Level 1M4 아래 버젼에서도 원활하게 작동.

### Model_03(완성)

>libname json의 경우 일부 페이지 혹은 테이블에서 오류가 발생하여 txt 기반 Api 이용. SAS 9.4 TS Level 1M4 아래 버젼에서도 원활하게 작동하는 Model_02를 기반으로 한 번에 1,000건 밖에 못 불러오는 열린재정 api를 %do %until 명령문으로 해결한 버젼.

### Model_04(완성)

>Model_03과 동일, 다만 숫자형 변수를 숫자형 변수로 변경
