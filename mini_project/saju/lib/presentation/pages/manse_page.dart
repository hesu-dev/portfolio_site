import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saju/presentation/widgets/manse/birth_datetime.dart';
import 'package:saju/presentation/widgets/manse/city_field.dart';
import 'package:saju/presentation/widgets/manse/gender_selector.dart';
import 'package:saju/presentation/widgets/manse/name_field.dart';
import 'package:saju/presentation/widgets/manse/submit_button.dart';

import '../../providers/manse_form_provider.dart';

class MansePage extends StatelessWidget {
  const MansePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F5),
      appBar: AppBar(title: const Text('만세력 사주 보기 1.0')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            if (kDebugMode)
              TextButton(
                onPressed: () {
                  context.read<ManseFormProvider>().fillTestData();
                },
                child: const Text('⚡ 테스트 자동 입력'),
              ),
            const ManseNameField(),
            const SizedBox(height: 16),
            const ManseGenderSelector(),
            const SizedBox(height: 16),
            const ManseBirthDateTime(),
            const SizedBox(height: 16),
            const ManseCityField(),
            const SizedBox(height: 24),
            const ManseSubmitButton(),
          ],
        ),
      ),
    );
  }
}
