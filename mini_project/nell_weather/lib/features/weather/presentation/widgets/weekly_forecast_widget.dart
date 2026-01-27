import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nell_weather/core/constants/app_colors.dart';

import '../../../../data/models/weather_model.dart';
import 'package:intl/intl.dart';

class WeeklyForecastWidget extends StatelessWidget {
  final List<DailyForecast> forecasts;

  const WeeklyForecastWidget({super.key, required this.forecasts});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(), // Nested scroll handling
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      itemCount: forecasts.length,
      itemBuilder: (context, index) {
        return _buildDailyItem(context, forecasts[index]);
      },
    );
  }

  Widget _buildDailyItem(BuildContext context, DailyForecast forecast) {
    final day = DateFormat('E').format(forecast.date); // Mon, Tue...

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Day
          SizedBox(
            width: 50.w,
            child: Text(
              day,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),

          // Icon
          Icon(
            forecast.isRainy ? Icons.cloud : Icons.wb_sunny_rounded,
            color: forecast.isRainy ? AppColors.cloudy : AppColors.sunny,
            size: 20.sp,
          ),

          // Temp Bar
          Row(
            children: [
              Text(
                "${forecast.maxTemp.round()}°",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textHighEmphasis,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                "${forecast.minTemp.round()}°",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textMediumEmphasis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
