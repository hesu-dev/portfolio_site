import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InlineTimePicker extends StatelessWidget {
  final TimeOfDay time;
  final ValueChanged<TimeOfDay> onChanged;

  const InlineTimePicker({
    super.key,
    required this.time,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return SizedBox(
      height: 180,
      child: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.time,
        initialDateTime: DateTime(
          now.year,
          now.month,
          now.day,
          time.hour,
          time.minute,
        ),
        use24hFormat: true,
        onDateTimeChanged: (dt) {
          onChanged(TimeOfDay(hour: dt.hour, minute: dt.minute));
        },
      ),
    );
  }
}
