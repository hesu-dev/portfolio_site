import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import 'widgets/sensitivity_selector.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Dummy State
  AlertSensitivity _sensitivity = AlertSensitivity.standard;
  bool _morningBrief = true;
  bool _weekendAlerts = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Settings"),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              "Done",
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Alert Sensitivity
            _buildSectionHeader(context, "ALERT SENSITIVITY"),
            SizedBox(height: 16.h),
            SensitivitySelector(
              selected: _sensitivity,
              onSelected: (val) {
                setState(() => _sensitivity = val);
              },
            ),

            SizedBox(height: 32.h),

            // Section 2: Daily Routine
            _buildSectionHeader(context, "DAILY ROUTINE"),
            SizedBox(height: 16.h),
            
            _buildSwitchTile(
              context,
              title: "Morning Brief",
              time: "07:30",
              value: _morningBrief,
              onChanged: (val) => setState(() => _morningBrief = val),
              icon: Icons.wb_twilight,
            ),
            
            SizedBox(height: 12.h),
            
            _buildSwitchTile(
              context,
              title: "Weekend Alerts",
              value: _weekendAlerts,
              onChanged: (val) => setState(() => _weekendAlerts = val),
              icon: Icons.weekend,
            ),

            SizedBox(height: 32.h),

            // Section 3: Premium / Advanced
            Row(
              children: [
                _buildSectionHeader(context, "PREMIUM"),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppColors.warning,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    "PRO",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 10.sp,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 16.h),
            
            _buildNavigationTile(
              context,
              title: "Alert Cooldown",
              subtitle: "Prevent spam within 1 hour",
            ),
            SizedBox(height: 12.h),
            _buildNavigationTile(
              context,
              title: "Custom Locations",
              subtitle: "Manage monitored zones",
            ),

            MakeSizedBox(height: 40.h), // Footer spacing
            Center(
              child: Column(
                children: [
                  Icon(Icons.cloud_queue, size: 40.sp, color: AppColors.textLowEmphasis),
                  SizedBox(height: 8.h),
                  Text(
                    "Nell Weather v1.0.0",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: AppColors.textMediumEmphasis,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildSwitchTile(
    BuildContext context, {
    required String title,
    String? time,
    required bool value,
    required Function(bool) onChanged,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 20.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          if (time != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              margin: EdgeInsets.only(right: 12.w),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                time,
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                ),
              ),
            ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
            activeTrackColor: AppColors.primary.withOpacity(0.3),
            inactiveThumbColor: AppColors.textMediumEmphasis,
            inactiveTrackColor: AppColors.surfaceVariant,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationTile(
    BuildContext context, {
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
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
          Icon(Icons.arrow_forward_ios, size: 14.sp, color: AppColors.textMediumEmphasis),
        ],
      ),
    );
  }
  
  Widget MakeSizedBox({required double height}) {
    return SizedBox(height: height);
  }
}
