import 'package:generation_quiz_app/models/quiz.dart';
import 'package:generation_quiz_app/models/singletons_data.dart';
import 'package:generation_quiz_app/theme/colors.dart';
import 'package:flutter/material.dart';

class QuestionCard extends StatelessWidget {
  final Quiz quiz;

  const QuestionCard({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: appData.isSmallScreen ? 150 : 200,
      child: Card(
        color: backgroundColor,
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              quiz.question,
              style: TextStyle(
                  fontSize: appData.isSmallScreen ? 16 : 18, color: black),
            ),
          ),
        ),
      ),
    );
  }
}
