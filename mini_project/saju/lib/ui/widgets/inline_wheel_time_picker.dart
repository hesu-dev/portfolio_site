import 'package:flutter/material.dart';
import 'wheel_int_picker.dart';

class InlineWheelTimePicker extends StatefulWidget {
  final TimeOfDay initialTime;
  final ValueChanged<TimeOfDay> onChanged;

  const InlineWheelTimePicker({
    super.key,
    required this.initialTime,
    required this.onChanged,
  });

  @override
  State<InlineWheelTimePicker> createState() => _InlineWheelTimePickerState();
}

class _InlineWheelTimePickerState extends State<InlineWheelTimePicker> {
  late int _hour;
  late int _minute;

  late FixedExtentScrollController _hourCtl;
  late FixedExtentScrollController _minuteCtl;

  @override
  void initState() {
    super.initState();
    _hour = widget.initialTime.hour;
    _minute = widget.initialTime.minute;

    _hourCtl = FixedExtentScrollController(initialItem: _hour);
    _minuteCtl = FixedExtentScrollController(initialItem: _minute);
  }

  void _emit() {
    final t = TimeOfDay(hour: _hour, minute: _minute);
    widget.onChanged(t);
    setState(() {});
  }

  @override
  void dispose() {
    _hourCtl.dispose();
    _minuteCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: WheelIntPicker(
            controller: _hourCtl,
            min: 0,
            max: 23,
            onSelected: (v) {
              _hour = v;
              _emit();
            },
            label: (v) => v.toString().padLeft(2, '0'),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 6),
          child: Text(
            ':',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: WheelIntPicker(
            controller: _minuteCtl,
            min: 0,
            max: 59,
            onSelected: (v) {
              _minute = v;
              _emit();
            },
            label: (v) => v.toString().padLeft(2, '0'),
          ),
        ),
      ],
    );
  }
}
