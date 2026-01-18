import 'package:flutter/material.dart';

class InputSummaryView extends StatelessWidget {
  final String solar;
  final String lunar;
  final String adjusted;

  const InputSummaryView({
    super.key,
    required this.solar,
    required this.lunar,
    required this.adjusted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('양 $solar', style: const TextStyle(color: Colors.red)),
        Text('음 $lunar', style: const TextStyle(color: Colors.blue)),
        Text(adjusted, style: const TextStyle(color: Colors.black87)),
      ],
    );
  }
}
