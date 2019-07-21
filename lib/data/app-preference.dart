import 'dart:convert';
import 'package:myfootball/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreference {
  static final AppPreference _instance = AppPreference.internal();
  factory AppPreference() => _instance;
  AppPreference.internal();

  static const String ACCESS_TOKEN = 'token';
  static const String KEY_USER = 'user';

  Future<bool> setToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(ACCESS_TOKEN, token);
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(ACCESS_TOKEN);
  }

  Future<bool> clearToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(ACCESS_TOKEN);
  }

  Future<bool> setUser(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(KEY_USER, jsonEncode(user));
  }

  Future<User> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userData = prefs.getString(KEY_USER);
    if (userData == null) return null;
    return User.fromJson(jsonDecode(userData));
  }

  Future<bool> clearUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(KEY_USER);
  }
}
