import 'dart:math';
import 'package:flutter/material.dart';
import 'package:generation_quiz_app/models/constants.dart';
import 'package:generation_quiz_app/services/analytics.dart';
import 'package:generation_quiz_app/widgets/button.dart';

void showCompletionDialog(BuildContext context, int score) {
  // completion の画像のパスは３種類の中からランダムで表示する
  final randomImageIndex = Random().nextInt(3) + 1;
  final completionImagePath = 'assets/images/completion_$randomImageIndex.png';

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
                      completionImagePath, // ここに画像のパスを指定します
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
                          'Completion!',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'おめでとう！\n全ての問題に回答しました!',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Column(
                              children: [
                                Text(
                                  '問題数:',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  '$maxQuizNum/$maxQuizNum',
                                  style: TextStyle(
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
                        const SizedBox(height: 32),
                        CustomButton(
                          text: 'タイトルに戻る',
                          onPressed: () {
                            AnalyticsService.instance
                                .logEvent(name: 'tap_title_button');
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
