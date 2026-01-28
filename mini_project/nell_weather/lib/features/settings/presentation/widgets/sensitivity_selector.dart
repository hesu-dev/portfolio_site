import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';

import '../../provider/settings_provider.dart';

class SensitivitySelector extends StatelessWidget {
  final AlertSensitivity selected;
  final Function(AlertSensitivity) onSelected;

  const SensitivitySelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildOption(
          context,
          AlertSensitivity.quiet,
          "방해 금지 모드",
          "정말 위험한 상황에서만 알림이 울립니다.",
          Icons.nightlight_round,
        ),
        SizedBox(height: 12.h),
        _buildOption(
          context,
          AlertSensitivity.standard,
          "기본 표준 모드",
          "위험한 상황이나, 비와 같은 기상 변화가 있을 때 알림이 울립니다.",
          Icons.water_drop,
        ),
        SizedBox(height: 12.h),
        _buildOption(
          context,
          AlertSensitivity.active,
          "모든 알람 모드",
          "변경 상황에 대한 모든 알람이 울립니다.",
          Icons.notifications_active,
        ),
      ],
    );
  }

  Widget _buildOption(
    BuildContext context,
    AlertSensitivity value,
    String title,
    String subtitle,
    IconData icon,
  ) {
    final isSelected = selected == value;
    final borderColor = isSelected ? AppColors.primary : AppColors.cloudy;
    final bgColor = isSelected
        ? AppColors.primary.withOpacity(0.1)
        : AppColors.cloudy;

    return GestureDetector(
      onTap: () => onSelected(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.cloudy,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 18.sp,
                color: isSelected ? Colors.white : AppColors.surfaceVariant,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textMediumEmphasis,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: AppColors.primary, size: 20.sp),
          ],
        ),
      ),
    );
  }
}
