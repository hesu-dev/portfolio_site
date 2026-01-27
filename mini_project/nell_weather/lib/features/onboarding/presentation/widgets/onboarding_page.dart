import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String? imagePath; // 추후 이미지 에셋 사용을 위해 (일단은 아이콘이나 텍스트로 대체 가능)
  final IconData? icon;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.description,
    this.imagePath,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image / Icon Section
          Container(
            height: 300.h,
            width: 300.w,
            alignment: Alignment.center,
            child: imagePath != null
                ? Image.asset(
                    imagePath!,
                    fit: BoxFit.contain,
                  )
                : Container(
                    height: 200.h,
                    width: 200.w,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 80.sp, color: AppColors.primary),
                  ),
          ),
          SizedBox(height: 40.h),
          
          // Text Section
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textMediumEmphasis,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
