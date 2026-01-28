import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';

enum SubscriptionType { free, trial, pro }

class SubscriptionCard extends StatelessWidget {
  final SubscriptionType type;
  final int remainingDays;

  const SubscriptionCard({
    super.key,
    required this.type,
    required this.remainingDays,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF), // Light Blue Background
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: const BoxDecoration(
                  color: Color(0xFFDBEAFE), // Lighter Blue
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.auto_awesome,
                  color: AppColors.primary,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getPlanTitle(type),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  if (remainingDays != 0) ...[
                    SizedBox(height: 2.h),
                    Text(
                      remainingDays.toString(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: getPlanAccentColor(type),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
              SizedBox(height: 16.h),
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "지금 구독하기",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String getPlanTitle(SubscriptionType type) {
    switch (type) {
      case SubscriptionType.pro:
        return "프로 플랜";
      case SubscriptionType.trial:
        return "프로 플랜";
      case SubscriptionType.free:
        return "무료 플랜";
    }
  }

  String? getPlanSubtitle(SubscriptionType type, int remainingDays) {
    switch (type) {
      case SubscriptionType.trial:
        return "체험 중 · $remainingDays일 남음";
      case SubscriptionType.pro:
        return "$remainingDays일 남음";
      case SubscriptionType.free:
        return null; // 무료는 표시 안 함
    }
  }

  Color getPlanAccentColor(SubscriptionType type) {
    switch (type) {
      case SubscriptionType.trial:
        return AppColors.primary;
      case SubscriptionType.pro:
        return Colors.black87;
      case SubscriptionType.free:
        return Colors.grey;
    }
  }
}
