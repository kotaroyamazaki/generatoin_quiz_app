import 'package:flutter/material.dart';
import 'package:generation_quiz_app/theme/colors.dart';

Widget quizProgressBar(double progress) {
  return LinearProgressIndicator(
    borderRadius: BorderRadius.circular(4),
    value: progress,
    backgroundColor: grey,
    valueColor: const AlwaysStoppedAnimation<Color>(primaryColor),
    minHeight: 8,
  );
}
