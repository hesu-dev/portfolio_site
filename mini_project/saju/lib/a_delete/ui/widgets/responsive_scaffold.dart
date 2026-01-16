import 'package:flutter/material.dart';

class ResponsiveScaffold extends StatelessWidget {
  final Widget left;
  final Widget right;

  const ResponsiveScaffold({
    super.key,
    required this.left,
    required this.right,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final isDesktop = w >= 1000;

    if (!isDesktop) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [left, const SizedBox(height: 16), right],
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: left),
          const SizedBox(width: 16),
          Expanded(child: right),
        ],
      ),
    );
  }
}
