import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saju/a_delete/manses/state/saju_state.dart';
import 'package:saju/a_delete/ui/input_form_panel.dart';
import 'package:saju/a_delete/ui/result_panel.dart';
import 'package:saju/a_delete/ui/widgets/responsive_scaffold.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ResponsiveScaffold(
      left: InputFormPanel(
        onSubmit: (dt) {
          ref.read(sajuProvider.notifier).calculate(dt);
        },
      ),
      right: const ResultPanel(),
    );
  }
}
