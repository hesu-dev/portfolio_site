import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';

class CurrentWeatherHeader extends StatelessWidget {
  final String location;
  final int temp;
  final String condition;
  final String description;

  const CurrentWeatherHeader({
    super.key,
    required this.location,
    required this.temp,
    required this.condition,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20.h),
        // Description
        Text(
          description,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.textMediumEmphasis,
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.h),
        
        // Location
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_on_outlined, size: 14.sp, color: AppColors.textMediumEmphasis),
            SizedBox(width: 4.w),
            Text(
              location.toUpperCase(),
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.textMediumEmphasis,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        
        SizedBox(height: 32.h),

        // Temp
        Text(
          "$temp°",
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: -2.0,
          ),
        ),
        
        SizedBox(height: 8.h),
        
        // Condition Badge
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
              Icon(Icons.wb_sunny_rounded, color: AppColors.sunny, size: 18.sp), // Dynamic Icon Needed
              SizedBox(width: 8.w),
              Text(
                condition,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
