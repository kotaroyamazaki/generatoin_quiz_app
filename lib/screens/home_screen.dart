import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:generation_quiz_app/models/constants.dart';
import 'package:generation_quiz_app/provider/providers.dart';
import 'package:generation_quiz_app/provider/score_notifier.dart';
import 'package:generation_quiz_app/screens/quiz_screen.dart';
import 'package:generation_quiz_app/theme/colors.dart';
import 'package:generation_quiz_app/theme/theme.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = AudioPlayer();
    final firestoreService = ref.watch(firestoreServiceProvider);
    final scores = ref.watch(scoreProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('あのときなにがあった？クイズ'),
      ),
      body: Container(
        decoration: backgroundDecoration,
        child: SafeArea(
          child: scores.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: maxQuizYear - minQuizYear + 1,
                  itemBuilder: (context, index) {
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
                          if (quizzes.isEmpty) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('クイズが見つかりませんでした。'),
                              ),
                            );
                            return;
                          }
                          if (!context.mounted) return;
                          player.play(AssetSource('sounds/select.mp3'));
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuizDetailScreen(
                                  year: year, quizzes: quizzes),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }

  Widget _buildScoreDisplay(dynamic score) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.star,
          color: score == maxQuizNum ? Colors.red : Colors.grey,
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
                  color: score == maxQuizNum ? Colors.red : black,
                ),
              ),
              const TextSpan(
                text: ' / $maxQuizNum点',
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
