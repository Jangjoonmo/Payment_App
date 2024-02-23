# 페이먼트 앱

<!--프로젝트 대문 이미지-->
![Simulator Screenshot - iPhone 15 Pro - 2024-02-23 at 13 12 55](https://github.com/Jangjoonmo/delight_labs_assignment/assets/99167099/6ae33af9-20fa-4900-880a-a9db0bc23fc7)


![Project Title](img/project-title.png)

<!--목차-->
# 목차
- [[1] 안내](#1-about-the-project)
  - [주의 사항](#주의사항)
  - [요구 사항](#요구사항)
- [[2] 개발 환경](#2-getting-started)
  - [Technologies](#Technologies)
  - [Installation](#installation)
  - [Configuration](#configuration)
- [[3] Usage](#3-usage)
- [[4] Contribution](#4-contribution)
- [[5] Acknowledgement](#5-acknowledgement)
- [[6] Contact](#6-contact)
- [[7] License](#7-license)



# [1] DELIGHT LABS iOS - 사전 과제
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

## 사용 기술
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


## Mocking Data Parsing
- 63MB의 Json파일, 총 612,000개의 데이터를 파싱하여 Realm에 저장하였습니다.
<img width="150" alt="image" src="https://github.com/Jangjoonmo/delight_labs_assignment/assets/99167099/26219386-8476-403b-bdfe-57498803f5c5">
<img width="150" alt="image" src="https://github.com/Jangjoonmo/delight_labs_assignment/assets/99167099/91ba2e66-f073-4380-8a0c-5e939bca0c91">
<img width="927" alt="image" src="https://github.com/Jangjoonmo/delight_labs_assignment/assets/99167099/cde5f655-9fce-41bd-977c-605f7ce70792">

```swift
 func parseJSON() {  //Json Mock 데이터 받아와서 Realm에 저장
        DispatchQueue.main.async {
            print("parseJSON 실행")
            let url = URL(fileURLWithPath: "/Users/jangjoonmo/Downloads/delightlabs-ios-hometest-mockdata-2024.json")
            do {
                let data = try Data(contentsOf: url)
                let transactions = try JSONDecoder().decode([Transaction].self, from: data)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                
                let transactionDataList = transactions.map { transaction -> TransactionData in
                    let transactionData = TransactionData()
                    transactionData.name = transaction.name
                    transactionData.amount = transaction.amount
                    if let date = dateFormatter.date(from: transaction.timestamp) {
                        transactionData.timestamp = date
                    }
                    transactionData.type = transaction.type
                    transactionData.transactionType = transaction.amount.hasPrefix("-") ? "expense" : "income"
                    return transactionData
                }
                
                try! self.realm.write {
                    for batch in transactionDataList.chunks(of: 1000) {  // 1000개씩 받아와서 저장
                        self.realm.add(batch)
                    }
                }
                UserDefaults.standard.set(true, forKey: "uploadCompleted")
                print("parsing 완료")
            } catch {
                print(error)
            }
        }
    }```



# [4] Contribution
기여해주신 모든 분들께 대단히 감사드립니다.[`contributing guide`][contribution-url]를 참고해주세요.
이 프로젝트의 기여하신 분들을 소개합니다! 🙆‍♀️
*이모티콘 쓰는 것을 좋아한다면, 버그 수정에 🐞, 아이디어 제공에 💡, 새로운 기능 구현에 ✨를 사용할 수 있습니다.*
- 🐞 [dev-ujin](https://github.com/dev-ujin): 메인페이지 버그 수정



# [5] Acknowledgement
***유사한 프로젝트의 레포지토리** 혹은 **블로그 포스트** 등 프로젝트 구현에 영감을 준 출처에 대해 링크를 나열하세요.*

- [Readme Template - Embedded Artistry](https://embeddedartistry.com/blog/2017/11/30/embedded-artistry-readme-template/)
- [How to write a kickass Readme - James.Scott](https://dev.to/scottydocs/how-to-write-a-kickass-readme-5af9)
- [Best-README-Template - othneildrew](https://github.com/othneildrew/Best-README-Template#prerequisites)
- [Img Shields](https://shields.io/)
- [Github Pages](https://pages.github.com/)


# [7] License
MIT 라이센스
라이센스에 대한 정보는 [`DELIGHT LABS`][license-url]에 있습니다.



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


