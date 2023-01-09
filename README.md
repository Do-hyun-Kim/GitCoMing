# GitCoMing

<img width="500" height="500" src="https://user-images.githubusercontent.com/23008224/211275019-0102ac39-c908-48a5-8423-2676ff22fe79.png" alt="github-icon" style="zoom:25%;"/>

## GitCoMing



- 키워드  
  Clean Architecture, Dependency Injection, HTTP,  ReactorKit, RxSwift, RxDataSources, Moya  ,Swift, UIKit, Codebase UI
- 주요 내용  
  GitCoMing 앱은 GitHub API v3를 통해 GitHub의 Repository, User Search, User Organizations을 검색할 수 있도록 만든 검색 앱입니다. Clean Architecture를 이용하여 Presentation, Domain, Repository 영역을 나뉘었으며 복잡한 수정 사항이 생기더라도 쉽게 코드를 파악할 수 있도록 구현하는 것을 초점에 맞추었으며, 무엇보다 특정 계층이 다른 계층에 영향을 주지 않도록 구현하였습니다.

## 개발 환경


- `Swift 5`
- Minimum Target Version: `iOS 13`
- Xcode `14.1` 
- Dependency Manager: `Swift Package Manager`

## 라이브러리

| 라이브러리 명   | 목적                                                       |
| --------------- | ---------------------------------------------------------- |
| `Alamofire`     | 네트워크 통신                                              |
| `RxDataSources` | 비즈니스 로직 분리, UI Configure                           |
| `SnapKit`       | 간편한 Code Base Auto Layout                               |
| `RxSwift`       | Async Programing Logic 처리, Side Effects를 통해 상태 관리 |
| `Then`          | UI Configure, Closure를 이용한 선언형 Code UI              |
| `RxGesture`     | Tap Gesture Animation 관리                                 |


### UI/UX

---
<img width="200" height="400" align="left" src="https://user-images.githubusercontent.com/23008224/211286943-35281777-b6e1-4e61-9155-a2417caddb83.png" alt="github-icon"/> <img width="200" height="400" align="left" src="https://user-images.githubusercontent.com/23008224/211287050-2ef5daaa-a30e-4ea6-97b2-c65e16ccf35a.png" alt="github-icon"/> <img width="200" height="400" align="left" src="https://user-images.githubusercontent.com/23008224/211287444-b77470ee-3ada-49d7-a7cf-f9882ad62983.png" alt="github-icon"/> <img width="200" height="400" align="left" src="https://user-images.githubusercontent.com/23008224/211287625-36c731a3-0774-44d4-8ecd-ac50676d2d17.png" alt="github-icon"/> <br/><br/><br/> <br/> <br/> <br/> <br/> <br/> <br/> <br/> <br/> <br/> <br/> <br/> <br/> <br/>

## GiHub API V3

### SignIn

- SignIn
  - /login/oauth/access_token
    - Code 값을 통하여 AccessToken을 발급 받기 위한 API
- SignInCode
  - /login/oauth/authorize
    - WKWebView를 통하여 Code 값을 발급

### User
- myProfile
  - /user
    - 나의 Profile 조회, (Name, followers, following ,Organizations URL, avatar_url)
- myOrganizations
  - /users/\(userName)/orgs
    - UserName을 통해 사용자의 Organizations Name, avatar_url 조회

- userProfile: 
  - /users/\(userName)
    - userName Keyword를 통해 검색한 사용자의 Profile(Name, followers, following ,Organizations URL, avatar_url) 조회
    
### Search
  - searchRepo
    - /search/repositories
      - q Parameter 값을 통해 Repostiory 검색 및 page key 값으로 Pagination

