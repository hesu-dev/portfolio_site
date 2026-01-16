import 'package:flutter/foundation.dart';

@immutable
class SajuResult {
  final DateTime solar;
  final String lunar;

  final String yearGanJi;
  final String monthGanJi;
  final String dayGanJi;
  final String hourGanJi;

  final String wuXingRelation;
  final String bloodRelation;

  const SajuResult({
    required this.solar,
    required this.lunar,
    required this.yearGanJi,
    required this.monthGanJi,
    required this.dayGanJi,
    required this.hourGanJi,
    required this.wuXingRelation,
    required this.bloodRelation,
  });
}
