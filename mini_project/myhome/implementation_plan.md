# Implementation Plan - The Come & Stay Clone

이 문서는 'The Come & Stay' 홈페이지의 프론트엔드 클론을 위한 구현 계획입니다.

## User Review Required

> [!IMPORTANT]
> - 이미지는 실제 리소스를 다운로드할 수 없으므로, 플레이스홀더(Placeholder) 또는 더미 이미지 URL을 사용합니다.
> - 로고 및 아이콘도 유사한 아이콘으로 대체하거나 텍스트로 처리합니다.

## Proposed Changes

### 1. 프로젝트 설정 및 의존성 추가
- `pubspec.yaml`에 필요한 패키지 추가
    - `google_fonts`: 폰트 적용 (Noto Sans KR)
    - `intl`: 숫자 포맷팅 (임대료 등)

### 2. 테마 및 상수를 위한 설정 파일 생성
- `lib/constants/colors.dart`: 주요 색상 정의
    - Primary: `Color(0xFF00A7B0)`
    - Background: `Color(0xFFF8F9FA)` (연한 회색 배경)
    - Text: `Color(0xFF333333)`
- `lib/constants/text_styles.dart`: 공통 텍스트 스타일 정의

### 3. 메인 레이아웃 및 반응형 구조 잡기
- `lib/main.dart`: MaterialApp 설정 및 Home 연결.
- `lib/screens/home_screen.dart`: 전체 페이지 스크롤 구조 (SingleChildScrollView).
- `lib/widgets/responsive/responsive_layout.dart`: 화면 너비에 따라 Mobile/Desktop 모드 분기 처리.

### 4. 섹션별 위젯 구현 (`lib/widgets/home/...`)
- **Header (`home_header.dart`)**
    - Mobile: 로고 + 햄버거 메뉴 아이콘.
    - Desktop: 로고 + 상단 네비게이션 메뉴 (하우스검색, 더컴앤스테이, 등).
- **Hero Section (`hero_section.dart`)**
    - 배경 이미지 (NetworkImage).
    - 중앙 검색 박스 및 탭 (역세권... / 쉐어하우스 / 원룸).
- **House Grid Section (`house_grid_section.dart`)**
    - "Today's 인기하우스" 타이틀.
    - GridView 또는 Wrap을 사용하여 HouseCard 배치.
- **House Card (`house_card.dart`)**
    - 이미지, 태그(쉐어하우스 등), 제목, 위치, 가격 정보 표시.
- **Footer (`home_footer.dart`)**
    - 회사 정보, 소셜 아이콘, 링크 목록.

### 5. 더미 데이터 생성
- `lib/models/house_model.dart`: 하우스 정보 모델.
- `lib/data/dummy_data.dart`: UI 테스트를 위한 가짜 데이터 리스트.

## Verification Plan

### Automated Tests
- `flutter test`를 통해 기본 위젯 렌더링 확인.

### Manual Verification
- **Web Build:** `flutter run -d chrome`으로 실행하여 데스크탑 뷰 확인.
    - 브라우저 창 크기를 줄여가며 모바일 레이아웃으로 변환되는지 확인.
- **Mobile Build:** 시뮬레이터(iOS/Android)에서 모바일 뷰 확인.
