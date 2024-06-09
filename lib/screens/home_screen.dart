import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:generation_quiz_app/models/constants.dart';
import 'package:generation_quiz_app/provider/providers.dart';
import 'package:generation_quiz_app/provider/score_notifier.dart';
import 'package:generation_quiz_app/screens/quiz_screen.dart';
import 'package:generation_quiz_app/theme/colors.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = AudioPlayer();
    final firestoreService = ref.watch(firestoreServiceProvider);
    final scores = ref.watch(scoreProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('あのときのクイズ'),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Image(image: AssetImage('assets/images/training_man.png')),
          ),
        ],
      ),
      body: SafeArea(
        child: scores.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.separated(
                separatorBuilder: (context, index) => const Divider(
                  color: grey,
                  height: 1,
                ),
                itemCount: maxQuizYear - minQuizYear + 1,
                itemBuilder: (context, index) {
                  final year = (maxQuizYear - index).toString();
                  final score = scores[year] ?? '--';

                  return ListTile(
                    tileColor: Colors.white,
                    leading: Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        // E8EDF5 color
                        color: const Color(0xFFE8EDF5),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Icon(Icons.emoji_events_outlined,
                          size: 24,
                          color: score == maxQuizNum ? Colors.yellow : black),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    title: Text(
                      '$year年のクイズ',
                      style: const TextStyle(
                        color: black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '得点: ${score != 0 ? score : "--"}/$maxQuizNum 点',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios,
                        color: Colors.black),
                    onTap: () async {
                      final quizzes = await firestoreService.loadQuizzes(year);
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
                          builder: (context) =>
                              QuizDetailScreen(year: year, quizzes: quizzes),
                        ),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}
