# 구현 계획: Firebase Auth 및 Stripe 결제 연동

이 문서는 `nell_weather` 프로젝트에 Firebase 인증 (로그인) 및 Stripe 결제 (구독) 기능을 추가하기 위한 계획입니다.

## 1. 사전 준비 (User 측 제공 필요)

### 1.1 Firebase 프로젝트 설정
- [ ] Firebase Console에서 프로젝트 생성
- [ ] Authentication 활성화 (이메일/비밀번호, Google 로그인 등)
- [ ] 앱 등록 (Android/iOS) 및 구성 파일 다운로드:
    - Android: `google-services.json` -> `android/app/` 폴더에 배치
    - iOS: `GoogleService-Info.plist` -> `ios/Runner/` 폴더에 배치 (Xcode를 통해 추가 권장)

### 1.2 Stripe 계정 및 설정
- [ ] Stripe 대시보드에서 계정 생성 및 개발자 모드 활성화
- [ ] **Publishable Key** 발급 (앱 내 사용)
- [ ] (권장) **Firebase Extension: Run Payments with Stripe** 설치
    - 결제 백엔드 로직을 직접 구현하지 않고 Firebase 확장 프로그램을 사용하는 가장 간편한 방법입니다.
    - 이 확장을 설치하면 'products', 'customers' 컬렉션이 Firestore에 자동 생성됩니다.
    - Stripe 대시보드에서 '상품(Product)' 및 '가격(Price - 월간)'을 생성해야 합니다.

## 2. 패키지 설치

`pubspec.yaml`에 다음 패키지들을 추가합니다.

```yaml
dependencies:
  # Firebase
  firebase_core: latest
  firebase_auth: latest
  google_sign_in: latest
  cloud_firestore: latest # 사용자 정보 및 구독 정보 저장용

  # Stripe
  flutter_stripe: latest
```

## 3. 기능 구현 단계

### 3.1 Firebase 초기화 및 Auth 구현
- `main.dart`: Firebase 초기화 코드 추가
- `AuthRepository`: Riverpod을 이용한 인증 상태 관리
    - 로그인 (이메일, Google)
    - 회원가입
    - 로그아웃
    - 인증 상태 변경 감지 (`authStateChanges`)
- `LoginScreen`: 로그인 UI 구현

### 3.2 Stripe 결제 기능 구현
- `StripeService`: Stripe 결제 로직 담당
    - 카드 정보 입력 및 결제 시트 표시
    - (Extension 사용 시) Firestore의 `customers/{uid}/checkout_sessions`에 문서를 추가하여 결제 세션 시작
- `SubscriptionScreen`: 구독 결제 UI
    - 월 결제 버튼
    - 결제 성공/실패 처리
    - 현재 구독 상태 표시 (Firestore의 `customers/{uid}/subscriptions` 확인)

## 4. 폴더 구조 예시 (제안)

```
lib/
  features/
    auth/
      data/
        auth_repository.dart
      presentation/
        login_screen.dart
    payment/
      data/
        payment_service.dart
      presentation/
        subscription_screen.dart
```

## 5. 사용자에게 요청할 정보 요약
작업을 진행하기 위해 다음 정보나 파일이 필요합니다.
1. `google-services.json` (Android)
2. `GoogleService-Info.plist` (iOS)
3. Stripe Publishable Key
4. (선택) Firebase Extension 사용 여부 확인 (사용 시 백엔드 코드 작성 불필요)
