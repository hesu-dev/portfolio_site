import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saju/providers/manse_form_provider.dart';

class ManseCityField extends StatelessWidget {
  const ManseCityField({super.key});

  @override
  Widget build(BuildContext context) {
    final form = context.watch<ManseFormProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('도시'),
        const SizedBox(height: 8),
        TextField(
          decoration: const InputDecoration(
            hintText: '도시명을 입력하세요',
            filled: true,
            fillColor: Colors.white,
            suffixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
          onChanged: (v) {
            form.city = v.isEmpty ? null : v;
            form.notify();
          },
        ),
      ],
    );
  }
}
