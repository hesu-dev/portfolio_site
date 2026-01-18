import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saju/providers/manse_form_provider.dart';

class ManseGenderSelector extends StatelessWidget {
  const ManseGenderSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final form = context.watch<ManseFormProvider>();

    Widget button(String label, Gender value) {
      final selected = form.gender == value;
      return Expanded(
        child: GestureDetector(
          onTap: () {
            form.gender = value;
            form.notify();
          },
          child: Container(
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: selected ? Colors.black : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('성별'),
        const SizedBox(height: 8),
        Row(
          children: [
            button('여자', Gender.female),
            const SizedBox(width: 8),
            button('남자', Gender.male),
          ],
        ),
      ],
    );
  }
}
