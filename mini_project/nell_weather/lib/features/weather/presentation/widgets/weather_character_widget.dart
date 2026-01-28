import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:nell_weather/features/weather/provider/avatar_provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../pixel_maker/presentation/widgets/avatar_preview_widget.dart';
import 'weather_scene_widget.dart'; // Import scene widget

class WeatherCharacterWidget extends ConsumerWidget {
  final String condition; // Kept for display text
  final int temp;
  final int weatherId;
  final double windSpeed;
  final double rain;
  final double snow;
  final double pop;

  const WeatherCharacterWidget({
    super.key,
    required this.condition,
    required this.temp,
    required this.weatherId,
    required this.windSpeed,
    required this.rain,
    required this.snow,
    required this.pop,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => _buildContent(context, ref);

  WeatherType _determineWeatherType() {
    // 1. Thunder/Rain via Code (2xx, 3xx, 5xx)
    if (weatherId >= 200 && weatherId < 600) {
      return WeatherType.rain;
    }
    // 2. Snow via Code (6xx)
    if (weatherId >= 600 && weatherId < 700) {
      return WeatherType.snow;
    }
    // 3. Fallback to precipitation values if code is ambiguous (e.g. 800 but pop high?)
    if (rain > 0) return WeatherType.rain;
    if (snow > 0) return WeatherType.snow;
    
    // 4. Wind
    if (windSpeed >= 8.0) return WeatherType.wind;
    
    // 5. Default
    return WeatherType.clear; 
  }
  
  // Re-write build to overlay badge correctly
  Widget _buildContent(BuildContext context, WidgetRef ref) {
    final avatarConfig = ref.watch(avatarProvider);
    final koreanCondition = _getKoreanCondition(condition);
    final weatherType = _determineWeatherType();

    return GestureDetector(
      onTap: () => context.go('/pixel-maker'),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Scene Background + Character
          Container(
             decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.r),
              boxShadow: [
                 BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30.r),
              child: WeatherSceneWidget(
                width: 300.w,
                height: 300.w,
                weatherType: weatherType,
                child: AvatarPreviewWidget(config: avatarConfig, scale: 1.5),
              ),
            ),
          ),

          // 2. Weather & Temp Badge (Bottom Center)
          Positioned(
            bottom: 24.h,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "$temp°",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    koreanCondition,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // 3. Edit Hint
           Positioned(
            right: 16.w,
            top: 16.w,
            child: Icon(
              Icons.edit,
              size: 18.sp,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  String _getKoreanCondition(String condition) {
    final cond = condition.toLowerCase();
    if (cond.contains('rain') || cond.contains('drizzle')) return '비';
    if (cond.contains('snow')) return '눈';
    if (cond.contains('cloud')) return '흐림';
    if (cond.contains('freez') || cond.contains('mix')) return '진눈깨비';
    if (cond.contains('storm') || cond.contains('thunder')) return '뇌우';
    if (cond.contains('mist') || cond.contains('fog')) return '안개';
    if (cond.contains('clear') || cond.contains('sun')) return '맑음';
    return '맑음'; // Default
  }
}
