import 'package:generation_quiz_app/models/quiz.dart';
import 'package:flutter/material.dart';
import 'package:generation_quiz_app/widgets/button.dart';

void showFeedbackDialog(BuildContext context, bool isCorrect, String userAnswer,
    Quiz quiz, Function() onNext) {
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
            '正解:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Text(
            quiz.answer,
            style: const TextStyle(fontSize: 18, color: Colors.black54),
          ),
          if (!isCorrect) ...[
            const SizedBox(height: 10),
            const Text(
              'あなたの回答:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              userAnswer,
              style: const TextStyle(fontSize: 18, color: Colors.black54),
            ),
          ],
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
          const SizedBox(height: 40),
          Button(
            text: '次へ',
            onPressed: () {
              Navigator.of(context).pop();
              onNext();
            },
          ),
        ],
      ),
    ),
  );
}
