import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScoreNotifier extends StateNotifier<Map<String, int>> {
  ScoreNotifier() : super({}) {
    _loadScores();
  }

  Future<void> _loadScores() async {
    final prefs = await SharedPreferences.getInstance();
    final scores = <String, int>{};
    for (var year = 2015; year <= 2023; year++) {
      final score = prefs.getInt(year.toString());
      if (score != null) {
        scores[year.toString()] = score;
      }
    }
    state = scores;
  }

  Future<void> saveScore(String year, int score) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(year, score);
    state = {...state, year: score};
  }
}

final scoreProvider =
    StateNotifierProvider<ScoreNotifier, Map<String, int>>((ref) {
  return ScoreNotifier();
});
