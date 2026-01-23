import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saju/domain/models/city_ko.dart';
import 'package:saju/providers/manse_form_provider.dart';

class ManseCityField extends StatefulWidget {
  const ManseCityField({super.key});

  @override
  State<ManseCityField> createState() => _ManseCityFieldState();
}

class _ManseCityFieldState extends State<ManseCityField> {
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
    final city = form.city ?? '';

    if (_controller.text != city) {
      _controller.text = city;
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
        const Text('도시'),
        const SizedBox(height: 8),
        Autocomplete<String>(
          optionsBuilder: (TextEditingValue value) {
            if (value.text.isEmpty) {
              return const Iterable<String>.empty();
            }

            return worldCityKo.where((city) => city.contains(value.text));
          },

          onSelected: (String selection) {
            // 선택 → Provider + TextField 동기화
            form.city = selection;
            form.notify();

            _controller.text = selection;
          },

          fieldViewBuilder:
              (context, textEditingController, focusNode, onFieldSubmitted) {
                // Autocomplete 내부 controller 대신 우리가 관리
                textEditingController.value = _controller.value;

                return TextField(
                  controller: _controller,
                  focusNode: focusNode,
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
                    // 직접 입력도 허용
                    form.city = v.isEmpty ? null : v;
                    form.notify();
                  },
                );
              },
        ),
      ],
    );
  }
}
