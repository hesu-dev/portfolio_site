# Nell Weather - 구현 계획 (Implementation Plan)

## Phase 1: 기반 구축 (Foundation)
- [ ] **프로젝트 초기 설정**
    - [ ] `pubspec.yaml` 의존성 추가
        - 상태 관리: `flutter_riverpod`
        - 라우팅: `go_router`
        - 네트워크: `dio`
        - 로컬 저장소: `shared_preferences` (설정), `hive` + `hive_flutter` (데이터)
        - UI 유틸: `flutter_screenutil` (반응형), `google_fonts`
    - [ ] 폴더 구조 생성
        - `lib/core/` (상수, 에러 처리, 유틸리티)
        - `lib/config/` (테마, 라우터)
        - `lib/data/` (API, 모델, 리포지토리)
        - `lib/features/` (기능별 화면 및 로직: onboarding, weather, settings, memo)
        - `lib/shared/` (공통 위젯)

- [ ] **디자인 시스템 구현**
    - [ ] `lib/config/theme.dart`: 다크 테마, 컬러 팔레트 정의
    - [ ] `lib/core/constants/app_colors.dart`: 색상 상수 정의
    - [ ] `lib/core/constants/app_text_styles.dart`: 폰트 스타일 정의

## Phase 2: UI 스켈레톤 구현 (UI Skeleton)
- [ ] **네비게이션 설정**
    - [ ] `go_router` 라우팅 설정 (Onboarding -> Main, Main <-> Settings)
- [ ] **온보딩 화면 (`features/onboarding`)**
    - [ ] PageView 위젯을 사용한 3단계 슬라이드 구현
    - [ ] "시작하기" 버튼 및 최초 실행 플래그(`shared_preferences`) 저장 로직
- [ ] **메인 화면 (`features/weather/presentation`)**
    - [ ] 상단 요약 카드 (Summary Card) 더미 UI
    - [ ] 시간대별 예보 (Hourly Forecast) 가로 스크롤 더미 UI
    - [ ] 주간 예보 (Weekly Forecast) 리스트 더미 UI
- [ ] **설정 화면 (`features/settings`)**
    - [ ] 알림 민감도(Quiet/Standard/Active) 선택 UI
    - [ ] 스위치 버튼 (데일리 브리핑 등)

## Phase 3: 날씨 데이터 연동 (Weather Data)
- [ ] **데이터 계층 구현 (`data/`)**
    - [ ] OpenWeatherMap API 연동 (Dio 클라이언트)
    - [ ] `WeatherModel` 생성 (JSON 직렬화/역직렬화)
    - [ ] `WeatherRepository` 구현 (API 호출 및 에러 핸들링)
- [ ] **상태 관리 (`features/weather/provider`)**
    - [ ] `weatherProvider`: 현재 날씨 상태 관리
    - [ ] UI와 데이터 바인딩

## Phase 4: 알림 시스템 (Notification System)
- [ ] **백그라운드 작업 설정**
    - [ ] `workmanager` (Android) / Background Fetch (iOS) 설정
- [ ] **로컬 알림 구현**
    - [ ] `flutter_local_notifications` 설정
- [ ] **알림 로직 구현 (`core/services/notification_service.dart`)**
    - [ ] 이전 날씨 데이터 캐싱 (Hive 사용)
    - [ ] 주기적 데이터 Fetch 및 비교 (Diff Check)
    - [ ] 조건(비 시작, 위험 등) 충족 시 알림 발송
    - [ ] 설정(Quiet/Standard)에 따른 필터링

## Phase 5: 메모 기능 (Memo)
- [ ] **데이터베이스 설정**
    - [ ] Hive Box 설정 및 모델링 (`WeatherMemo`)
- [ ] **메모 UI 구현**
    - [ ] 날짜별 메모 리스트 화면 (메인 하단 or 별도 탭)
    - [ ] 메모 작성 모달/페이지 (아이콘 선택 + 텍스트 입력)
- [ ] **기능 구현**
    - [ ] CRUD 로직 (작성, 조회, 수정, 삭제)

## Phase 6: 폴리싱 & 배포 준비 (Polish)
- [ ] **UI/UX 개선**
    - [ ] 애니메이션 추가 (Hero, FadeTransition)
    - [ ] 로딩/에러 상태 처리 (Skeleton Loader)
- [ ] **아이콘 및 스플래시**
    - [ ] `flutter_launcher_icons` 설정
    - [ ] `flutter_native_splash` 설정
