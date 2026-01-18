import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saju/presentation/pages/manse_loading_page.dart';
import 'package:saju/providers/manse_form_provider.dart';
import 'package:saju/providers/manse_result_provider.dart';

class ManseConfirmPage extends StatelessWidget {
  const ManseConfirmPage({super.key});

  @override
  Widget build(BuildContext context) {
    final form = context.watch<ManseFormProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F5),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _item(Icons.person, '${form.name} / ${form.gender} '),
            _item(Icons.calendar_today, '양 ${form.birthDate}'),
            _item(Icons.location_on, form.city ?? ''),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MultiProvider(
                      providers: [
                        // 🔹 이미 존재하는 FormProvider 유지
                        ChangeNotifierProvider.value(
                          value: context.read<ManseFormProvider>(),
                        ),

                        // 🔹 ResultProvider는 여기서 새로 생성
                        ChangeNotifierProvider(
                          create: (_) => ManseResultProvider(),
                        ),
                      ],
                      child: const ManseLoadingPage(),
                    ),
                  ),
                );
              },

              child: const Text('만세력 보러가기'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(IconData icon, String text) {
    return ListTile(leading: Icon(icon), title: Text(text));
  }
}
