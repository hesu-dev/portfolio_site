import 'package:flutter/material.dart';

enum WuXing {
  wood('목', '木', Color(0xFF4CAF50)),
  fire('화', '火', Color(0xFFF44336)),
  earth('토', '土', Color(0xFFFFD600)),
  metal('금', '金', Color(0xFFE0E0E0)),
  water('수', '水', Color(0xFF039BE5));

  final String korean;
  final String chinese;
  final Color color;

  const WuXing(this.korean, this.chinese, this.color);
}
