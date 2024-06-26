import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:generation_quiz_app/audio_manager.dart';
import 'package:generation_quiz_app/models/constants.dart';
import 'package:generation_quiz_app/provider/providers.dart';
import 'package:generation_quiz_app/provider/score_notifier.dart';
import 'package:generation_quiz_app/provider/sound_notifier.dart';
import 'package:generation_quiz_app/screens/quiz_screen.dart';
import 'package:generation_quiz_app/services/analytics.dart';
import 'package:generation_quiz_app/services/att.dart';
import 'package:generation_quiz_app/theme/colors.dart';
import 'package:rate_my_app/rate_my_app.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  late RateMyApp _rateMyApp;
  late AudioManager player;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _rateMyApp = RateMyApp(
      preferencesPrefix: 'rateMyApp_',
      minDays: 0,
      minLaunches: 3,
      remindDays: 7,
      remindLaunches: 10,
    );

    _rateMyApp.init().then((_) {
      if (_rateMyApp.shouldOpenDialog) {
        _rateMyApp.showRateDialog(
          context,
        );
      }
    });

    player = ref.read(audioManagerProvider);

    WidgetsFlutterBinding.ensureInitialized()
        .addPostFrameCallback((_) => ATTService.init());
  }

  @override
  Widget build(BuildContext context) {
    final firestoreService = ref.watch(firestoreServiceProvider);
    final scores = ref.watch(scoreProvider);
    final isSoundOn = ref.watch(soundProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('あのときのクイズ'),
        actions: [
          IconButton(
            icon: Icon(isSoundOn ? Icons.volume_up : Icons.volume_off,
                color: Colors.white),
            onPressed: () {
              ref.read(soundProvider.notifier).toggleSound();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView.separated(
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
                  color: const Color(0xFFE8EDF5),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Icon(Icons.emoji_events_outlined,
                    size: 24,
                    color: score == maxQuizNum ? Colors.yellow : black),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
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
              trailing:
                  const Icon(Icons.arrow_forward_ios, color: Colors.black),
              onTap: () async {
                AnalyticsService.instance
                    .logEvent(name: 'quiz_start', parameters: {'year': year});
                if (isLoading) return;
                setState(() {
                  isLoading = true;
                });

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

                setState(() {
                  isLoading = false;
                });
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
