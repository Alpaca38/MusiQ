# MusiQ

## 프로젝트 소개
> 음악을 듣거나 앨범 커버를 보고 제목이나 아티스트를 맞추는 음악 퀴즈 앱

### 최소 지원 버전
> iOS 16

### 개발 환경
- **IDE** : Xcode 15.4
- **Language** : Swift 5.7

### 핵심 기능
- **퀴즈 모드 선택|** REST API 통신, 노래 듣고 맞추기, 앨범 커버 보고 맞추기
- **다양한 음악 카테고리 |** R&B, 힙합, kpop, 모든 장르 등
- **퀴즈 히스토리 |** Realm에 모드별 카테고리별 참여한 퀴즈 결과, 정답률을 저장하고 차트로 확인
- **다크 모드 |**
- **다국어 지원 |** 영어 대응

### 구조
- **MVI**
![MVI](https://github.com/user-attachments/assets/425673c7-d7c8-4f2b-bf05-f231f30728b3)


### 사용 기술 및 라이브러리
- MVVM / Realm
- SwiftUI, Combine
- Charts / MusicKit / Apple Music API
- NWPathMonitor

### 화면
| 퀴즈 모드 선택 | 퀴즈 모드 선택 | 노래 듣고 맞추기 | 앨범 커버 보고 맞추기 | 틀린 문제 목록 | 차트 |
| --- | --- | --- | --- | --- | --- |
| ![IMG_1993](https://github.com/user-attachments/assets/04474397-aec0-4074-806b-7d2bed905b51) | ![IMG_2001](https://github.com/user-attachments/assets/94acba63-dba6-47a1-a62f-631b78bce3f8) | ![IMG_2028](https://github.com/user-attachments/assets/28f00616-292e-41cc-8a3e-43573211ac13)  | ![IMG_1999](https://github.com/user-attachments/assets/5277f25e-30d5-434a-ab03-ca13bf365460) | ![IMG_1994](https://github.com/user-attachments/assets/b8970a14-624c-4cf9-9fca-c97b32d84b8d) | ![IMG_1995](https://github.com/user-attachments/assets/7e859949-2298-4cb9-95bb-8cdb236ab4f4) |
