import 'dart:math' as math; // Fixed import

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';

class WeatherTipWidget extends StatelessWidget {
  final int temp;
  final int weatherId;
  final double windSpeed;
  final double rain; // mm/h
  final double snow; // mm/h
  final double uvi;
  final int humidity;

  const WeatherTipWidget({
    super.key,
    required this.temp,
    required this.weatherId,
    required this.windSpeed,
    required this.rain,
    required this.snow,
    required this.uvi,
    required this.humidity,
  });

  @override
  Widget build(BuildContext context) {
    final tips = getConditionTips(
      temp: temp,
      weatherId: weatherId,
      windSpeed: windSpeed,
      rain: rain,
      snow: snow,
      uvi: uvi,
      humidity: humidity,
    );

    // If no specific warning, give a generic friendly tip
    final message = tips.isNotEmpty
        ? tips.join('\n')
        : _getGenericTip(temp, weatherId);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),

      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 144, 144, 144)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        message,
        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
        textAlign: TextAlign.center,
      ),
    );
  }

  String _getGenericTip(int t, int id) {
    if (id == 800) return "맑은 하늘! 산책하기 좋은 날씨예요 ☀️";
    if (t > 25) return "더운 날씨, 수분 섭취를 잊지 마세요 💧";
    if (t < 5) return "따뜻하게 입으세요 🧣";
    return "좋은 하루 보내세요! ✨";
  }
}

// Logic Helpers from User Request
bool isThunder(int id) => id >= 200 && id < 300;
bool isRain(int id) => id >= 500 && id < 600;
bool isSnow(int id) => id >= 600 && id < 700;
bool isHeavyRain(int id, double rain) => isRain(id) && rain >= 10;
bool isHeavySnow(int id, double snow) => isSnow(id) && snow >= 5;

List<String> getConditionTips({
  required int temp,
  required int weatherId,
  required double windSpeed,
  required double rain,
  required double snow,
  required double uvi,
  required int humidity,
}) {
  final tips = <String>[];

  // 1. Extreme Weather (Priority)
  // 폭우
  if (isHeavyRain(weatherId, rain)) {
    tips.add("폭우 주의! ☔️\n도로가 미끄러우니 조심하세요.");
  } else if (isRain(weatherId)) {
    tips.add("비가 옵니다 ☔️\n우산을 챙기세요.");
  }

  // 대설
  if (isHeavySnow(weatherId, snow)) {
    tips.add("대설 주의! ☃️\n보행 및 운전 시 각별히 유의하세요.");
  } else if (isSnow(weatherId)) {
    tips.add("눈이 내립니다 🌨\n미끄럼 주의하세요.");
  }

  // 천둥번개
  if (isThunder(weatherId)) {
    tips.add("천둥번개가 칩니다 ⚡️\n실내에 머무르세요.");
  }

  // 2. Wind & Temp Combo
  // 강풍
  if (windSpeed >= 14) {
    tips.add("강풍 주의 💨\n낙하물 위험이 있어요.");
    if (temp <= 0) tips.add("바람 때문에 체감온도가 매우 낮아요 🥶");
  }

  // 3. UVI (Standard 2.5 API doesn't provide UVI, usually 0.0)
  if (uvi >= 6 && !isRain(weatherId) && !isSnow(weatherId)) {
    tips.add("자외선이 강해요 ☀️\n선크림을 꼭 바르세요.");
  }

  // 4. Humidity & Temp (Summer Discomfort / Winter Dryness)
  if (temp >= 28 && humidity >= 70) {
    tips.add("고온다습한 날씨에요😓\n불쾌지수가 높으니 환기하세요.");
  }
  if (temp <= 5 && humidity <= 30) {
    tips.add("공기가 매우 건조해요\n물과 보습제를 잊지마세요.");
  }

  return tips;
}
