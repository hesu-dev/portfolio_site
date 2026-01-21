// ignore_for_file: non_constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// 키 주입 우선순위:
/// 1) --dart-define=KARI_SERVICE_KEY=xxxx
/// 2) (선택) dotenv 사용 시 여기에 연결
///
/// Flutter Web 배포에서 .env는 번들에 포함되면 노출될 수 있음.
/// 정말 민감하면 서버를 두는 게 정석이지만, 요청 조건상 앱 내 포함으로 처리.
class AppEnv {
  static const String screatBaseUrl =
      'http://apis.data.go.kr/B090041/openapi/service/LrsrCldInfoService';

  static const String _webServiceKey = String.fromEnvironment(
    'APP_SECRET_KEY',
    defaultValue: '',
  );

  static String get ServiceKey {
    // Web
    if (kIsWeb) {
      // 디버그(run) 중일 때는 dotenv 허용
      if (kDebugMode && dotenv.env['APP_SECRET_KEY']?.isNotEmpty == true) {
        return Uri.decodeComponent(dotenv.env['APP_SECRET_KEY']!);
      }

      // 실제 배포(build)에서는 dart-define만 허용
      if (_webServiceKey.isNotEmpty) {
        return Uri.decodeComponent(_webServiceKey);
      }

      return '';
    }

    // Mobile / Desktop
    final key = dotenv.env['APP_SECRET_KEY'];
    return key == null ? '' : Uri.decodeComponent(key);
  }

  static bool get hasKey => ServiceKey.isNotEmpty;
}
