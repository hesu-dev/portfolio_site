import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saju/app.dart';
import 'package:saju/providers/manse_form_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ManseFormProvider())],
      child: const App(),
    ),
  );
}
