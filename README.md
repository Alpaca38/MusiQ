# MusiQ

## 프로젝트 소개
> 음악을 듣거나 앨범 커버를 보고 제목이나 아티스트를 맞추는 음악 퀴즈 앱
<a href="https://apps.apple.com/kr/app/musiq-%EB%85%B8%EB%9E%98-%EB%A7%9E%EC%B6%94%EA%B8%B0/id6711330766">
    <img width="200" alt="appstore" src="https://github.com/nbcamp-archive/kkuk-ios/assets/26790710/72caf6ff-b829-4608-98d9-16d42d0a3eb0">
</a>

### 화면
| 퀴즈 모드 선택 | 퀴즈 모드 선택 | 노래 듣고 맞추기 | 앨범 커버 보고 맞추기 | 틀린 문제 목록 | 차트 |
| --- | --- | --- | --- | --- | --- |
| <img src="https://github.com/user-attachments/assets/220b4c00-6ff9-44ac-af24-59394840f0e3" width="200"> | <img src="https://github.com/user-attachments/assets/5debaa2a-6fa0-49cd-a013-63dbaa664d11" width="200"> | <img src="https://github.com/user-attachments/assets/84038279-d8d2-47dd-b1b2-df49dbea1df1" width="200"> | <img src="https://github.com/user-attachments/assets/34768baf-7ca2-40ef-b259-4823acdffdde" width="200"> | <img src="https://github.com/user-attachments/assets/b8970a14-624c-4cf9-9fca-c97b32d84b8d" width="200"> | <img src="https://github.com/user-attachments/assets/7e859949-2298-4cb9-95bb-8cdb236ab4f4" width="200"> |

### 최소 지원 버전
> iOS 16

### 개발 기간
> 2024.09.13 ~ 2024.09.27

### 개발 환경
- **IDE** : Xcode 15.4
- **Language** : Swift 5.10

### 핵심 기능

- **퀴즈 모드**
    - 노래 맞히기
    - 앨범 커버 맞히기
    - 다양한 음악 장르 지원 (R&B, 힙합, K-pop)
    - 오답 노트 및 다양한 통계 지원

- **음악 연동 기능**
    - Apple Music 연동
    - 실시간 음악 재생

- **다국어 지원**
    - 영어 인터페이스 지원
    - 한국어 인터페이스 지원
    - 현지화 지원

### 사용 기술 및 라이브러리
- MVI / Realm
- SwiftUI, Combine
- Charts / MusicKit / Apple Music API
- NWPathMonitor

### 주요 기술
- **MVI**
![MVI](https://github.com/user-attachments/assets/425673c7-d7c8-4f2b-bf05-f231f30728b3)
    - 상태를 Intent를 통해서만 변경이 가능하도록 단방향 아키텍처 구현
    - View는 Model을 직접 참조하지 않고 Intent와 Model로 구성된 Container를 참조
    - 상태 변화(Model)와 로직(Intent)을 분리
    - 상태 변화를 추적하기 쉽고 항상 예측이 가능한 형태로 구성됨
    - 각 요소들이 역할에 따라 분리되어 있어 확장 및 유지보수 용이

- **NWPathMonitor**
    - 네트워크 상태를 다루는 Model과 로직을 다루는 Intent로 구성된 Container를 구성하고 ContentView에 주입
    - @StateObject로 객체의 상태에 따라 뷰 업데이트
      <p align="center">
      <img src="https://github.com/user-attachments/assets/b1d18304-23b6-4088-b86f-adb0dd78c0da" width="200" height="400"/> <img src="https://github.com/user-attachments/assets/2a9e23fb-714c-49d6-a69e-769246dc2444" width="200" height="400"/>
      </p>

- **modelChangePublisher**
  - modelChangePublisher를 통해 Model의 변경사항을 감지하고, objectWillChange.send()를 호출하여 뷰 업데이트
  - 구독을 Cancellable에 저장하여 인스턴스 해제 시 자동 구독 해제
 
- **화면 전환**
    - 마지막 퀴즈 이후 첫 화면으로 되돌아가기 위해 RootContainer 활용
    - API 통신을 통해 응답받는 Content의 상태를 열거형으로 구성하고 Content의 상태에 따라 다른 View가 나타나도록 구현
 
- **ViewModifier**
    - ViewModifier를 사용해 커스텀 UI의 재사용성 증대
    - ViewModifier의 내부구조는 private으로 은닉화하고 View의 Extension을 활용

- **String Catalog**
    - String Catalog를 사용해 다국어 지원
    - String을 확장해 NSLocalizedString 반환

### 트러블 슈팅
    ForEach로 구성된 List나 Grid에 NavigationLink 사용 시 NavigationLink를 누르지 않아도 Link안의 View들이 모두 Init 되는 문제 발생
    이러한 문제를 해결하기 위해 View를 생성하는 Closure를 이용해 Wrapping 하는 NavigationLazyView 구현
    @autoclosure를 사용해 간결하게 사용할 수 있도록 구성

### 업데이트
- 노래 개수를 선택할 수 있는 기능 추가 (v 1.1.0)
- 애플 뮤직 구독자의 경우 틀린 문제 목록 노래 재생 기능 추가 및 코드 개선 (v 1.2.1)
- UI 개선 (v 1.3)
