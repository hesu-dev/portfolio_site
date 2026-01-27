import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';

class MemoListWidget extends StatelessWidget {
  const MemoListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "WEATHER MEMO",
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.textMediumEmphasis,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // TODO: Add Memo Logic
                  _showLoginRequiredDialog(context);
                },
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(Icons.add, size: 20.sp, color: AppColors.textHighEmphasis),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          
          // Empty State or List
          _buildEmptyState(context),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 32.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceVariant),
        // Dashed border concept could be applied here
      ),
      child: Column(
        children: [
          Icon(Icons.edit_note, size: 40.sp, color: AppColors.textLowEmphasis),
          SizedBox(height: 12.h),
          Text(
            "Log in to keep track of\nweather-related plans.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textMediumEmphasis,
            ),
          ),
          SizedBox(height: 16.h),
          OutlinedButton(
            onPressed: () {
               // TODO: Login Flow
               _showLoginRequiredDialog(context);
            },
            child: const Text("Sign In"),
          ),
        ],
      ),
    );
  }

  void _showLoginRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text("Login Required"),
        content: const Text("This feature is available for signed-in users."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }
}
