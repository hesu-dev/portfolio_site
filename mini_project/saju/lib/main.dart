import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:saju/app.dart';
import 'package:saju/providers/manse_form_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await dotenv.load(fileName: ".env");
  }
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ManseFormProvider())],
      child: const App(),
    ),
  );
}
