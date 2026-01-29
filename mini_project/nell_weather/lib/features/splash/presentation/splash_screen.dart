import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../auth/provider/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Start initialization
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // 1. Check Auth Status (Mock: 1.5s delay)
    await ref.read(authProvider.notifier).checkAuthStatus();
    
    // 2. Add minimal delay for branding visibility if needed
    // (Already covered by Auth delay, but just in case)
    
    // 3. Navigation
    if (mounted) {
      final authState = ref.read(authProvider);
      
      // If user is logged in -> Go Home
      // If user is NOT logged in -> Go Login
      if (authState.value != null) {
        context.go('/'); 
      } else {
        context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Image or Text
            Icon(Icons.cloud_circle_rounded, size: 80.w, color: AppColors.primary),
            SizedBox(height: 24.h),
            Text(
              "NELL WEATHER",
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.5,
                color: AppColors.textHighEmphasis,
              ),
            ),
            SizedBox(height: 40.h),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
