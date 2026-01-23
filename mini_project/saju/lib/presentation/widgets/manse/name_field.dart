import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saju/providers/manse_form_provider.dart';

class ManseNameField extends StatefulWidget {
  const ManseNameField({super.key});

  @override
  State<ManseNameField> createState() => _ManseNameFieldState();
}

class _ManseNameFieldState extends State<ManseNameField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final form = context.read<ManseFormProvider>();
    final providerName = form.name ?? '';

    // Provider → TextField
    if (_controller.text != providerName) {
      _controller.text = providerName;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
          controller: _controller,
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
