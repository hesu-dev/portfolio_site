# Task: Silent Weather App "Nell Weather" 기획 및 초기 설계

## 개요
"필요할 때만 알려주는 조용한 날씨 앱"이라는 컨셉을 바탕으로, iOS/Android 하이브리드 앱(Flutter)을 기획하고 설계를 진행합니다.
사용자 요청에 따라 UX 원칙을 정의하고, 화면 흐름과 알림 로직을 구체화하며, 이를 구현하기 위한 Flutter 프로젝트 구조를 잡습니다.

## 진행 상황
- [x] 기획서 (Product Specs) 작성 (한국어)
- [x] 구현 계획 (Implementation Plan) 작성 (한국어)
- [x] 아키텍처 문서 (Folder Structure) 작성
- [x] Flutter 프로젝트 구조 리팩토링 및 기본 테마 설정 (`main.dart` Setup 완료)
- [x] UI 스켈레톤 및 라우팅 설정 완료
- [x] 온보딩 화면 구현
- [x] 메인 화면 UI 구현 (Riverpod 상태 관리 연동 완료)
- [x] 설정 화면 UI 구현
- [x] 날씨 데이터 실제 API 연동 완료 (RepositoryImpl 구현, .env 설정)
- [x] 알림 로직 구현 (Background Service, Local Notification)
- [x] Hive 초기 설정 완료

## 목표
- 명확한 UX/UI 가이드라인 수립
- "Silent First" 철학이 반영된 알림 로직 설계
- 확장 가능한 Flutter 아키텍처 구축

## 다음 단계 (Next Steps)
1. `.env` 파일에 실제 OpenWeatherMap API Key 입력 (`OPENWEATHER_API_KEY=...`)
2. `weather_provider.dart` 에서 `useRealData = true` 로 변경하여 실제 API 테스트
3. 로그인 및 메모 기능 상세 구현 (Hive Box 모델링)
