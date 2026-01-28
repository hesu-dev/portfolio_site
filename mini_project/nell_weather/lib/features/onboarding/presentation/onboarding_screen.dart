import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/constants/app_colors.dart';
import 'widgets/onboarding_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 16.h),
            Text(
              "NELL WEATHER",
              style: TextStyle(
                color: AppColors.textMediumEmphasis,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              ),
            ),

            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: const [
                  OnboardingPage(
                    title: "필요할 때만\n알려주는 날씨",
                    description: "불필요한 알림 없이,\n중요한 날씨 변화만 정확하게 전달합니다.",
                    imagePath: "assets/images/onboarding_icon_1.png",
                  ),
                  OnboardingPage(
                    title: "중요한 변화를\n놓치지 마세요",
                    description: "비가 시작될 때, 멈출 때,\n그리고 위험해질 때만 알려드립니다.",
                    icon: Icons.notifications_active_outlined,
                  ),
                  OnboardingPage(
                    title: "조용히, 하지만\n정확하게",
                    description: "날씨을 수시로 확인하지 않아도 되는\n편안한 하루를 만드세요.",
                    icon: Icons.check_circle_outline,
                  ),
                ],
              ),
            ),

            // Indicator
            SmoothPageIndicator(
              controller: _pageController,
              count: 3,
              effect: ExpandingDotsEffect(
                activeDotColor: AppColors.primary,
                dotColor: AppColors.surfaceVariant,
                dotHeight: 8.h,
                dotWidth: 8.w,
                expansionFactor: 3,
              ),
            ),

            SizedBox(height: 32.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              child: SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentPage == 2) {
                      // 온보딩 완료 처리
                      Hive.box('settings').put('has_seen_onboarding', true);
                      context.go('/');
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    _currentPage == 2 ? "시작하기" : "다음으로",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
