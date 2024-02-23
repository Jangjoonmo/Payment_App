# 페이먼트 앱

<!--프로젝트 대문 이미지-->
![Simulator Screenshot - iPhone 15 Pro - 2024-02-23 at 13 12 55](https://github.com/Jangjoonmo/delight_labs_assignment/assets/99167099/6ae33af9-20fa-4900-880a-a9db0bc23fc7)

<!--목차-->
# 목차
- [[1] 안내](#1-안내)
  - [주의 사항](#주의-사항)
  - [요구 사항](#요구-사항)
- [[2] 개발 환경](#2-개발-환경)
  - [사용기술](#사용기술)
  - [사용법](#사용법)
- [[3] 기능](#3-기능)
  - [UI 구성](#ui-구성)
  - [Mocking Data Preprocessing](#mocking-data-preprocessing)
  - [TableView 구현](#tableview-구현)
  - [LineChart 구현](#linechart-구현)
  - [ETC](#etc)
- [[4] 미완성 기능](#미완성-기능)
- [[5] 트러블 슈팅 및 고민한 점](#트러블-슈팅-및-고민한-점)
  - [방대한 양의 MockingData](#방대한-양의-mockingdata)
  - [처음 다뤄보는 Chart 그리기](#처음-다뤄보는-chart-그리기)
  - [UIKit과 SwiftUI의 동시 사용](#uikit과-swiftui의-동시-사용)
- [[6] If i...](#6-if-i...)



# [1] 안내
본 과제는 DELIGHT LABS iOS 채용 과정 홈테스트 사전 과제입니다.

## 주의사항
- 홈테스트 내용은 외부로 반출될 수 없으며 반출 시 법적 제재를 받습니다.
- DELIGHT LABS 및 테스트 응시자는 홈테스트 내용의 일부 또는 전체를 홈테스트 면접 외의 목적으로 절대 사용할 수 없습니다.
- 홈테스트 응시함으로써 위의 사항에 동의한 것으로 간주되어 법적효력을 갖습니다.


## 요구사항
- 거래내역은 입금(Income)과 출금(Expense)만 존재
- 2023 1월 ~ 2024년 2월 입출금 mock 데이터 제공
- 입금과 출금 발생시 디바이스에서 알림
- 그래프 Week(7일), Month(30일) 두가지 애니메이션 포함하여 구현
- 제공된 프로토타입을 참고하여 인터렉션 구현

# [2] 개발 환경
*만약 운영체제에 따라 프로그램을 다르게 동작시켜야한다면, 운영체제별로 동작 방법을 설명하세요*

## 사용 기술
*사용 환경, 언어 및 주요 라이브러리*

- [Xcode] 15.2
- [Swift] 5.9.0
- [RxSwift] 6.6.0
- [Realm] 10.47.0
- [Snapkit] 5.7.1
- [Then] 3.0.0
- [Minimum iOS Version] 17.2

## 사용법
*시뮬레이터 사용법*
1. Repository 클론
```bash
git clone https://github.com/Jangjoonmo/delight_labs_assignment.git
```
2. 최소 iOS - Simulator 버전
17.2
3. 초기 실행 시 데이터 파싱
<img width="617" alt="image" src="https://github.com/Jangjoonmo/delight_labs_assignment/assets/99167099/8d1734e5-b49a-4f2d-98cd-60e73b00cc09">




# [3] 기능
***스크린샷, 코드** 등을 통해 **사용 방법**과 **사용 예제**를 보여주세요. 사용 예제별로 h2 헤더로 나누어 설명할 수 있습니다.*

## UI 구성
- UIKit과 SwiftUI 함께 사용
- Figma의 화면 구성 및 제약조건을 정확히 구현하기 위해 SnapKit과 Then 라이브러리를 사용하여 Code-Base로 AutoLayout을 잡아 구현했습니다.
- Line Chart는 SwiftUI와 내장 라이브러리 Chart를 사용하였습니다.
- Assets 파일에 필요한 리소스들을 넣어 구현했습니다.
- 크게는 2개의 뷰로 구성되어 있어 MVC 패턴을 사용할까 했지만 여러 인터랙션이 존재하는 것을 보고 MVVM 패턴을 채택했습니다.
- <img width="173" alt="image" src="https://github.com/Jangjoonmo/delight_labs_assignment/assets/99167099/50a62934-312f-484f-a12c-318d2294f6c4">


## Mocking Data Preprocessing
- 63MB의 Json파일, 총 612,000개의 데이터를 파싱하여 Realm에 저장하였습니다.
- 효율적인 load And Save를 위해 1000개 단위로 청크하여 저장하였습니다.
- 싱글톤 패턴 TransactionManager을 사용하여 메모리 낭비를 줄였습니다.
- 필요한 경우의 수를 나누어 각각의 쿼리 함수를 선언하였습니다.
<img width="150" alt="image" src="https://github.com/Jangjoonmo/delight_labs_assignment/assets/99167099/26219386-8476-403b-bdfe-57498803f5c5">
<img width="150" alt="image" src="https://github.com/Jangjoonmo/delight_labs_assignment/assets/99167099/91ba2e66-f073-4380-8a0c-5e939bca0c91">
<img width="600" alt="image" src="https://github.com/Jangjoonmo/delight_labs_assignment/assets/99167099/cde5f655-9fce-41bd-977c-605f7ce70792">
<img width="600" alt="image" src="https://github.com/Jangjoonmo/delight_labs_assignment/assets/99167099/c30bcfd0-1865-42e9-bac0-e65278bea345">

## TableView 구현
- Realm으로 부터 데이터를 받아와 Tableview를 업데이트 하였습니다.
- RxSwift를 사용해 비동기 데이터 처리를 하였습니다.
- 버튼 클릭 처리 - All / Expense / Income 버튼 클릭 시 각각에 맞는 데이터를 불러와 테이블뷰 셀에 로드해줬습니다.
- 각 버튼이 Toggle되는 형식으로 디테일하게 구현하였습니다.
  
![Simulator Screen Recording - iPhone 15 Pro - 2024-02-23 at 14 21 52](https://github.com/Jangjoonmo/delight_labs_assignment/assets/99167099/10448c55-bdbc-47a6-af3d-80ad8f1000ee)

## LineChart 구현
- Line Chart는 이쁜 UI를 위해 UIKit이 아닌 SwiftUI로 구현하였습니다.
- 그래프가 그려질 때 애니메이션을 추가하였습니다.
- 그래프의 Gradient를 추가하였습니다.
- 버튼 클릭 시 일주일/한달 입출금 데이터를 받아와 Line Chart를 그리는 기능을 추가하였습니다.
![Simulator Screen Recording - iPhone 15 Pro - 2024-02-23 at 14 37 20](https://github.com/Jangjoonmo/delight_labs_assignment/assets/99167099/e86cff55-7267-48e7-a773-7e5166d4406d)


## ETC
- Extension을 활용하였습니다. UIKit를 사용하여 구현시에도 SwiftUI의 Preview기능을 Extension하여 현재 화면을 확인하면서 UI를 구현하였습니다.
- HexCode로 UIColor를 사용할 수 있게 Extension하였습니다.
- Figma의 화면 요구 사항을 정확히 구현하기 위해 SceneDelegate에서 TabBarController를 사용하였습니다.
- Json Mock 데이터 파일을 그대로 사용할때 보다 훨씬 빠른 Realm 데이터베이스를 활용하여 쿼리 속도를 올렸습니다.
- Json파일의 모델과 별도로 TransactionData 모델을 만들어 실제 서비스에 필요한 transactionType; income/expense 속성을 추가하였습니다.
- 주요 기능 별 Branch를 나눠 Commit Convention에 맞게 버전 관리를 하였습니다.
- 의존성을 낮추고 유지보수에 효율적인 MVVM 디자인 패턴 및 Clean-Architecture 폴더링을 사용하였습니다.
<img width="600" alt="image" src="https://github.com/Jangjoonmo/delight_labs_assignment/assets/99167099/62947525-cf51-46e9-9067-11224b49f35c">


# [4] 미완성 기능

- Line Chart에서 마우스 Hobber 처리 이벤트를 구현하지 못했습니다. 오픈소스 라이브러리 Charts를 사용했을 시엔 줌인/아웃 등의 처리가 구현되어 있어 SwiftUI로도 구현이 가능해보였으나 직접 함수를 만들어야 했기에 후순위로 밀려 구현하지 못하였습니다.
- 입출금 발생시 푸시 알림을 구현하지 못하였습니다. 이전에 해커톤에서 유사하게 서버 연결 없이 FCM(Firebase Cloud Messaging)을 구현하였으나 키와 인증서 등록에 오랜 시간이 걸리는 것을 알고 후순위로 두어 구현하지 못하였습니다.
- 기타 디테일들을 살리지 못했습니다. LineChart와 TableView 로딩 시 로딩 Indicator를 보여주어 사용자 경험을 향상시키려 하였으나 LineChart 바인딩 문제로 구현하지 못하였습니다. 

# [5] 트러블 슈팅 및 고민한 점

## 방대한 양의 MockingData

  과제를 시작할 초기에 빠르게 UI를 먼저 구현하고 데이터를 받아와서 테이블뷰를 먼저 구현할 생각이었습니다. 화면 구현이 거의 다 끝나고 첨부된 Json파일 Mock데이터를 프로젝트 번들에 넣자마자 렉이 걸렸습니다. 그리고 시뮬레이터로 Json 데이터 파싱을 호출하니 앱이 멈추다시피 했습니다. 이런 방대한 양의 데이터를 시뮬레이터를 호출할 때 마다 불러오는 것은 거의 불가능이었고 메모리 측면에서도 매우 비효율적이라 생각했습니다.
  이전에는 서버에서 필요한 데이터만 받아와서 사용했기에 약 61만개의 데이터를 처리하는 것은 처음이었습니다. 당황스러움과 의문점이 무수히 들었습니다. 로컬 저장소를 사용해야 하는지. 아니면 GCD를 이용해 앱이 실행됨과 동시에 비동기로 불러와 실시간으로 받아와야 하는지. 로컬 저장소를 쓰면 어떤거를 사용해야 하는지? 그리고 가장 궁금했던 것은 "왜 61만개나 되는 데이터를 주신건지" 분명 이러한 데이터를 주신 것에 이유가 있다 생각이 들었고 여러 고민 끝에 '페이먼츠 앱이니까 방대한 양의 데이터를 직접 다룰 수 있는지'를 판단하는 것이라 느껴서 여러 방법을 찾았습니다.
  결국 가장 빠르게 많은 양의 데이터를 받아올 수 있는 오픈소스 RDBS인 Realm을 사용하기로 결정하였습니다. 그러나 Realm에 데이터를 그대로 넣는 것도 오래걸리는 작업이므로 페이징을 사용할까 고민하다가 데이터를 chunk단위로 분할하여 받아오도록(1000개)하여 로딩과 저장 속도를 초기보다 훨씬 올릴 수 있었습니다. 또한 앱 요구 사항을 분석한 결과 필요한 데이터가 7개의 경우의 수로 나뉘는 것을 확인했습니다. 일주일,한달 분량의 입/출금 데이터와 최근 입출금 20건, 최근 출금/입금 각 10건씩. 이 경우의 수에 맞는 데이터를 불러오는 쿼리 함수를 따로 설정해두어 사용했습니다.

## 처음 다뤄보는 Chart 그리기

  주로 주식이나 핀테크 앱에 사용되는 Chart는 사용해본 적이 없어서 또 한번 당황스러웠습니다. 먼저 Chart를 그리는 방법을 검색한 결과 크게 오픈소스인 'Charts'를 사용하거나 SwiftUI로 그리는 것이 있었습니다. 가장 주로 사용하는 Charts 사용법을 블로그를 보면서 구현한 결과 UI가 너무 안좋았습니다. 터치 모션도 인식하고 여러 내장 기능들이 많았으나 Figma에 제시된 화면 요구 사항이랑 너무 다르고 안이쁘게 나왔습니다. 그래서 결국 Charts 라이브러리를 포기하고 능숙하지 않은 SwiftUI로 그리기로 결정했습니다. 
  몇시간의 노력 끝에 별도의 LineCharViewModel을 만들어 SwiftUI로 구현된 화면을 연결하여 라인을 그리는데 까지는 성공하였으나 너무도 많은 문제가 발생하였습니다. 먼저 개발 초기에 실수를 범했습니다. 제가 사용하던 주식앱들을 생각하여 하루 거래양의 총합을 계산하여 그래프를 그렸습니다. 
  이를 수정한 후 데이터를 받아 그래프를 그리니까 그래프가 선들로 빼곡했습니다. 주어진 Mock데이터의 RDBS를 확인한 결과 1월부터 2월까지 1분단위로 항상 데이터가 있었습니다. 그래서 당연히 그래프가 선으로 꽉찬 것이었으며 어떻게 이를 해결할 지 고민하면서 자주 사용하던 Webull앱의 월봉 그래프를 보니 하루 단위로 그래프를 그린것을 확인하였습니다. 그래서 저는 더 빠른 쿼리를 위해 일주일 그래프는 1시간 간격, 한달 그래프는 8시간 간격으로 데이터를 받아와서 그래프를 그렸습니다. 애니메이션과 그라데이션 처리는 해외 블로그를 통해 비교적 쉽게 구현할 수 있었으나 데이터 처리에서 가장 긴 시간이 소요됐습니다. 여기서도 효율적이고 빠른 데이터 처리를 위한 고민을 가장 많이 했습니다. 

## UIKit과 SwiftUI의 동시 사용

  LineCharView를 SwiftUI로 구현한 후 이를 UIKit으로 된 ViewController에서 사용하려고 하니 호환성 문제인지 첫 화면로딩을 제외하곤 애니메이션도 안되고 버튼 처리, 데이터 로딩도 안됐습니다. SwiftUI로 구현한 ViewController와 UIKit은 이전 프로젝트에서 연결해본 적은 있으나 SwiftUI의 View를 UIKit ViewController에서는 처음이어서 비동기처리에 문제가 많았습니다. 프로젝트의 MVVM 비동기를 RxSwift로 처리하였기 때문에 RxSwift로 연결하였으나 작동하지 않았습니다. 아마 Combine으로 랩핑하면 가능할 것 같다고 생각이 들었으나 Rx에 고집하면서 시간을 더 잡아먹었습니다. 결국 Rx로 구현한 LineChartViewModel을 Rx를 포기하고 SwiftUI의 내장 @Published, @ObservedObject 래퍼를 사용해 버튼 처리와 데이터 로드는 구현이 되었습니다. 그러나 뷰모델이 init되었을 때만 애니메이션이 생성되고 버튼 클릭 시엔 생성되지 않은 문제점은 해결하지 못하였습니다.

##[6] If i...

*만약 본 사전과제를 처음 부터 다시 한다면(직접 핀테크 앱을 구현한다고 생각하며)*

- 트랜잭션 매니저는 현재와 같이 싱글톤 패턴으로 두어 메모리 효율적으로 합니다. 트랜잭션 매니저는 현 기능에 사용되는 모든 ViewModel에 존재해야 하며 핀테크 앱 내 대다수의 기능에 사용되기에 싱글톤 패턴을 채택해 메모리를 아낄 수 있습니다.
- LineChart는 SwiftUI 그대로 구현합니다. 그래프를 그리는 여러 오픈소스 라이브러리를 보고 가장 인기가 많은 'Charts'를 사용해보았을 때, 훨씬 편하고 쉽게 구현할 수 있습니다. 그러나 디테일한 부분을 구현하기 어렵고, 개인적인 성장이 더뎌질 것 같은 이유로 SwiftUI의 내장 Chart를 써서 구현하고 싶습니다. SwiftUI와 UIKit의 연결은 현 iOS 생태계에서 피할 수 없는 과정으로 생각하고 있기에 꼭 한번 구현해볼 것 같습니다.
- 스레드 처리와 사용자 경험에 더 초점을 맞출 것 같습니다. 현재까지 구현한 방식으로는 백그라운드에서 데이터 처리하고 메인 스레드에서 UI를 업데이트하도록 하였으나 데이터 처리 동안 화면이 멈춰있는 이슈가 있어 사용자 경험이 저하됩니다. 그동안 Indicator를 보여주어 UI가 업데이트 중인 것을 알릴 수 있도록 사용자 관점에서 기능 구현에 더 힘써야 할 것 같습니다. 


<!--Url for Badges-->
[license-shield]: https://img.shields.io/github/license/dev-ujin/readme-template?labelColor=D8D8D8&color=04B4AE
[repository-size-shield]: https://img.shields.io/github/repo-size/dev-ujin/readme-template?labelColor=D8D8D8&color=BE81F7
[issue-closed-shield]: https://img.shields.io/github/issues-closed/dev-ujin/readme-template?labelColor=D8D8D8&color=FE9A2E

<!--Url for Buttons-->
[readme-eng-shield]: https://img.shields.io/badge/-readme%20in%20english-2E2E2E?style=for-the-badge
[view-demo-shield]: https://img.shields.io/badge/-%F0%9F%98%8E%20view%20demo-F3F781?style=for-the-badge
[view-demo-url]: https://dev-ujin.github.io
[report-bug-shield]: https://img.shields.io/badge/-%F0%9F%90%9E%20report%20bug-F5A9A9?style=for-the-badge
[report-bug-url]: https://github.com/dev-ujin/readme-template/issues
[request-feature-shield]: https://img.shields.io/badge/-%E2%9C%A8%20request%20feature-A9D0F5?style=for-the-badge
[request-feature-url]: https://github.com/dev-ujin/readme-template/issues
[license-url]: https://delightlabs.io

<!--URLS-->
[contribution-url]: CONTRIBUTION.md
[readme-eng-url]: ../README.md


