// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saju/domain/models/manse_request_dto.dart';
import 'package:saju/presentation/widgets/result_panel.dart';
import 'package:saju/providers/manse_form_provider.dart';

import '../../providers/manse_result_provider.dart';

class ManseLoadingPage extends StatefulWidget {
  const ManseLoadingPage({super.key});

  @override
  State<ManseLoadingPage> createState() => _ManseLoadingPageState();
}

class _ManseLoadingPageState extends State<ManseLoadingPage> {
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    print('LoadingPage initState');

    /// 🔹 load()는 여기서 딱 한 번
    Future.microtask(() {
      final form = context.read<ManseFormProvider>();
      final resultProvider = context.read<ManseResultProvider>();

      final req = ManseRequestDto(
        calendarType: CalendarType.solar, // 임시 고정
        date: form.birthDate!, // 날짜만 사용
        hour: form.birthTime?.hour ?? 12, // 시간 없으면 정오
        minute: form.birthTime?.minute ?? 0,
        isLeapMonth: false, // 양력은 항상 false
      );

      resultProvider.load(req);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ManseResultProvider>();

    /// 🔹 결과 도착 → 다음 페이지로 이동
    if (!provider.loading && provider.result != null && !_navigated) {
      _navigated = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ResultPanel(result: provider.result!),
          ),
        );
      });
    }

    /// 🔹 에러 처리
    if (!provider.loading && provider.error != null) {
      return Scaffold(
        body: Center(
          child: Text(
            provider.error!,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
