import 'dart:io';

import 'package:dio/dio.dart';
import 'package:jr_case_boilerplate/core/models/movie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://caseapi.servicelabs.tech",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {"Content-Type": "application/json"},
    ),
  );

  Future<Map<String, dynamic>?> loginWithGoogle(String idToken) async {
    try {
      final response = await _dio.post(
        "/user/google-login", // backend endpoint
        data: {
          "token": idToken,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data["data"];
        print("Google Login response: ${response.data}");

        // JWT token'i kaydet
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", data["token"]);

        return {
          "id": data["id"],
          "name": data["name"],
          "email": data["email"],
          "photoUrl": data["photoUrl"],
          "token": data["token"],
        };
      } else {
        throw Exception("Google login failed: ${response.statusCode}");
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? "Google login failed");
    }
  }


  Future<List<Movie>> getMovies(int page) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token == null || token.isEmpty) {
      throw Exception("Token bulunamadı. Lütfen tekrar giriş yap.");
    }

    try {
      final response = await _dio.get(
        "/movie/list",
        queryParameters: {"page": page},
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "accept": "application/json",
          },
        ),
      );

      print("Movies response: ${response.data}");

      // 👇 doğru path: data["data"]["movies"]
      final data = response.data["data"]?["movies"] as List<dynamic>?;

      if (data == null) return [];

      return data.map((m) => Movie.fromJson(m)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? "Movie fetch failed");
    }
  }

  Future<List<Movie>> getFavoriteMovies() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token == null || token.isEmpty) {
      throw Exception("Token bulunamadı. Lütfen tekrar giriş yap.");
    }

    try {
      final response = await _dio.get(
        "/movie/favorites",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "accept": "application/json",
          },
        ),
      );

      print("Favorites response: ${response.data}");

      final data = response.data["data"] as List<dynamic>?;

      if (data == null) return [];

      return data.map((m) => Movie.fromJson(m)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? "Favorites fetch failed");
    }
  }

  Future<bool> toggleFavorite(String favoriteId , String token) async {
    try {
      final response = await _dio.post(
        "/movie/favorite/$favoriteId",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "accept": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print("toggleFavorite failed: ${response.statusCode} -> ${response.data}");
        return false;
      }
    } on DioException catch (e) {
      print("toggleFavorite error: ${e.response?.data}");
      return false;
    }
  }

  Future<String?> uploadPhoto(File file) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token == null || token.isEmpty) {
      throw Exception("Token bulunamadı. Lütfen tekrar giriş yap.");
    }

    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      });

      final response = await _dio.post(
        "/user/upload_photo",
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "accept": "application/json",
            "Content-Type": "multipart/form-data",
          },
        ),
      );

      if (response.statusCode == 200) {
        // ✅ doğru path: response.data["data"]["photoUrl"]
        final photoUrl = response.data["data"]?["photoUrl"];

        if (photoUrl != null && photoUrl is String) {
          await prefs.setString("photoUrl", photoUrl);
          return photoUrl;
        } else {
          throw Exception("Fotoğraf yüklenemedi: response.data içinde photoUrl bulunamadı");
        }
      } else {
        throw Exception("Fotoğraf yüklenemedi: ${response.statusCode}");
      }
    } on DioException catch (e) {
      print("Upload error: ${e.response?.data}");
      throw Exception(e.response?.data ?? "Fotoğraf yükleme başarısız");
    }
  }

  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await _dio.post(
        "/user/login",
        data: {
          "email": email,
          "password": password,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data["data"]; // 👈 sadece "data" kısmını al
        print("Login response: ${response.data}");
        return {
          "id": data["id"],
          "name": data["name"],
          "email": data["email"],
          "photoUrl": data["photoUrl"],
          "token": data["token"],
        };

      } else {
        throw Exception("Login failed");
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data["response"]?["message"] ?? "Login failed");
    }
  }


  Future<Map<String, dynamic>?> register(String name, String email, String password) async {
    try {
      final response = await _dio.post(
        "/user/register",
        data: {
          "name": name,
          "email": email,
          "password": password,
        },
      );

      print("Register response: ${response.data}"); // 👈 backend yanıtını görmek için

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception("Register failed: ${response.statusCode}");
      }
    } on DioException catch (e) {
      print("Register error: ${e.response?.data}"); // 👈 hatayı görmek için
      throw Exception(e.response?.data ?? "Register failed");
    }
  }


}
