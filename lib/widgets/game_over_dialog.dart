import 'package:flutter/material.dart';

void showGameOverDialog(BuildContext context, int score) {
  showDialog(
    context: context,
    barrierDismissible: false, // ダイアログ外をタップしても閉じないようにする
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      title: const Column(
        children: [
          Icon(Icons.sentiment_very_dissatisfied, color: Colors.red, size: 50),
          SizedBox(height: 10),
          Text(
            'ゲーム終了',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
          Text(
            '最終スコア: $score',
            style: const TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // ダイアログを閉じる
            Navigator.of(context).pop(); // 前の画面に戻る
          },
          child: const Text('OK', style: TextStyle(fontSize: 18)),
        ),
      ],
    ),
  );
}
