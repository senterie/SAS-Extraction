### KOSIS 통계목록
#### 목록구분(서비스뷰)
- 국내통계 주제별(MT_ZTITLE)
- 국내통계 기관별(MT_OTITLE)
- e-지방지표(주제별)(MT_GTITLE01)
- e-지방지표(지역별)(MT_GTITLE02)
- 광복이전통계(1908~1943)(MT_CHOSUN_TITLE)
- 대한민국통계연감(MT_HANKUK_TITLE)
- 작성중지통계(MT_STOP_TITLE)
- 국제통계(MT_RTITLE)
- 북한통계(MT_BUKHAN)
- 대상별통계(MT_TM1_TITLE)
- 이슈별통계(MT_TM2_TITLE)
- 영문 KOSIS(MT_ETITLE)

#### 목록구분 별 데이터 url
- 공통: http://kosis.kr/openapi/statisticsList.do?method=getList
- apiKey: &apiKey=*apiKey*
- 목록구분: &vwCd=*목록구분 서비스뷰*
- List_ID(목록구분 하위목록): &parentListId=*List_ID* / List_ID로 하위항목 전체 구분
