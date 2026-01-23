import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saju/presentation/pages/manse_loading_page.dart';
import 'package:saju/providers/manse_form_provider.dart';
import 'package:saju/providers/manse_result_provider.dart';

extension ManseFormDisplay on ManseFormProvider {
  String get formattedBirthDateTime {
    if (birthDate == null) return '';

    final y = birthDate!.year.toString().padLeft(4, '0');
    final m = birthDate!.month.toString().padLeft(2, '0');
    final d = birthDate!.day.toString().padLeft(2, '0');

    if (timeUnknown || birthTime == null) {
      return '$y/$m/$d';
    }

    final h = birthTime!.hour.toString().padLeft(2, '0');
    final min = birthTime!.minute.toString().padLeft(2, '0');

    return '$y/$m/$d $h:$min';
  }
}

class ManseConfirmPage extends StatelessWidget {
  const ManseConfirmPage({super.key});

  @override
  Widget build(BuildContext context) {
    final form = context.watch<ManseFormProvider>();
    final genderText = form.gender?.label ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF8F5),
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          '만세력 사주 보기 1.0',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        // actions: const [
        //   Icon(Icons.menu, color: Colors.black),
        //   SizedBox(width: 8),
        // ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                const Text(
                  '입력하신 프로필을\n확인해주세요.',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),

                _infoCard(Icons.person, '${form.name} / $genderText'),
                const SizedBox(height: 12),
                _infoCard(
                  Icons.calendar_today,
                  '양 ${form.formattedBirthDateTime}',
                ),
                const SizedBox(height: 12),
                _infoCard(Icons.location_on, form.city ?? ''),

                const SizedBox(height: 12),

                // 🔔 지역 보정 안내
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE8B3),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Text(
                    '입력하신 지역 정보에 따라 -32분을 보정합니다.',
                    style: TextStyle(fontSize: 14),
                  ),
                ),

                const Spacer(),

                // ▶ 만세력 보러가기
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFD572),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => MultiProvider(
                            providers: [
                              ChangeNotifierProvider.value(
                                value: context.read<ManseFormProvider>(),
                              ),
                              ChangeNotifierProvider(
                                create: (_) => ManseResultProvider(),
                              ),
                            ],
                            child: const ManseLoadingPage(),
                          ),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      );
                    },
                    child: const Text(
                      '만세력 보러가기',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // ▶ 프로필 수정하기
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE5E5E5),
                      foregroundColor: Colors.black54,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      '프로필 수정하기',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoCard(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.black54),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }
}
