# Implementation Plan - 날씨 반응형 픽셀 아트 및 배경 구현

## 개요
사용자의 요청에 따라 메인 화면에 날씨에 반응하는 '다마고치 스타일' 픽셀 아트 캐릭터를 추가하고, 날씨 상태에 따라 배경이 동적으로 변하도록 수정합니다. 또한, 사용자가 픽셀 아트를 직접 만들 수 있는 간단한 에디터를 구현합니다.

## 구현 상세

### 1. 픽셀 아트 캐릭터 위젯 (WeatherCharacterWidget)
- **위치**: `lib/features/weather/presentation/widgets/weather_character_widget.dart`
- **기능**:
  - `weatherCondition`을 입력받아 적절한 픽셀 아트 표시.
  - 임시 구현으로 'Sunny'일 때는 산책하는 모션(또는 아이콘), 'Rain'일 때는 우산 쓴 모습 등을 8x8 또는 16x16 그리드 형태의 `Canvas` 드로잉 혹은 아이콘으로 표현.
  - 메인 화면 온도 표시 영역에 배치.

### 2. 동적 배경 (Dynamic Background)
- **위치**: `lib/features/weather/presentation/weather_screen.dart` 및 유틸리티 클래스
- **기능**:
  - 날씨 상태(`condition`)에 따라 `LinearGradient`를 반환하는 로직 추가.
  - 맑음: 파란/하늘색 그라디언트
  - 비: 회색/남색 그라디언트
  - 흐림: 회색조 그라디언트
  - 밤(시간 체크 가능하면): 어두운 보라/검정 그라디언트

### 3. 메인 화면 수정 (WeatherScreen)
- `CurrentWeatherHeader` 혹은 `WeatherScreen` 내부에 `WeatherCharacterWidget` 배치.
- `Scaffold`의 `backgroundColor` 대신 `Container`의 `decoration`으로 동적 배경 적용.

### 4. 픽셀 아트 메이커 (Pixel Art Maker)
- **위치**: `lib/features/pixel_maker/`
- **기능**:
  - 간단한 16x16 그리드 에디터 화면 구현.
  - 색상 선택 및 그리드 터치로 그리기 기능.
  - 이스터에그나 설정 메뉴 등을 통해 접근 가능하도록(혹은 별도 화면으로 라우팅).

## 작업 순서
1. `WeatherCharacterWidget` 구현 (임시 픽셀 아트)
2. `WeatherScreen` 배경 로직 및 캐릭터 위젯 배치
3. `PixelArtMakerScreen` 기본 구현 및 라우터 연결
