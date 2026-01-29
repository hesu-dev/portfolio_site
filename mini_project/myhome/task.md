# Task: The Come & Stay 홈페이지 클론 (프론트엔드)

## 목표
- [https://www.thecomenstay.com/](https://www.thecomenstay.com/) 웹사이트의 프론트엔드를 Flutter로 클론합니다.
- 웹과 모바일 모두 대응 가능한 반응형 디자인을 구현합니다.
- 기능(백엔드 연동 등)을 제외하고 UI/UX 구현에 집중합니다.

## 주요 구현 사항
1.  **전역 테마 및 스타일 설정**
    - 색상: Primary Teal (#00A7B0), Text Dark Grey (#333333), Background White/Light Grey.
    - 폰트: Noto Sans KR (구글 폰트 적용).

2.  **반응형 레이아웃 구조 (Responsive Layout)**
    - 모바일: 햄버거 메뉴, 1-2컬럼 그리드.
    - 웹(데스크탑): 상단 전체 메뉴, 4컬럼 그리드, 넓은 히어로 섹션.

3.  **주요 섹션 구현**
    - **Header (AppBar):** 로고, 메뉴 (반응형).
    - **Hero Section:** 배경 이미지, 검색 탭 (역세권청년주택, 쉐어하우스, 원룸).
    - **House Grid:** "Today's 인기하우스" 카드 리스트.
    - **Tabs Section:** 최근 본 하우스 / 관심 하우스 탭.
    - **Service Banners:** 중간 배너 영역.
    - **Footer:** 사이트 정보 및 링크.

## 진행 상황
- [ ] 프로젝트 설정 및 패키지 추가 (google_fonts 등)
- [ ] 테마 (Colors, Fonts) 구성
- [ ] 공통 위젯 구현 (HouseCard, ResponsiveWrapper)
- [ ] 메인 홈 화면 UI 작업
- [ ] 웹/모바일 반응형 테스트
