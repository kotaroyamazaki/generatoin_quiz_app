import 'package:education_quiz_app/firebase_options.dart';
import 'package:education_quiz_app/screens/home_screen.dart';
import 'package:education_quiz_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'あのときなにがあった？クイズ',
      theme: appTheme,
      home: const HomeScreen(),
    );
  }
}
