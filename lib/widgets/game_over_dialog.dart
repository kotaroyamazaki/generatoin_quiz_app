import 'dart:math';

import 'package:flutter/material.dart';
import 'package:generation_quiz_app/models/constants.dart';
import 'package:generation_quiz_app/widgets/button.dart';

void showGameOverDialog(
    BuildContext context, int score, int totalQuestions, VoidCallback onRetry) {
  // gameover の画像のパスは３種類の中からランダムで表示する
  final randomImageIndex = Random().nextInt(3) + 1;
  final gameOverImagePath = 'assets/images/game_over_$randomImageIndex.png';

  showDialog(
    context: context,
    barrierDismissible: false, // ダイアログ外をタップしても閉じないようにする
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              Column(
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(15)),
                    child: Image.asset(
                      gameOverImagePath, // ここに画像のパスを指定します
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
                          'Game Over',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "ライフがなくなりました。\nもう一度挑戦してみましょう！",
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                const Text(
                                  '問題数:',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  '$totalQuestions/$maxQuizNum',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const Text(
                                  '正解数:',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  '$score',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        CustomButton(text: 'もう一度挑戦する', onPressed: onRetry),
                        const SizedBox(height: 12),
                        CustomButton(
                          text: 'タイトルに戻る',
                          onPressed: () {
                            Navigator.of(context).pop(); // ダイアログを閉じる
                            Navigator.of(context).pop(); // タイトルに戻る
                          },
                          isOutline: true,
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
