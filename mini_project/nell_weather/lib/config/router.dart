import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/weather/presentation/weather_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../features/settings/presentation/locations/location_management_screen.dart';
import '../features/settings/presentation/sensitivity_screen.dart';
import '../features/settings/presentation/language_screen.dart';
import '../../features/pixel_maker/presentation/pixel_maker_screen.dart';

// 라우터 설정
import 'package:hive_flutter/hive_flutter.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final box = Hive.box('settings');
    final hasSeenOnboarding = box.get(
      'has_seen_onboarding',
      defaultValue: false,
    );
    final isGoingToOnboarding = state.matchedLocation == '/onboarding';

    if (!hasSeenOnboarding) {
      // onboard 안봤으면 onboarding으로 보냄 (단, 이미 그쪽으로 가고 있다면 그대로 둠)
      return isGoingToOnboarding ? null : '/onboarding';
    } else {
      // onboard 봤는데 onboarding으로 가려고 하면 메인으로 보냄 (선택사항, 보통 막음)
      if (isGoingToOnboarding) {
        return '/';
      }
    }
    return null; // 그 외에는 원래 가려던 곳으로
  },
  routes: <RouteBase>[
    GoRoute(
      path: '/onboarding',
      builder: (BuildContext context, GoRouterState state) {
        return OnboardingScreen();
      },
    ),
    GoRoute(
      path: '/',
      pageBuilder: (context, state) {
        return const NoTransitionPage(child: WeatherScreen());
      },
      routes: [
        GoRoute(
          path: 'settings',
          builder: (BuildContext context, GoRouterState state) {
            return SettingsScreen();
          },
          routes: [
            GoRoute(
              path: 'locations',
              builder: (BuildContext context, GoRouterState state) {
                return const LocationManagementScreen();
              },
            ),
            GoRoute(
              path: 'sensitivity',
              builder: (BuildContext context, GoRouterState state) {
                return const SensitivityScreen();
              },
            ),
            GoRoute(
              path: 'language',
              builder: (BuildContext context, GoRouterState state) {
                return const LanguageScreen();
              },
            ),
          ],
        ),
        GoRoute(
          path: 'pixel-maker',
          builder: (BuildContext context, GoRouterState state) {
            return const PixelMakerScreen();
          },
        ),
      ],
    ),
  ],
);
