import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saju/presentation/sheets/jiji_time_table_sheet.dart';
import 'package:saju/presentation/sheets/yaja_joja_info_sheet.dart';
import 'package:saju/providers/manse_form_provider.dart';

class ManseBirthDateTime extends StatelessWidget {
  const ManseBirthDateTime({super.key});

  @override
  Widget build(BuildContext context) {
    final form = context.watch<ManseFormProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('생년월일시'),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.help_outline),
              onPressed: () => showJijiTimeTable(context),
            ),
          ],
        ),
        const SizedBox(height: 8),

        /// 날짜
        _box(
          context,
          text: form.birthDate == null
              ? '날짜 선택'
              : form.birthDate!.toString().split(' ').first,
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
              initialDate: DateTime.now(),
            );
            if (date != null) {
              form.birthDate = date;
              form.notify();
            }
          },
        ),

        const SizedBox(height: 8),

        /// 시간
        _box(
          context,
          text: form.birthTime == null
              ? '시간 선택'
              : form.birthTime!.format(context),
          onTap: form.timeUnknown
              ? null
              : () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) {
                    form.birthTime = time;
                    form.notify();
                  }
                },
        ),

        const SizedBox(height: 8),

        Row(
          children: [
            Checkbox(
              value: form.timeUnknown,
              onChanged: (v) {
                form.timeUnknown = v ?? false;
                form.notify();
              },
            ),
            const Text('시간 모름'),
            const Spacer(),
            GestureDetector(
              onTap: () => showYajaJojaInfo(context),
              child: const Text(
                '야자시/조자시',
                style: TextStyle(decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _box(
    BuildContext context, {
    required String text,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey),
        ),
        child: Text(text),
      ),
    );
  }
}
