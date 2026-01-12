import 'package:flutter/material.dart';
import 'widgets/responsive_scaffold.dart';
import 'widgets/base_data_panel.dart';
import 'widgets/input_form_panel.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('만세력 (Flutter Web)')),
      body: const ResponsiveScaffold(
        left: InputFormPanel(),
        right: BaseDataPanel(),
      ),
    );
  }
}
