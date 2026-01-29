# Walkthrough - The Come & Stay Clone

이 문서는 프로젝트의 주요 변경 사항과 구조를 설명합니다.

## 주요 변경 사항

### 1. 프로젝트 구조 초기화
- 기존의 기본 카운터 앱 코드를 제거하고 'The Come & Stay' 클론을 위한 구조로 변경했습니다.

### 2. 테마 및 스타일
- **Colors**: 브랜드 컬러인 Teal(#00A7B0)을 메인으로 사용했습니다.
- **Fonts**: Google Fonts의 `Noto Sans KR`을 적용하여 깔끔한 고딕 스타일을 유지했습니다.

### 3. 반응형 디자인 (Responsive Design)
- `LayoutBuilder`와 화면 너비(Width)를 기준으로 `Mobile` 뷰와 `Desktop` 뷰를 구분했습니다.
- **Mobile**: 약 800px 미만일 때. 햄버거 메뉴와 2컬럼 그리드를 사용.
- **Desktop**: 800px 이상일 때. 상단 전체 메뉴와 4컬럼 그리드를 사용.

### 4. 주요 위젯 구조
- `HomeScreen`: 전체 페이지의 스크롤을 담당합니다.
- `HomeHeader`: 상단 네비게이션 바. 스크롤에 따라 Sticky하게 동작하거나 상단에 고정됩니다.
- `HeroSection`: 메인 검색 영역.
- `HouseCard`: 개별 매물 정보를 보여주는 카드 컴포넌트.

## 실행 방법

### Web 실행
```bash
flutter run -d chrome
```

### Mobile 실행
```bash
flutter run -d <device-id>
```
