import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saju/presentation/pages/manse_confirm_page.dart';
import 'package:saju/providers/manse_form_provider.dart';

class ManseSubmitButton extends StatelessWidget {
  const ManseSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    final form = context.watch<ManseFormProvider>();

    return ElevatedButton(
      onPressed: form.isValid
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ManseConfirmPage()),
              );
            }
          : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: form.isValid
            ? const Color(0xFF4A6CF7)
            : Colors.grey.shade300,
        minimumSize: const Size.fromHeight(56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      child: const Text('만세력 보러가기', style: TextStyle(fontSize: 16)),
    );
  }
}
