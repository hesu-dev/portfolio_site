import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/weather/presentation/weather_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';

// 라우터 설정
final GoRouter router = GoRouter(
  initialLocation: '/onboarding',
  routes: <RouteBase>[
    GoRoute(
      path: '/onboarding',
      builder: (BuildContext context, GoRouterState state) {
        return OnboardingScreen();
      },
    ),
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return WeatherScreen();
      },
      routes: [
        GoRoute(
          path: 'settings',
          builder: (BuildContext context, GoRouterState state) {
            return SettingsScreen();
          },
        ),
      ],
    ),
  ],
);
