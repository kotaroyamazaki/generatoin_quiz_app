import 'package:education_quiz_app/providers/providers.dart';
import 'package:education_quiz_app/screens/quiz_screen.dart';
import 'package:education_quiz_app/services/storage_service.dart';
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
    final storageService = ref.watch(storageServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('あのときなにがあった？クイズ'),
        backgroundColor: Colors.indigo,
      ),
      body: Container(
        decoration: backgroundDecoration,
        child: FutureBuilder<Map<String, int>>(
          future: _loadScores(storageService),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('エラーが発生しました。'));
            }

            final scores = snapshot.data ?? {};

            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: List.generate(2023 - 2000 + 1, (index) {
                final year = (2023 - index).toString();
                final score = scores[year] ?? '--';

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 5.0,
                  child: ListTile(
                    title: Text(
                      '$year年のクイズ',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'スコア: $score / 50',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward),
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
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }

  Future<Map<String, int>> _loadScores(StorageService storageService) async {
    final scores = <String, int>{};
    for (var year = 2000; year <= 2023; year++) {
      final score = await storageService.getAchievement(year.toString());
      if (score != null) {
        scores[year.toString()] = score;
      }
    }
    return scores;
  }
}
