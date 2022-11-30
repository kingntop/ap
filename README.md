# 가이드

## 1. 환경셋팅
* node 설치  :  https://nodejs.org/ko/download
* git 설치  :  https://git-scm.com/downloads
* 소스 설치  :  git clone ${GITHUB URL}
* 패키지 설치  :  npm i

## 2. 소스구조
* /${프로젝트명}  :  테스트 대상 시스템 (web, api 등)
* /${프로젝트명}/cypress.json  :  프로퍼티 정의 (테스트 계정, time out 설정 등)
* /${프로젝트명}/package.json  :  node package 정의 (upload, retry plugin 설정 등)
* /${프로젝트명}/cypress/fixtures/  :  파일 관련 저장 경로 (업로드 테스트시 사용할 파일 등)
* /${프로젝트명}/cypress/integration/  :  소스 경로 (수행될 테스트 스크립트)
* /${프로젝트명}/cypress/support/  :  공통모듈 경로 (유틸 등)

## 3. 테스트
###	3.1 UI를 통해서 테스트 수행
* 느리지만 UI동작 바로 확인 가능함
* 해당 프로젝트 폴더로 이동후 아래 커맨드 실행
* **`npx cypress open`**

###	3.2 UI 없이 테스트 수행
* 헤드리스 옵션으로 UI없이 빠른 테스트 가능함
* Console에 Text로 테스트결과 리포팅됨
* 해당 프로젝트 폴더로 이동후 아래 커맨드 실행
* **`npx cypress run --headless -b chrome`**

###	3.3 특정 시나리오만 테스트 수행
* 특정 시나리오만 테스트 필요한 경우
* 해당 프로젝트 폴더로 이동후 아래 커맨드 실행
* **`npx cypress run --headless -b chrome -s ${수행할 스크립트 경로}`**
* 예:    npx cypress run --headless -b chrome -s cypress/integration/99.after.js
* 혹은 4.1의 UI를 통해서 해당 시나리오 선택

## 4. 테스트 고려사항
###	4.1 테스트 계정 변경
테스트 계정이 변경될 경우 cypress.json를 수정해야함
###	4.2 테스트 실패 대응
* **`UI로 테스트한 경우는 Browser 좌측의 수행내역에서 에러 내용 확인`**
* **`Headless로 테스트 한 경우 수행로그 및 스크린샷, 비디오 등으로 확인 가능`**
* **`소스 변경시 반드시 해당 테스트 스크립트도 수정해야함`**
* 실패가 발생한 경우 스크립트 재수행하고 이때도 실패하면, 수동으로 해당 기능확인
* Front-end 테스트 특성상 대부분 다시 테스트시 성공함 (Dom load timing, XHR Resp timing 등 사유)
* 일반적으로 headless로 테스트를 수행하고 실패한건이 있을 경우 해당 시나리오만 재실행하거나, UI 테스트로 재확인함 (npx cypress open)
* 성능이 느린 PC에서 테스트를 수행하는 경우 실패확율이 높아짐
* 참고로 시나리오에 따라 테스트 데이터가 삭제되지 않고 남아 있는 경우 실패할 수도 있음

## 5. 테스트 스크립트 작성시 고려사항
###	5.1 정책
* 소스변경에 영향을 덜 받기 위해 **`데이터 중심으로 ACTION`** 필요  (예:  cy.get("#fileList").contains("새폴더1").click();)
* **`반복테스트가 가능한 구조로 작성`**되어야 함  (가능한 레벨1, 2내에서 처리)
    * 레벨1 : 해당 시나리오 내에서 데이터 생성부터 삭제까지 적용  (예:  등록한 파일을 조회하고 수정하고 삭제)
    * 레벨2 : 해당 사니리오의 before/after 구분으로 시나리오 전/후 처리
    * 레벨3 : 해당 프로젝트에서 사용할 테스트 데이터 전후 처리를 위한 시나리오 추가 (00.before.js, 99.after.js)
    * 레벨4 : 타 프로젝트에서도 공통으로 사용되야할 내용일 경우 별도 프로젝트로 분리
* **테스트 계정 변경시 작업해야할 사항 최소화**하고, 필요시 cypress.json으로 관리
* 일관된 방식으로 스크립트 작성 (동일 시나리오를 작성하는 방법은 여러가지가 있을수 있음)
* 간결하고 가독성 높게 작성
###	5.2 작성팁
* javascript 기반(정확히는 mocha 기반)이기 때문에 필요한 코드 직접 응용 가능함
* chrome devtools을 활용하여 selector 및 console log 활용 가능함
* 사용자 정의함수 추가 및 기존 함수 오버라이딩 가능함
###	5.3 기타
* describe()  :  테스트 블록
* before()  :  describe 하위 테스트 케이스 수행전 최초 1회 수행할 내용 정의
* beforeEach()  :  각 테스트 케이스 수행전 수행할 내용 정의
* after()  :  describe 하위 테스트 케이스를 모두 완료 후 수행할 내용 정의
* it()  :  테스트 케이스

## 6. 테스트 스크립트 작성시 참고URL
* cypress doc  (https://docs.cypress.io)
* cypress api  (https://docs.cypress.io/api/api/table-of-contents.html)
* vs code(IDE) (https://code.visualstudio.com/download)
* sourcetree   (https://www.sourcetreeapp.com)

## 7. 개발 고려사항
* 개발시 가능하면 버튼, 입력항목, 링크 등에 ID를 표기하여 html tag 접근이 용이하도록 개발  (예:  <input id="loginId" ~~>)
* **`소스 변경시 반드시 해당 테스트 스크립트도 수정해야함`**
