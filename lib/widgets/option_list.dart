import 'package:education_quiz_app/models/quiz.dart';
import 'package:flutter/material.dart';

class OptionsList extends StatelessWidget {
  final Quiz quiz;
  final Function(String) onOptionSelected;

  const OptionsList(
      {super.key, required this.quiz, required this.onOptionSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: quiz.options.map((option) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ElevatedButton(
            onPressed: () => onOptionSelected(option),
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
}
