// Widget _buildProgressBar(double progress) {
//   return LinearProgressIndicator(
//     value: progress,
//     backgroundColor: Colors.white24,
//     valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
//     minHeight: 8,
//   );
// }
// class

import 'package:flutter/material.dart';

Widget QuizProgressBar(double progress) {
  return LinearProgressIndicator(
    value: progress,
    backgroundColor: Colors.white24,
    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
    minHeight: 8,
  );
}
