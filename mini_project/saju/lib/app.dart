import 'package:flutter/material.dart';
import 'ui/home_page.dart';

class MansesApp extends StatelessWidget {
  const MansesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manses',
      theme: ThemeData(useMaterial3: true),
      home: const HomePage(),
    );
  }
}
