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
        SizedBox(
          height: 120.h,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            scrollDirection: Axis.horizontal,
            itemCount: forecasts.length,
            separatorBuilder: (context, index) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              return _buildHourlyItem(context, forecasts[index]);
            },
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
            : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: forecast.isRainy
            ? Border.all(color: AppColors.primary.withOpacity(0.5))
            : Border.all(color: Colors.transparent),
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
