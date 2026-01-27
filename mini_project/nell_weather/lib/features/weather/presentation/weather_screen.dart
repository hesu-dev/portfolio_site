import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:nell_weather/features/weather/provider/weather_provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../data/models/weather_model.dart';
import 'widgets/current_weather_header.dart';
import 'widgets/hourly_forecast_widget.dart';
import 'widgets/weekly_forecast_widget.dart';
import '../../memo/presentation/widgets/memo_list_widget.dart';

class WeatherScreen extends ConsumerWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherState = ref.watch(weatherProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          "NELL",
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(letterSpacing: 2.0),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
      body: weatherState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (weather) => SingleChildScrollView(
          child: Column(
            children: [
              // 1. Current Weather Header & Summary
              CurrentWeatherHeader(
                location: weather.location,
                temp: weather.currentTemp.round(),
                condition: weather.condition,
                description: weather.description,
              ),

              SizedBox(height: 32.h),

              // 2. Alert Card (Conditional)
              if (weather.currentAlert != null)
                _buildAlertCard(context, weather.currentAlert!),

              SizedBox(height: 32.h),

              // 3. Hourly Forecast
              HourlyForecastWidget(forecasts: weather.hourly),

              SizedBox(height: 32.h),

              // 4. Weekly Forecast
              WeeklyForecastWidget(forecasts: weather.daily),

              SizedBox(height: 32.h),

              // 5. Memo List
              const MemoListWidget(),

              SizedBox(height: 48.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlertCard(BuildContext context, WeatherAlert alert) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.umbrella, color: Colors.white, size: 24.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert.title.toUpperCase(),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  alert.message,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.white.withOpacity(0.5),
            size: 14.sp,
          ),
        ],
      ),
    );
  }
}
