import 'package:education_quiz_app/models/quiz.dart';
import 'package:education_quiz_app/theme/colors.dart';
import 'package:flutter/material.dart';

class QuestionCard extends StatelessWidget {
  final Quiz quiz;

  const QuestionCard({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              quiz.question,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: black),
            ),
          ),
        ),
      ),
    );
  }
}
