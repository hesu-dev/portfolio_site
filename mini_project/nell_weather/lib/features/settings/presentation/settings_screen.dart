import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nell_weather/features/settings/provider/settings_provider.dart';
import '../../../../core/constants/app_colors.dart';
import 'widgets/subscription_card.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final settingsState = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("설정"),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              "저장",
              style: TextStyle(
                color: AppColors.primary,
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
            // // Section 0: Subscription Card
            // const SubscriptionCard(
            //   type: SubscriptionType.free,
            //   remainingDays: 0,
            // ),
            // SizedBox(height: 32.h),

            // Section 1: Alert Sensitivity (Changed to Page Navigation)
            _buildSectionHeader(context, "알람 모드 변경"),
            SizedBox(height: 16.h),
            _buildUnifiedTile(
              context,
              title: "알림 빈도",
              subtitle: settingsState
                  .sensitivity
                  .label, // e.g. "Standard" -> "보통" logic needed or use English for now/map it
              onTap: () => context.go('/settings/sensitivity'),
              icon: Icons.notifications_active,
              iconColor: const Color.fromARGB(255, 255, 116, 30),
              iconBackgroundColor: const Color.fromARGB(
                217,
                255,
                168,
                38,
              ).withOpacity(0.1),
            ),

            SizedBox(height: 32.h),

            // Section 3: Daily Routine
            _buildSectionHeader(context, "데일리 루틴 설정"),
            SizedBox(height: 16.h),

            _buildSwitchTile(
              context,
              title: "아침 브리핑",
              time: settingsState.morningBriefTime.format(context),
              value: settingsState.morningBriefEnabled,
              onChanged: (val) => notifier.setMorningBrief(val),
              onTimeTap: () async {
                final TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: settingsState.morningBriefTime,
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        timePickerTheme: TimePickerThemeData(
                          backgroundColor: AppColors.surface,
                          hourMinuteColor: MaterialStateColor.resolveWith(
                            (states) => states.contains(MaterialState.selected)
                                ? AppColors.primary
                                : AppColors.surfaceVariant,
                          ),
                          hourMinuteTextColor: MaterialStateColor.resolveWith(
                            (states) => states.contains(MaterialState.selected)
                                ? Colors.black
                                : AppColors.textMediumEmphasis,
                          ),
                          dialHandColor: AppColors.primary,
                          dialBackgroundColor: AppColors.surfaceVariant,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null) {
                  notifier.setMorningBriefTime(picked);
                }
              },
              icon: Icons.wb_twilight,
            ),

            // SizedBox(height: 5.h),
            // _buildSwitchTile(
            //   context,
            //   title: "방해 금지 모드",
            //   value: settingsState.weekendAlertsEnabled,
            //   onChanged: (val) => notifier.setWeekendAlerts(val),
            //   icon: Icons.do_not_disturb_on,
            // ),
            SizedBox(height: 32.h),

            // Section 2: Premium / Advanced
            Row(
              children: [
                _buildSectionHeader(context, "화면 설정"),
                SizedBox(width: 8.w),
                // Container(
                //   padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                //   decoration: BoxDecoration(
                //     color: AppColors.warning,
                //     borderRadius: BorderRadius.circular(4),
                //   ),
                //   child: Text(
                //     "PRO",
                //     style: TextStyle(
                //       color: Colors.black,
                //       fontWeight: FontWeight.bold,
                //       fontSize: 10.sp,
                //     ),
                //   ),
                // ),
              ],
            ),
            SizedBox(height: 16.h),

            // Unified List Style
            // _buildUnifiedTile(
            //   context,
            //   title: "광고 off",
            //   subtitle: "이용 화면에 광고를 제거합니다.",
            // ),
            // SizedBox(height: 12.h),
            _buildUnifiedTile(
              context,
              title: "내 위치 목록 관리",
              subtitle: "사용자의 위치 목록을 관리합니다.",
              onTap: () => context.go('/settings/locations'),
              icon: Icons.location_city,
              iconColor: const Color.fromARGB(255, 27, 219, 215),
              iconBackgroundColor: const Color.fromARGB(
                217,
                38,
                255,
                251,
              ).withOpacity(0.1),
            ),
            SizedBox(height: 12.h),
            _buildUnifiedTile(
              context,
              title: "언어 설정",
              subtitle: settingsState.locale.languageCode == 'ko'
                  ? "한국어"
                  : "English",
              onTap: () => context.go('/settings/language'),
              icon: Icons.language,
              iconColor: const Color.fromARGB(255, 255, 116, 30),
              iconBackgroundColor: const Color.fromARGB(
                217,
                255,
                38,
                38,
              ).withOpacity(0.1),
            ),
            SizedBox(height: 12.h),
            _buildUnifiedTile(
              context,
              title: "다크 모드",
              subtitle: "앱의 테마를 어둡게 설정합니다.",
              isSwitch: true,
              switchValue: settingsState.themeMode == ThemeMode.dark,
              onSwitchChanged: (val) {
                notifier.setThemeMode(val ? ThemeMode.dark : ThemeMode.light);
              },
              icon: Icons.dark_mode,
              iconColor: const Color.fromARGB(255, 255, 116, 30),
              iconBackgroundColor: const Color.fromARGB(
                217,
                255,
                168,
                38,
              ).withOpacity(0.1),
            ),

            MakeSizedBox(height: 40.h), // Footer spacing
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.cloud_queue,
                    size: 40.sp,
                    color: AppColors.textLowEmphasis,
                  ),
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
    VoidCallback? onTimeTap,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: const Color.fromARGB(112, 147, 147, 147),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(title, style: Theme.of(context).textTheme.titleMedium),
          ),
          if (time != null)
            GestureDetector(
              onTap: onTimeTap,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                margin: EdgeInsets.only(right: 12.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: onTimeTap != null
                        ? AppColors.primary.withOpacity(0.5)
                        : Colors.transparent,
                  ),
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
            ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  Widget _buildUnifiedTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    IconData? icon,
    Color? iconColor,
    Color? iconBackgroundColor,
    VoidCallback? onTap,
    bool isSwitch = false,
    bool switchValue = false,
    Function(bool)? onSwitchChanged,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cloudy),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: iconBackgroundColor ?? Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? AppColors.textMediumEmphasis,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 16.w),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
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
            if (isSwitch)
              Switch(value: switchValue, onChanged: onSwitchChanged)
            else
              Icon(
                Icons.chevron_right,
                color: AppColors.textMediumEmphasis,
                size: 24.sp,
              ),
          ],
        ),
      ),
    );
  }

  Widget MakeSizedBox({required double height}) {
    return SizedBox(height: height);
  }
}
