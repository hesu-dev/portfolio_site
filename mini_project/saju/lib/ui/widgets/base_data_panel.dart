import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../a_delete/state/manses_base_provider.dart';
import '../../a_delete/request_type.dart';
import '../../a_delete/yingyang_xuxing_response.dart';

class BaseDataPanel extends ConsumerWidget {
  const BaseDataPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final type = ref.watch(requestTypeProvider);
    final baseAsync = ref.watch(mansesBaseProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '기본 데이터(음양/오행)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                DropdownButton<RequestType>(
                  value: type,
                  onChanged: (v) {
                    if (v == null) return;
                    ref.read(requestTypeProvider.notifier).state = v;
                    ref.invalidate(mansesBaseProvider);
                  },
                  items: const [
                    DropdownMenuItem(
                      value: RequestType.normal,
                      child: Text('normal (List)'),
                    ),
                    DropdownMenuItem(
                      value: RequestType.hash,
                      child: Text('hash (Map)'),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: () => ref.invalidate(mansesBaseProvider),
                  child: const Text('새로고침'),
                ),
              ],
            ),

            const SizedBox(height: 12),
            // baseAsync.when(
            //   data: (res) => _BaseDataView(data: res.data),
            //   loading: () => const Padding(
            //     padding: EdgeInsets.all(8),
            //     child: CircularProgressIndicator(),
            //   ),
            //   error: (e, _) => Text('불러오기 실패: $e'),
            // ),
          ],
        ),
      ),
    );
  }
}

class _BaseDataView extends StatelessWidget {
  final YingYangXuXingResponse data;
  const _BaseDataView({required this.data});

  @override
  Widget build(BuildContext context) {
    if (data is YingYangXuXingNormal) {
      final d = data as YingYangXuXingNormal;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('YinYang (List)'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: d.yinYangs
                .map((e) => Chip(label: Text('${e.korean}(${e.chinese})')))
                .toList(),
          ),
          const SizedBox(height: 12),
          const Text('WuXing (List)'),
          // Wrap(
          //   spacing: 8,
          //   runSpacing: 8,
          //   children: d.xuXings
          //       .map(
          //         (e) =>
          //             Chip(label: Text('${e.korean}(${e.chinese}) ${e.color}')),
          //       )
          //       .toList(),
          // ),
        ],
      );
    } else {
      final d = data as YingYangXuXingHash;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('YinYang (Map)'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: d.yinYangs.entries
                .map((e) => Chip(label: Text('${e.key}: ${e.value.chinese}')))
                .toList(),
          ),
          const SizedBox(height: 12),
          const Text('WuXing (Map)'),
          // Wrap(
          //   spacing: 8,
          //   runSpacing: 8,
          //   children: d.xuXings.entries
          //       .map((e) => Chip(label: Text('${e.key}: ${e.value.color}')))
          //       .toList(),
          // ),
        ],
      );
    }
  }
}
