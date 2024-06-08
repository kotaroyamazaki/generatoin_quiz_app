import 'package:audioplayers/audioplayers.dart';
import 'package:education_quiz_app/provider/providers.dart';
import 'package:education_quiz_app/screens/quiz_screen.dart';
import 'package:education_quiz_app/services/storage_service.dart';
import 'package:education_quiz_app/theme/colors.dart';
import 'package:education_quiz_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = AudioPlayer();
    final firestoreService = ref.watch(firestoreServiceProvider);
    final storageService = ref.watch(storageServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('あのときなにがあった？クイズ'),
      ),
      body: Container(
        decoration: backgroundDecoration,
        child: SafeArea(
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
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 5.0,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      title: Text(
                        '$year年のクイズ',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: _buildScoreDisplay(score),
                      onTap: () async {
                        final quizzes =
                            await firestoreService.loadQuizzes(year);
                        if (!context.mounted) return;
                        player.play(AssetSource('sounds/select.mp3'));
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                QuizDetailScreen(year: year, quizzes: quizzes),
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

  Widget _buildScoreDisplay(dynamic score) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.star,
          color: score == 50 ? Colors.red : Colors.grey,
        ),
        const SizedBox(width: 5),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: score.toString(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: score == 50 ? Colors.red : black,
                ),
              ),
              const TextSpan(
                text: ' / 50点',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
