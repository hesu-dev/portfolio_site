import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saju/providers/manse_form_provider.dart';

class InputSummaryView extends StatelessWidget {
  final String solar;
  final String lunar;
  final String time;
  final String adjusted;

  const InputSummaryView({
    super.key,
    required this.solar,
    required this.lunar,
    required this.time,
    required this.adjusted,
  });

  @override
  Widget build(BuildContext context) {
    final form = context.watch<ManseFormProvider>();
    final genderText = form.gender?.label;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '양 ',
              style: const TextStyle(color: Color(0x80E85E5E), fontSize: 12),
            ),
            Text(
              '$solar $time $genderText ${form.city}',
              style: const TextStyle(color: Color(0x80524C46), fontSize: 12),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              '음(평달) ',
              style: const TextStyle(color: Color(0x80428BFF), fontSize: 12),
            ),
            Text(
              '$lunar $time $genderText ${form.city}',
              style: const TextStyle(color: Color(0x80524C46), fontSize: 12),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              '양 ',
              style: const TextStyle(color: Color(0xFFE85E5E), fontSize: 12),
            ),
            Text(
              '$adjusted $time $genderText ${form.city}',
              style: const TextStyle(color: Colors.black87, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}
