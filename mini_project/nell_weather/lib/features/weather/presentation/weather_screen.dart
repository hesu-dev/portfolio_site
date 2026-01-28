import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:nell_weather/core/constants/app_colors.dart';
import 'package:nell_weather/features/weather/provider/weather_provider.dart';
import '../../../../data/models/weather_model.dart';
// import 'widgets/current_weather_header.dart'; // No longer used
import 'widgets/hourly_forecast_widget.dart';
import 'widgets/weekly_forecast_widget.dart';
import '../../memo/presentation/widgets/memo_list_widget.dart';
import 'widgets/weather_character_widget.dart';
import 'widgets/weather_tip_widget.dart';

class WeatherScreen extends ConsumerWidget {
  const WeatherScreen({super.key});

  @override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherState = ref.watch(weatherProvider);

    return weatherState.when(
      loading: () => const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("날씨 정보를 불러오는 중입니다..."),
            ],
          ),
        ),
      ),
      error: (error, stack) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: AppColors.error),
              SizedBox(height: 16),
              Text(
                '날씨 정보를 가져오는데 실패했습니다.',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => ref.refresh(weatherProvider),
                icon: const Icon(Icons.refresh),
                label: const Text('다시 시도'),
              ),
            ],
          ),
        ),
      ),
      data: (weather) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            elevation: 0,
            title: Text(
              "NELL WEATHER",
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => context.go('/settings'),
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // 1. Current Weather Header & Summary
                  // WeatherTemperature(temp: weather.currentTemp.round()),
                  SizedBox(height: 20.h),

                  // ** NEW: Weather Character Widget **
                  WeatherCharacterWidget(
                    condition: weather.condition,
                    temp: weather.temp,
                    weatherId: weather.weatherId,
                    windSpeed: weather.windSpeed,
                    rain: weather.rain,
                    snow: weather.snow,
                    pop: weather.pop,
                  ),

                  SizedBox(height: 24.h),

                  // ** NEW: Weather Tip Widget **
                  WeatherTipWidget(
                    temp: weather.temp,
                    weatherId: weather.weatherId,
                    windSpeed: weather.windSpeed,
                    rain: weather.rain,
                    snow: weather.snow,
                    uvi: weather.uvi,
                    humidity: weather.humidity,
                  ),

                  SizedBox(height: 32.h),

                  // 2. Alert Card (Conditional)
                  if (weather.currentAlert != null)
                    _buildAlertCard(context, weather.currentAlert!),

                  if (weather.currentAlert != null) SizedBox(height: 32.h),

                  // 3. Hourly Forecast
                  HourlyForecastWidget(forecasts: weather.hourly),

                  SizedBox(height: 32.h),

                  // 4. Memo List
                  const MemoListWidget(),

                  SizedBox(height: 32.h),

                  // 5. Weekly Forecast
                  WeeklyForecastWidget(forecasts: weather.daily),

                  SizedBox(height: 48.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAlertCard(BuildContext context, WeatherAlert alert) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
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
                    color: Colors.white.withOpacity(0.8),
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
