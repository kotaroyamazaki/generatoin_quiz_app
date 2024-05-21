import 'package:education_quiz_app/providers/providers.dart';
import 'package:education_quiz_app/screens/quiz_screen.dart';
import 'package:education_quiz_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
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

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizService = ref.watch(quizServiceProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('あのときなにがあった？クイズ'),
      ),
      body: ListView(
        children: List.generate(2023 - 2000 + 1, (index) {
          final year = (2000 + index).toString();
          return ListTile(
            title: Text('$year年のクイズ'),
            onTap: () async {
              final quizzes = await quizService.loadQuizzes(year);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      QuizScreen(year: year, quizzes: quizzes),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
