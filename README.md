# MusiQ

## 프로젝트 소개
> 음악을 듣거나 앨범 커버를 보고 제목이나 아티스트를 맞추는 음악 퀴즈 앱
<a href="https://apps.apple.com/kr/app/musiq-%EB%85%B8%EB%9E%98-%EB%A7%9E%EC%B6%94%EA%B8%B0/id6711330766">
    <img width="200" alt="appstore" src="https://github.com/nbcamp-archive/kkuk-ios/assets/26790710/72caf6ff-b829-4608-98d9-16d42d0a3eb0">
</a>

### 화면
| 퀴즈 모드 선택 | 퀴즈 모드 선택 | 노래 듣고 맞추기 | 앨범 커버 보고 맞추기 | 틀린 문제 목록 | 차트 |
| --- | --- | --- | --- | --- | --- |
| ![IMG_1993](https://github.com/user-attachments/assets/04474397-aec0-4074-806b-7d2bed905b51) | ![IMG_2001](https://github.com/user-attachments/assets/94acba63-dba6-47a1-a62f-631b78bce3f8) | ![IMG_2028](https://github.com/user-attachments/assets/28f00616-292e-41cc-8a3e-43573211ac13)  | ![IMG_1999](https://github.com/user-attachments/assets/5277f25e-30d5-434a-ab03-ca13bf365460) | ![IMG_1994](https://github.com/user-attachments/assets/b8970a14-624c-4cf9-9fca-c97b32d84b8d) | ![IMG_1995](https://github.com/user-attachments/assets/7e859949-2298-4cb9-95bb-8cdb236ab4f4) |

### 최소 지원 버전
> iOS 16

### 개발 기간
> 2024.09.13 ~ 2024.09.27

### 개발 환경
- **IDE** : Xcode 15.4
- **Language** : Swift 5.7

### 핵심 기능
- **퀴즈 모드 선택 |** REST API 통신, 노래 듣고 맞추기, 앨범 커버 보고 맞추기
- **다양한 음악 카테고리 |** R&B, 힙합, kpop, 모든 장르 등
- **퀴즈 히스토리 |** Realm에 모드별 카테고리별 참여한 퀴즈 결과, 정답률을 저장하고 차트로 확인
- **다크 모드 |**
- **다국어 지원 |** 영어 대응
- **네트워크 |** 네트워크 연결 상태 대응

### 사용 기술 및 라이브러리
- MVI / Realm
- SwiftUI, Combine
- Charts / MusicKit / Apple Music API
- NWPathMonitor

### 주요 기술
- **MVI**
![MVI](https://github.com/user-attachments/assets/425673c7-d7c8-4f2b-bf05-f231f30728b3)
- **MVVM과 MVI 중 MVI를 선택한 이유**
    - **단방향 데이터 흐름**
        - MVI 패턴에서는 모든 데이터 흐름이 단방향으로 이루어집니다. 사용자 액션이 발생하면 Intent가 생성되고, 이 Intent가 처리된 후 새로운 상태(State)로 전환됩니다. SwiftUI는 상태 기반 UI 업데이트를 지원하므로, 이런 단방향 데이터 흐름이 SwiftUI의 선언적 UI 업데이트 방식과 자연스럽게 어우러집니다.
    - **명확한 상태 관리**
        - MVI는 View가 오직 하나의 상태(State)만 참조하도록 강제합니다. MVVM에서는 ViewModel에서 상태 변화와 로직 처리가 섞일 수 있어 복잡해질 수 있지만, MVI는 상태(Model)와 로직(Intent)이 명확히 분리되어 더 나은 관리가 가능합니다.
    - **명시적인 상태 전이**
        - MVI는 상태가 전이되는 과정이 명확하게 드러납니다. 모든 상태 전이는 특정 Intent로 인해 발생하며, 이로 인해 상태 변화를 추적하거나 디버깅하는 것이 쉬워집니다. 반면에 MVVM에서는 상태 전이가 명확하지 않고 여러 곳에서 상태가 변할 수 있어 복잡도가 증가할 수 있습니다.
    - **결론**
        - SwiftUI는 UI를 상태 기반으로 업데이트하는 구조이므로, 명확하고 일관된 상태 관리와 단방향 데이터 흐름을 강조하는 MVI 패턴이 MVVM보다 더 적합하다고 생각했습니다.
     
- **네트워크 연결 상태 모니터링**
    - NWPathMonitor로 네트워크 상태를 감지하는 객체를 구성했습니다. @StateObject로 객체의 상태에 따라 뷰를 변화시켜 주었습니다.
      <p align="center">
      <img src="https://github.com/user-attachments/assets/b1d18304-23b6-4088-b86f-adb0dd78c0da" width="200" height="400"/> <img src="https://github.com/user-attachments/assets/2a9e23fb-714c-49d6-a69e-769246dc2444" width="200" height="400"/>
      </p>


### 업데이트
- 노래 개수를 선택할 수 있는 기능 추가 (v 1.1.0)
- 애플 뮤직 구독자의 경우 틀린 문제 목록 노래 재생 기능 추가 및 코드 개선 (v 1.2.1)
