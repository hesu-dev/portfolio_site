import 'dart:math';
import 'package:flutter/material.dart';
import 'package:saju/domain/enums/wu_xing.dart';

class WuXingDonutChart extends StatelessWidget {
  final Map<WuXing, double> percent;
  final String centerLabel;

  const WuXingDonutChart({
    super.key,
    required this.percent,
    required this.centerLabel,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 220,
      child: CustomPaint(
        painter: _WuXingDonutPainter(percent),
        child: Center(
          child: Text(
            centerLabel,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

class _WuXingDonutPainter extends CustomPainter {
  final Map<WuXing, double> percent;

  _WuXingDonutPainter(this.percent);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;
    final strokeWidth = 26.0;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    double startAngle = -pi / 2; // 12시 방향 시작

    for (final w in WuXing.values) {
      final sweepAngle = 2 * pi * (percent[w]! / 100);

      if (sweepAngle <= 0) continue;

      paint.color = w.color;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
