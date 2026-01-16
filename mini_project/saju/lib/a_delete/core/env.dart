import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get serviceKey => dotenv.env['APP_SECRET_KEY'] ?? '';

  static String get gitPage => dotenv.env['GIT_PAGE'] ?? '';

  static String get proxyBaseUrl => dotenv.env['PROXY_BASE_URL'] ?? '';
}
