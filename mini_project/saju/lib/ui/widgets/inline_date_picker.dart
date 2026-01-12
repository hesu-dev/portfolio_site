import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InlineDatePicker extends StatelessWidget {
  final DateTime date;
  final ValueChanged<DateTime> onChanged;

  const InlineDatePicker({
    super.key,
    required this.date,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.date,
        initialDateTime: date,
        minimumDate: DateTime(1900, 1, 1),
        maximumDate: DateTime(DateTime.now().year + 1),
        onDateTimeChanged: onChanged,
      ),
    );
  }
}
