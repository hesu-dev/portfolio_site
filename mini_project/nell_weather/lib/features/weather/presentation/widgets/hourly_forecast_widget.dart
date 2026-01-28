import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nell_weather/core/constants/app_colors.dart';
import '../../../../data/models/weather_model.dart';
import 'package:intl/intl.dart';

class HourlyForecastWidget extends StatelessWidget {
  final List<HourlyForecast> forecasts;

  const HourlyForecastWidget({super.key, required this.forecasts});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Text(
            "FORECAST",
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.textMediumEmphasis,
            ),
          ),
        ),
        SizedBox(height: 12.h),

        /// 👇 핵심
        SizedBox(
          height: 120.h,
          child: ScrollConfiguration(
            behavior: const _WebScrollBehavior(),
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: forecasts.length,
              separatorBuilder: (context, index) => SizedBox(width: 12.w),
              itemBuilder: (context, index) {
                return _buildHourlyItem(context, forecasts[index]);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHourlyItem(BuildContext context, HourlyForecast forecast) {
    final time = DateFormat('h a').format(forecast.time);

    return Container(
      width: 70.w,
      decoration: BoxDecoration(
        color: forecast.isRainy
            ? AppColors.primary.withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: forecast.isRainy
            ? Border.all(color: AppColors.primary.withOpacity(0.5))
            : Border.all(color: Colors.grey.withOpacity(0.5)),
      ),
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(time, style: Theme.of(context).textTheme.bodySmall),
          Icon(
            forecast.isRainy ? Icons.water_drop : Icons.wb_sunny,
            color: forecast.isRainy ? AppColors.rainy : AppColors.sunny,
            size: 24.sp,
          ),
          Text(
            "${forecast.temp.round()}°",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}

/// 👇 웹 전용 스크롤 설정
class _WebScrollBehavior extends MaterialScrollBehavior {
  const _WebScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
  };
}
