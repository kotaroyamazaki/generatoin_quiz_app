import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/quiz.dart';

class QuizService {
  Future<List<Quiz>> loadQuizzes(String year) async {
    final data = await rootBundle.loadString('assets/quizzes/$year.json');
    final List<dynamic> jsonResult = json.decode(data);
    return jsonResult.map((quiz) => Quiz.fromJson(quiz)).toList();
  }
}
