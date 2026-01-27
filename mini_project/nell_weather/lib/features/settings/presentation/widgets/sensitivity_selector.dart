import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';

enum AlertSensitivity { quiet, standard, active }

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
          "Quiet",
          "Only severe warnings",
          Icons.nightlight_round,
        ),
        SizedBox(height: 12.h),
        _buildOption(
          context,
          AlertSensitivity.standard,
          "Standard",
          "Rain starts & severe warnings",
          Icons.water_drop,
        ),
        SizedBox(height: 12.h),
        _buildOption(
          context,
          AlertSensitivity.active,
          "Active",
          "All changes & daily briefs",
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
    final borderColor = isSelected ? AppColors.primary : AppColors.surfaceVariant;
    final bgColor = isSelected ? AppColors.primary.withOpacity(0.1) : AppColors.surface;

    return GestureDetector(
      onTap: () => onSelected(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 18.sp,
                color: isSelected ? Colors.white : AppColors.textMediumEmphasis,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isSelected ? AppColors.textHighEmphasis : AppColors.textMediumEmphasis,
                    ),
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
