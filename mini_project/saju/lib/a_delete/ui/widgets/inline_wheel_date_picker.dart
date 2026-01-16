import 'package:flutter/material.dart';
import 'wheel_int_picker.dart';

class InlineWheelDatePicker extends StatefulWidget {
  final DateTime initialDate;
  final ValueChanged<DateTime> onChanged;

  const InlineWheelDatePicker({
    super.key,
    required this.initialDate,
    required this.onChanged,
  });

  @override
  State<InlineWheelDatePicker> createState() => _InlineWheelDatePickerState();
}

class _InlineWheelDatePickerState extends State<InlineWheelDatePicker> {
  late int _year;
  late int _month;
  late int _day;

  late FixedExtentScrollController _yearCtl;
  late FixedExtentScrollController _monthCtl;
  late FixedExtentScrollController _dayCtl;

  int get _maxDay {
    final firstNextMonth = (_month == 12)
        ? DateTime(_year + 1, 1, 1)
        : DateTime(_year, _month + 1, 1);
    final lastDay = firstNextMonth.subtract(const Duration(days: 1));
    return lastDay.day;
  }

  @override
  void initState() {
    super.initState();
    _year = widget.initialDate.year;
    _month = widget.initialDate.month;
    _day = widget.initialDate.day;

    _yearCtl = FixedExtentScrollController(initialItem: _year - 1900);
    _monthCtl = FixedExtentScrollController(initialItem: _month - 1);
    _dayCtl = FixedExtentScrollController(initialItem: _day - 1);
  }

  void _emit() {
    final maxDay = _maxDay;
    if (_day > maxDay) _day = maxDay;

    final dt = DateTime(_year, _month, _day);
    widget.onChanged(dt);

    // day wheel 보정(예: 2월 -> 3월 넘어가며 day가 초과되는 경우)
    final desiredIndex = _day - 1;
    if (_dayCtl.hasClients && _dayCtl.selectedItem != desiredIndex) {
      _dayCtl.jumpToItem(desiredIndex);
    }
    setState(() {});
  }

  @override
  void dispose() {
    _yearCtl.dispose();
    _monthCtl.dispose();
    _dayCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final yearMin = 1900;
    final yearMax = now.year + 1;

    final maxDay = _maxDay;

    return Row(
      children: [
        Expanded(
          child: WheelIntPicker(
            controller: _yearCtl,
            min: yearMin,
            max: yearMax,
            onSelected: (v) {
              _year = v;
              _emit();
            },
            label: (v) => '$v년',
          ),
        ),
        Expanded(
          child: WheelIntPicker(
            controller: _monthCtl,
            min: 1,
            max: 12,
            onSelected: (v) {
              _month = v;
              _emit();
            },
            label: (v) => '$v월',
          ),
        ),
        Expanded(
          child: WheelIntPicker(
            controller: _dayCtl,
            min: 1,
            max: maxDay,
            onSelected: (v) {
              _day = v;
              _emit();
            },
            label: (v) => '$v일',
          ),
        ),
      ],
    );
  }
}
