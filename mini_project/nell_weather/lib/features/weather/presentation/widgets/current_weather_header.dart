import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';

class WeatherDescriptionLocation extends StatelessWidget {
  final String description;
  final String location;

  const WeatherDescriptionLocation({
    super.key,
    required this.description,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20.h),
        Text(
          description,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.4),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_on_outlined, size: 14.sp),
            SizedBox(width: 4.w),
            Text(
              location.toUpperCase(),
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(letterSpacing: 1.2),
            ),
          ],
        ),
      ],
    );
  }
}

class WeatherTemperature extends StatelessWidget {
  final int temp;

  const WeatherTemperature({super.key, required this.temp});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 32.h),
        Text(
          "$temp°",
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: -2.0,
          ),
        ),
      ],
    );
  }
}

class WeatherConditionBadge extends StatelessWidget {
  final String condition;
  final IconData icon;
  final Color iconColor;

  const WeatherConditionBadge({
    super.key,
    required this.condition,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.surfaceVariant),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: iconColor, size: 18.sp),
              SizedBox(width: 8.w),
              Text(
                condition,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
