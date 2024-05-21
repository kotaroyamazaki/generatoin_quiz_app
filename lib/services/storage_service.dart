import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  Future<void> saveAchievement(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  Future<int> getAchievement(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key) ?? 0;
  }
}
