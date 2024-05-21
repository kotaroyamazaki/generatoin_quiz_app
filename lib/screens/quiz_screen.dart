import 'package:education_quiz_app/models/quiz.dart';
import 'package:education_quiz_app/providers/providers.dart';
import 'package:education_quiz_app/services/storage_service.dart';
import 'package:education_quiz_app/theme/theme.dart';
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

    _showFeedbackDialog(isCorrect, selectedOption, currentQuiz);
  }

  void _showFeedbackDialog(bool isCorrect, String userAnswer, Quiz quiz) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        title: Column(
          children: [
            isCorrect
                ? const Icon(Icons.check_circle, color: Colors.green, size: 50)
                : const Icon(Icons.cancel, color: Colors.red, size: 50),
            const SizedBox(height: 10),
            Text(
              isCorrect ? '正解！' : '不正解',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            const Text(
              'あなたの回答:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              userAnswer,
              style: const TextStyle(fontSize: 18, color: Colors.black54),
            ),
            const SizedBox(height: 10),
            const Text(
              '正解:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              quiz.answer,
              style: const TextStyle(fontSize: 18, color: Colors.black54),
            ),
            const SizedBox(height: 10),
            const Divider(),
            const Text(
              '解説:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              quiz.explanation,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                if (_lives <= 0) {
                  _showGameOverDialog();
                } else if (_currentQuizIndex < _shuffledQuizzes.length - 1) {
                  _currentQuizIndex++;
                } else {
                  _showCompletionDialog();
                }
              });
            },
            child: const Text('次へ', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        title: const Column(
          children: [
            Icon(Icons.star, color: Colors.amber, size: 50),
            SizedBox(height: 10),
            Text(
              'クイズ完了',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'おめでとうございます！全ての問題に回答しました。',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              '最終スコア: $_score',
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('OK', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        title: const Column(
          children: [
            Icon(Icons.sentiment_very_dissatisfied,
                color: Colors.red, size: 50),
            SizedBox(height: 10),
            Text(
              'ゲームオーバー',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '残念ですが、体力がなくなりました。',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              '最終スコア: $_score',
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('OK', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
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
              _buildQuestionCard(currentQuiz),
              const SizedBox(height: 20),
              _buildOptionsList(currentQuiz),
              const SizedBox(height: 20),
              _buildLives(),
              _buildScore(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionCard(Quiz quiz) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          quiz.question,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildOptionsList(Quiz quiz) {
    return Column(
      children: quiz.options.map((option) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ElevatedButton(
            onPressed: () => _submitAnswer(option),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              textStyle: const TextStyle(fontSize: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: Text(option),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLives() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Icon(
          index < _lives ? Icons.favorite : Icons.favorite_border,
          color: Colors.red,
          size: 30,
        );
      }),
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
