import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:generation_quiz_app/models/constants.dart';
import 'package:generation_quiz_app/models/quiz.dart';
import 'package:generation_quiz_app/models/singletons_data.dart';
import 'package:generation_quiz_app/provider/score_notifier.dart';
import 'package:generation_quiz_app/theme/theme.dart';
import 'package:generation_quiz_app/widgets/conpleteion_dialog.dart';
import 'package:generation_quiz_app/widgets/feedback_dialog.dart';
import 'package:generation_quiz_app/widgets/game_over_dialog.dart';
import 'package:generation_quiz_app/widgets/lives.dart';
import 'package:generation_quiz_app/widgets/option_list.dart';
import 'package:generation_quiz_app/widgets/progress_bar.dart';
import 'package:generation_quiz_app/widgets/question_card.dart';
import 'dart:math';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class QuizDetailScreen extends ConsumerStatefulWidget {
  final String year;
  final List<Quiz> quizzes;

  const QuizDetailScreen(
      {super.key, required this.year, required this.quizzes});

  @override
  QuizScreenState createState() => QuizScreenState();
}

class QuizScreenState extends ConsumerState<QuizDetailScreen> {
  int _currentQuizIndex = 0;
  int _score = 0;
  int _lives = 5;
  late List<Quiz> _shuffledQuizzes;
  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _shuffleQuizzes();
    player.play(AssetSource('sounds/question.mp3'));
  }

  void _shuffleQuizzes() {
    _shuffledQuizzes = List<Quiz>.from(widget.quizzes);
    _shuffledQuizzes.shuffle(Random());
    for (var quiz in _shuffledQuizzes) {
      quiz.options.shuffle(Random());
    }
  }

  void _submitAnswer(String selectedOption) {
    final currentQuiz = _shuffledQuizzes[_currentQuizIndex];
    bool isCorrect = currentQuiz.answer == selectedOption;

    if (isCorrect) {
      player.play(AssetSource('sounds/correct.mp3'));
      setState(() {
        _score++;
      });
      final scoreNotifier = ref.read(scoreProvider.notifier);
      scoreNotifier.saveScore(widget.year, _score);
    } else {
      player.play(AssetSource('sounds/incorrect.mp3'));
      setState(() {
        _lives--;
      });
    }

    showFeedbackDialog(context, isCorrect, selectedOption, currentQuiz, () {
      setState(() {
        if (_lives <= 0) {
          player.play(AssetSource('sounds/gameover.mp3'));
          showGameOverDialog(context, _score);
        } else if (_currentQuizIndex < _shuffledQuizzes.length - 1) {
          _currentQuizIndex++;
          player.play(AssetSource('sounds/question.mp3'));
        } else {
          showCompletionDialog(context, _score);
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentQuiz = _shuffledQuizzes[_currentQuizIndex];
    final progress = (_currentQuizIndex + 1) / maxQuizNum;

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.year}年のクイズ',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      ),
      body: Container(
        decoration: backgroundDecoration,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              QuizProgressBar(progress),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Lives(lives: _lives),
                  _buildScore(),
                ],
              ),
              Text(
                '問題 ${_currentQuizIndex + 1} / $maxQuizNum',
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 20),
              QuestionCard(quiz: currentQuiz),
              const SizedBox(height: 30),
              OptionsList(quiz: currentQuiz, onOptionSelected: _submitAnswer),
              const SizedBox(height: 20),
              const Expanded(child: SizedBox()),
              appData.banner == null
                  ? const SizedBox()
                  : Container(
                      alignment: Alignment.center,
                      width: appData.banner!.size.width.toDouble(),
                      height: appData.banner!.size.height.toDouble(),
                      child: AdWidget(ad: appData.banner!),
                    )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScore() {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        'スコア: $_score',
        style: const TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }
}
