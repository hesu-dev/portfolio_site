import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nell_weather/features/settings/provider/settings_provider.dart';
import '../../../../core/constants/app_colors.dart';
import 'widgets/sensitivity_selector.dart';

class SensitivityScreen extends ConsumerWidget {
  const SensitivityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("알림 빈도 설정"),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Column(
          children: [
            Text(
              "원하는 알림 강도를 선택해주세요.",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textMediumEmphasis,
              ),
            ),
            SizedBox(height: 32.h),
            SensitivitySelector(
              selected: settingsState.sensitivity,
              onSelected: (val) {
                notifier.setSensitivity(val);
              },
            ),
          ],
        ),
      ),
    );
  }
}
