// lib/services/user_service.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'package:azmonrahnamayi/models/user.dart';
import 'dart:convert';

class UserService {
  static const String _userKey = 'user_data';
  static const String _isLoggedInKey = 'is_logged_in';

  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    // تبدیل کاربر به رشته JSON
    final userString = jsonEncode(user.toJson());
    await prefs.setString(_userKey, userString);
    await prefs.setBool(_isLoggedInKey, true);
  }

  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(_userKey);

    if (userString != null) {
      // تبدیل رشته JSON به Map و سپس به User
      final userMap = jsonDecode(userString) as Map<String, dynamic>;
      return User.fromJson(userMap);
    }
    return null;
  }

  Future<void> updateUserProfileImage(String imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(_userKey);

    if (userString != null) {
      // تبدیل رشته JSON به Map
      final userMap = jsonDecode(userString) as Map<String, dynamic>;
      final user = User.fromJson(userMap);
      user.profileImagePath = imagePath;

      // ذخیره مجدد کاربر با تصویر پروفایل جدید
      await saveUser(user);
    }
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }
}
