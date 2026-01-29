import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/weather/presentation/weather_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../features/settings/presentation/locations/location_management_screen.dart';
import '../features/settings/presentation/sensitivity_screen.dart';
import '../features/settings/presentation/language_screen.dart';
import '../../features/pixel_maker/presentation/pixel_maker_screen.dart';
import '../../features/settings/presentation/subscription_screen.dart';

// Auth Routes
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/signup_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';

// 라우터 설정
import 'package:hive_flutter/hive_flutter.dart';

final GoRouter router = GoRouter(
  initialLocation: '/splash',
  redirect: (context, state) {
    // Onboarding Check is still valid, but maybe handled after login?
    // Let's keep it simple: Splash decides destination.
    // If Splash sends to '/', then Onboarding check kicks in.
    final box = Hive.box('settings');
    final hasSeenOnboarding = box.get(
      'has_seen_onboarding',
      defaultValue: false,
    );
    final isGoingToOnboarding = state.matchedLocation == '/onboarding';
    final isGoingToSplash = state.matchedLocation == '/splash';
    final isGoingToAuth = state.matchedLocation == '/login' || state.matchedLocation == '/signup';

    // Allow Splash & Auth screens to pass through without redirect
    if (isGoingToSplash || isGoingToAuth) return null;

    if (!hasSeenOnboarding) {
      // onboard 안봤으면 onboarding으로 보냄
      return isGoingToOnboarding ? null : '/onboarding';
    } else {
      // onboard 봤는데 onboarding으로 가려고 하면 메인으로 보냄
      if (isGoingToOnboarding) {
        return '/';
      }
    }
    return null; // 그 외에는 원래 가려던 곳으로
  },
  routes: <RouteBase>[
    GoRoute(
      path: '/splash',
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
      },
    ),
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: '/signup',
      builder: (BuildContext context, GoRouterState state) {
        return const SignUpScreen();
      },
    ),
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
            GoRoute(
              path: 'subscription',
              builder: (BuildContext context, GoRouterState state) {
                return const SubscriptionScreen();
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
