import 'package:generation_quiz_app/models/quiz.dart';
import 'package:generation_quiz_app/models/singletons_data.dart';
import 'package:generation_quiz_app/theme/colors.dart';
import 'package:flutter/material.dart';

class OptionsList extends StatelessWidget {
  final Quiz quiz;
  final Function(String) onOptionSelected;

  const OptionsList(
      {super.key, required this.quiz, required this.onOptionSelected});

  @override
  Widget build(BuildContext context) {
    final minSize = appData.isSmallScreen ? 24.0 : 48.0;
    final fontSize = appData.isSmallScreen ? 14.0 : 18.0;
    final space = appData.isSmallScreen ? 4.0 : 12.0;

    return Column(
      children: quiz.options.map((option) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: space),
          child: ElevatedButton(
            onPressed: () => onOptionSelected(option),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: black,
              minimumSize: Size(double.infinity, minSize),
              textStyle: TextStyle(fontSize: fontSize),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
            ),
            child: Text(
              option,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        );
      }).toList(),
    );
  }
}
