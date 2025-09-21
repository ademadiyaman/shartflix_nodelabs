import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhotoProvider extends ChangeNotifier {
  String? _photoUrl;

  String? get photoUrl => _photoUrl;

  Future<void> loadPhoto() async {
    final prefs = await SharedPreferences.getInstance();
    _photoUrl = prefs.getString("photoUrl");
    notifyListeners();
  }

  Future<void> setPhoto(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("photoUrl", url);
    _photoUrl = url;
    notifyListeners();
  }
}
