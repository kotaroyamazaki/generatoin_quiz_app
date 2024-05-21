import 'package:education_quiz_app/models/quiz.dart';
import 'package:education_quiz_app/providers/providers.dart';
import 'package:education_quiz_app/services/storage_service.dart';
import 'package:education_quiz_app/theme/theme.dart';
import 'package:education_quiz_app/widgets/conpleteion_dialog.dart';
import 'package:education_quiz_app/widgets/feedback_dialog.dart';
import 'package:education_quiz_app/widgets/game_over_dialog.dart';
import 'package:education_quiz_app/widgets/lives.dart';
import 'package:education_quiz_app/widgets/option_list.dart';
import 'package:education_quiz_app/widgets/question_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

class QuizScreen extends ConsumerStatefulWidget {
  final String year;
  final List<Quiz> quizzes;

  const QuizScreen({super.key, required this.year, required this.quizzes});

  @override
  QuizScreenState createState() => QuizScreenState();
}

class QuizScreenState extends ConsumerState<QuizScreen> {
  int _currentQuizIndex = 0;
  int _score = 0;
  int _lives = 3;
  late StorageService _storageService;
  late List<Quiz> _shuffledQuizzes;

  @override
  void initState() {
    super.initState();
    _storageService = ref.read(storageServiceProvider);
    _loadScore();
    _shuffleQuizzes();
  }

  Future<void> _loadScore() async {
    final savedScore = await _storageService.getAchievement(widget.year);
    setState(() {
      _score = savedScore;
    });
  }

  void _shuffleQuizzes() {
    _shuffledQuizzes = List<Quiz>.from(widget.quizzes);
    _shuffledQuizzes.shuffle(Random());
  }

  void _submitAnswer(String selectedOption) {
    final currentQuiz = _shuffledQuizzes[_currentQuizIndex];
    bool isCorrect = currentQuiz.answer == selectedOption;

    if (isCorrect) {
      setState(() {
        _score++;
      });
      _storageService.saveAchievement(widget.year, _score);
    } else {
      setState(() {
        _lives--;
      });
    }

    showFeedbackDialog(context, isCorrect, selectedOption, currentQuiz, () {
      setState(() {
        if (_lives <= 0) {
          showGameOverDialog(context, _score);
        } else if (_currentQuizIndex < _shuffledQuizzes.length - 1) {
          _currentQuizIndex++;
        } else {
          showCompletionDialog(context, _score);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentQuiz = _shuffledQuizzes[_currentQuizIndex];
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.year}年のクイズ'),
        backgroundColor: Colors.indigo,
      ),
      body: Container(
        decoration: backgroundDecoration,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              QuestionCard(quiz: currentQuiz),
              const SizedBox(height: 20),
              OptionsList(quiz: currentQuiz, onOptionSelected: _submitAnswer),
              const SizedBox(height: 20),
              Lives(lives: _lives),
              _buildScore(),
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
