import 'package:flutter/material.dart';

Widget quizProgressBar(double progress) {
  return LinearProgressIndicator(
    borderRadius: BorderRadius.circular(4),
    value: progress,
    backgroundColor: Colors.white24,
    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
    minHeight: 8,
  );
}
