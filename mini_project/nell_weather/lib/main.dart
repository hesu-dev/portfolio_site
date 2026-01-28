import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'config/router.dart';
import 'config/theme.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/services/notification_service.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'features/settings/provider/settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Load Constants & Env
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("Failed to load .env file: $e");
    // Proceed without .env (API calls might fail, but UI should load)
  }

  // 2. Initialize Hive
  try {
    await Hive.initFlutter();
    await Hive.openBox('settings');
  } catch (e) {
    debugPrint("Failed to init Hive: $e");
  }

  // 3. Initialize Services (Non-blocking for UI)
  initializeServices();

  runApp(const ProviderScope(child: MyApp()));
}

Future<void> initializeServices() async {
  try {
    final notificationService = NotificationService();
    await notificationService.init();

    // Background Service removed due to incompatibility on iOS
  } catch (e) {
    debugPrint("Service initialization failed: $e");
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch settings to update theme/locale
    final settingsState = ref.watch(settingsProvider);

    // ScreenUtilInit: 반응형 UI 설정을 위한 초기화
    // 디자인 기준 사이즈 (예: Figma 기준 375x812)
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Nell Weather',
          debugShowCheckedModeBanner: false,

          // Theme Configuration
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: settingsState.themeMode,

          // Locale Configuration
          locale: settingsState.locale,
          supportedLocales: const [
            Locale('en', ''), // English
            Locale('ko', ''), // Korean
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          routerConfig: router,
        );
      },
    );
  }
}
