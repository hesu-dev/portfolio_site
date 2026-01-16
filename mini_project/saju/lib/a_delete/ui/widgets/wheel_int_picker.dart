import 'package:flutter/material.dart';

typedef ItemLabel = String Function(int value);

class WheelIntPicker extends StatelessWidget {
  final FixedExtentScrollController controller;
  final int min;
  final int max;
  final double itemExtent;
  final ValueChanged<int> onSelected;
  final ItemLabel label;

  const WheelIntPicker({
    super.key,
    required this.controller,
    required this.min,
    required this.max,
    required this.onSelected,
    required this.label,
    this.itemExtent = 40,
  });

  @override
  Widget build(BuildContext context) {
    final itemCount = (max - min + 1);

    return SizedBox(
      height: 180,
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        physics: const FixedExtentScrollPhysics(),
        itemExtent: itemExtent,
        onSelectedItemChanged: (index) => onSelected(min + index),
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: itemCount,
          builder: (context, index) {
            final value = min + index;
            return Center(
              child: Text(label(value), style: const TextStyle(fontSize: 16)),
            );
          },
        ),
      ),
    );
  }
}
