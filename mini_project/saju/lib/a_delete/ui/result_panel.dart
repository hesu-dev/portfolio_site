import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saju/a_delete/manses/state/saju_state.dart';

class ResultPanel extends ConsumerWidget {
  const ResultPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sajuProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: state.when(
          idle: () => const Text('사주 정보를 입력하세요.'),
          loading: () => const CircularProgressIndicator(),
          error: (e) => SelectableText(
            '오류 발생:\n$e',
            style: const TextStyle(color: Colors.red),
          ),
          data: (result) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('양력: ${result.solar}'),
              Text('음력: ${result.lunar}'),
              const SizedBox(height: 8),
              Text('연주: ${result.yearGanJi}'),
              Text('월주: ${result.monthGanJi}'),
              Text('일주: ${result.dayGanJi}'),
              Text('시주: ${result.hourGanJi}'),
              const Divider(),
              Text('오행 관계: ${result.wuXingRelation}'),
              Text('육친: ${result.bloodRelation}'),
            ],
          ),
        ),
      ),
    );
  }
}
