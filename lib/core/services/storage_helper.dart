import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  static Future<void> saveFavoriteStatus(String movieId, bool isFav) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("favorite_$movieId", isFav);
  }

  static Future<bool> loadFavoriteStatus(String movieId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("favorite_$movieId") ?? false;
  }
}
