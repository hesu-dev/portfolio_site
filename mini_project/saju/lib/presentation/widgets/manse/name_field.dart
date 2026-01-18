import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saju/providers/manse_form_provider.dart';

class ManseNameField extends StatelessWidget {
  const ManseNameField({super.key});

  @override
  Widget build(BuildContext context) {
    final form = context.watch<ManseFormProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('이름'),
        const SizedBox(height: 8),
        TextField(
          maxLength: 12,
          decoration: const InputDecoration(
            hintText: '최대 12글자 이내로 입력하세요',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
          onChanged: (v) {
            form.name = v.isEmpty ? null : v;
            form.notify();
          },
        ),
      ],
    );
  }
}
