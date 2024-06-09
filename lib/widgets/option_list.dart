import 'package:generation_quiz_app/models/quiz.dart';
import 'package:generation_quiz_app/theme/colors.dart';
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
              backgroundColor: Colors.white,
              foregroundColor: black,
              minimumSize: const Size(double.infinity, 64),
              textStyle:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
