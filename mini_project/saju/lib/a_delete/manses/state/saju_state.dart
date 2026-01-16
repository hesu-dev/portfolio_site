// ignore_for_file: unused_local_variable

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saju/a_delete/manses/blood/calculator/blood_relation_calculator.dart';
import 'package:saju/a_delete/manses/blood/model/blood.dart';
import 'package:saju/a_delete/manses/calendar/strategy/calendar_mode.dart';
import 'package:saju/a_delete/manses/ganji/calculator/hour_ganji_calculator.dart';
import 'package:saju/a_delete/manses/ganji/parser/ganji_parser.dart';
import 'package:saju/a_delete/manses/state/manses_calendar_providers.dart';
import 'package:saju/a_delete/manses/state/saju_models.dart';
import 'package:saju/a_delete/manses/wuxing/calculator/wu_xing_relation_calculator.dart';
import 'package:saju/a_delete/manses/wuxing/model/wu_xing.dart';

final sajuProvider = StateNotifierProvider<SajuController, SajuState>(
  (ref) => SajuController(ref),
);

class SajuController extends StateNotifier<SajuState> {
  SajuController(this.ref) : super(const SajuState.idle());

  final Ref ref;
  final wuXingCalc = WuXingRelationCalculator();
  final bloodCalc = BloodRelationCalculator();

  Future<void> calculate(
    DateTime birth, {
    CalendarMode mode = CalendarMode.solar,
  }) async {
    try {
      state = const SajuState.loading();

      final repo = ref.read(mansesCalendarRepoProvider);
      final cal = await repo.fromSolar(solar: birth);
      final sol = cal.solCal;
      final dayStem = parseDayStem(sol!.lunIljin);
      final hourGanJi = calcHourGanJi(birth: birth, dayStem: dayStem);
      // 예시: 일간 기준, 시주 상대
      final wuXingResult = wuXingCalc.analyzeWuXing(
        WuXing.water, // 임 = 수 (임시)
        WuXing.wood, // 예시
      );

      final blood = bloodCalc.analyze(
        from: WuXing.water,
        to: WuXing.wood,
        samePolarity: false, // 음양 비교 결과
      );

      state = SajuState.data(
        SajuResult(
          solar: birth,
          lunar:
              '${sol.lunYear}-${sol.lunMonth}-${sol.lunDay} (${sol.lunLeapmonth})',

          // 🔹 여기부터가 핵심
          yearGanJi: sol.lunSecha, // 연주
          monthGanJi: sol.lunWolgeon, // 월주
          dayGanJi: sol.lunIljin, // 일주
          hourGanJi: hourGanJi,
          wuXingRelation: wuXingResult.relation.name,
          bloodRelation: blood.korean,
        ),
      );
    } catch (e) {
      state = SajuState.error(e.toString());
    }
  }
}

@immutable
class SajuState {
  final SajuStatus status;
  final SajuResult? result;
  final String? message;

  const SajuState._(this.status, {this.result, this.message});

  const SajuState.idle() : this._(SajuStatus.idle);
  const SajuState.loading() : this._(SajuStatus.loading);

  const SajuState.data(SajuResult result)
    : this._(SajuStatus.data, result: result);

  const SajuState.error(String message)
    : this._(SajuStatus.error, message: message);

  T when<T>({
    required T Function() idle,
    required T Function() loading,
    required T Function(String message) error,
    required T Function(SajuResult result) data,
  }) {
    switch (status) {
      case SajuStatus.idle:
        return idle();
      case SajuStatus.loading:
        return loading();
      case SajuStatus.error:
        return error(message ?? 'unknown error');
      case SajuStatus.data:
        return data(result as SajuResult);
    }
  }
}

enum SajuStatus { idle, loading, data, error }
