# Nell Weather - 제품 기획서 (Product Specs)

## 1. 개요
*   **제품명**: Nell Weather (넬 웨더)
*   **컨셉**: 필요할 때만 알려주는 조용한 날씨 유틸리티
*   **핵심 가치**: Silent First, Change-based Notification, Readable > Detailed
*   **플랫폼**: iOS / Android (Flutter 하이브리드)
*   **타겟 사용자**: 잦은 날씨 알림에 피로감을 느끼며, 정말 중요한 날씨 변화만 알고 싶은 사용자

## 2. 핵심 기능

### 2.1 온보딩 (Onboarding)
*   **목표**: 앱의 철학(Silent First)을 사용자에게 전달하고 알림 권한을 자연스럽게 유도
*   **구성**: 3단계 슬라이더 + 시작하기 버튼
    *   **Page 1**: "필요할 때만 알려주는 날씨" - 불필요한 알림 없이 중요한 변화만 전달
    *   **Page 2**: "변화를 감지합니다" - 비 시작/종료, 위험 발생 시 알림 강조
    *   **Page 3**: "조용히, 하지만 정확하게" - 날씨 확인 스트레스 없는 하루 제안
*   **로직**: 최초 실행 여부를 로컬 저장소에 저장, 이후 진입 시 메인으로 직행

### 2.2 메인 화면 (Dashboard)
*   **레이아웃**: 스크롤 가능한 세로형 레이아웃
*   **섹션 1: 오늘의 요약 (Head)**
    *   위치 기반 도시명
    *   현재 온도 (대형 폰트)
    *   날씨 상태 텍스트 (Sunny, Rain, etc.)
    *   **한 줄 코멘트**: AI/데이터 기반의 친근한 조언 (예: "저녁엔 우산을 챙기세요")
*   **섹션 2: 변화 알림 카드 (Contextual Card)**
    *   현재 시점 가장 중요한 기상 변화 표시 (없으면 숨김)
    *   예: "오후 6시에 비 예보", "기온 급격히 하강 중"
*   **섹션 3: 시간대별 예보 (Hourly)**
    *   가로 스크롤
    *   변화 시점(비 시작, 강풍 등)에 아이콘/색상으로 강조 표시
*   **섹션 4: 주간 예보 (Weekly)**
    *   7일 리스트 형태
    *   위험 요소(태풍, 폭우)가 있는 날은 경고 아이콘 표시
*   **섹션 5: 날짜 메모 (Memo)**
    *   로그인 사용자 전용 기능
    *   캘린더/리스트 형태로 날짜별 날씨 관련 메모 표시

### 2.3 메모 기능 (Weather Memo)
*   **기능**: 사용자가 특정 날짜에 날씨와 관련된 개인 일정을 기록
*   **입력 방식**:
    *   **아이콘 태그**: ☔ 비, 🌬️ 바람, ⚠️ 위험 (빠른 선택)
    *   **텍스트**: 자유 입력
*   **필터**: 태그별 모아보기 (비 관련, 위험 관련 등)

### 2.4 설정 (Settings)
*   **알림 민감도 (핵심 UX)**:
    *   🌙 **Quiet**: 위험 경보(태풍, 폭우 등)만 알림
    *   💧 **Standard (기본)**: 비 시작/멈춤 + 위험 경보
    *   🔔 **Active**: 모든 날씨 변화 + 데일리 브리핑
*   **알림 옵션**:
    *   데일리 브리핑 시간 설정 (ON/OFF)
    *   주말 알림 끄기
    *   알림 쿨다운 (빈번한 알림 방지, 최소 1시간 간격 등)

## 3. UI/UX 디자인 가이드
*   **테마**: Dark Mode Only (세련되고 눈이 편안한 다크 그레이 배경)
*   **컬러 팔레트**:
    *   Background: `#121212` (Deep Dark)
    *   Surface: `#1E1E1E` (Card Background)
    *   Primary: `#3B82F6` (Electric Blue - 중요 정보/버튼)
    *   Text High-Emphasis: `#FFFFFF`
    *   Text Medium-Emphasis: `#A0A0A0`
*   **타이포그래피**: 산세리프 계열 (Inter, Roboto, Pretendard 등), 가독성 중시
*   **인터랙션**: 부드러운 카드 입출력 애니메이션, 마이크로 인터랙션 (버튼 클릭 등)

## 4. 데이터 및 알림 로직 설계
*   **Weather Data Source**: OpenWeatherMap API (또는 유사 무료/유료 API)
*   **Local Notification Logic**:
    *   백그라운드에서 주기적(예: 1시간/30분)으로 날씨 데이터 fetch
    *   이전 상태와 비교하여 '변화' 감지
    *   설정된 민감도(Quiet/Standard/Active)에 부합하는 변화일 경우에만 로컬 푸시 발송
    *   서버 비용 절감을 위해 클라이언트 사이드 변동 로직 우선 고려 (단, iOS 백그라운드 제약 사항 고려 필요 - Background Fetch 활용)

## 5. 기술 스택
*   **Framework**: Flutter (Dart)
*   **State Management**: Riverpod or Provider
*   **Local Storage**: SharedPreferences (설정), Hive (날씨 캐시, 메모)
*   **Backend (Optional)**: Firebase Auth (로그인), Firestore (메모 동기화) - 초기에는 로컬 위주로 구현, 추후 확장
