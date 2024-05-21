import 'package:flutter/material.dart';

void showCompletionDialog(BuildContext context, int score) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      title: const Column(
        children: [
          Icon(Icons.star, color: Colors.amber, size: 50),
          SizedBox(height: 10),
          Text(
            'クイズ完了',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'おめでとうございます！全ての問題に回答しました。',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
          Text(
            '最終スコア: $score',
            style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.indigo),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          child: const Text('OK', style: TextStyle(fontSize: 18)),
        ),
      ],
    ),
  );
}
