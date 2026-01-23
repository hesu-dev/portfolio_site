import 'package:flutter/material.dart';
import 'package:saju/domain/services/yin_yang_balance_service.dart';

class YinYangCircle extends StatelessWidget {
  final YinYangBalance balance;
  final double size;

  const YinYangCircle({super.key, required this.balance, this.size = 220});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: YinYangPainter(
              yin: balance.yinPercent,
              yang: balance.yangPercent,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Text(
              //   balance.label,
              //   style: const TextStyle(
              //     fontSize: 22,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              const SizedBox(height: 6),
              Text(
                '양 ${balance.yangPercent.toStringAsFixed(0)}% · '
                '음 ${balance.yinPercent.toStringAsFixed(0)}%',
                style: TextStyle(color: Colors.grey[700]),
              ),
              const SizedBox(height: 4),
              Text(
                balance.judgment,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class YinYangPainter extends CustomPainter {
  final double yin;
  final double yang;

  YinYangPainter({required this.yin, required this.yang});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final strokeWidth = 22.0;
    final rect = Rect.fromCircle(center: center, radius: radius - strokeWidth);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // 배경
    paint.color = const Color(0xFFE5E0DB);
    canvas.drawArc(rect, 0, 2 * 3.141592, false, paint);

    // 시작 각도 (12시)
    double startAngle = -3.141592 / 2;

    // 양 (진한 색)
    paint.color = const Color(0xFF4A4A57);
    canvas.drawArc(rect, startAngle, 2 * 3.141592 * (yang / 100), false, paint);

    // 음 (연한 색)
    paint.color = const Color(0xFFFFD28A);
    canvas.drawArc(
      rect,
      startAngle + 2 * 3.141592 * (yang / 100),
      2 * 3.141592 * (yin / 100),
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
