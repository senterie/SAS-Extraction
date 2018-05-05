### SAS-Extraction

본 repo의 목적은 SAS 코드를 개선하고 공유하는 것입니다. 현재는 한국에서 제공되는 통계자료를 SAS로 추출하는 코드를 만들고 있습니다. 정부에서 제공하는 자료임에도 기관에 따라 자료를 제공하는 방법과 자료의 형태가 다르기 때문에 각각의 방법에 맞춘 코드가 필요합니다. 본 코드를 만드는데 사용된 SAS 소프트웨어의 버젼은 다음과 같습니다.

---

    NOTE: Copyright (c) 2016 by SAS Institute Inc., Cary, NC, USA.
    NOTE: SAS (r) Proprietary Software 9.4 (TS1M5 MBCS3170)
    NOTE: 이 세션은 X64_10HOME 플랫폼에서 실행되고 있습니다.

    NOTE: 업데이트 된 분석 제품:

      SAS/STAT 14.3
      SAS/ETS 14.3
      SAS/OR 14.3
      SAS/IML 14.3
      SAS/QC 14.3

    NOTE: 추가 호스트 정보:

      X64_10HOME WIN 10.0.16299 Workstation

API로 불러오는 자료의 인코딩에 문제가 있어서 SAS 9.4 (유니코드 지원)으로 실행합니다.

---

### 기관 목록

- 국토교통부 통계누리
  - JsonAPI
  - 완료; 추가작업 필요
- 열린재정
  - JsonAPI
  - 완료; 추가작업 필요
- 환경부 환경통계포털
  - XmlAPI
  - 완료;
- KOSIS
  - JsonAPI
  - 완료; 추가작업 필요(통계목록 작성)
