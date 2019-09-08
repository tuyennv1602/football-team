import 'dart:convert';
import 'package:myfootball/models/token.dart';
import 'package:myfootball/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreference {
  static final AppPreference _instance = AppPreference.internal();
  factory AppPreference() => _instance;
  AppPreference.internal();

  static const String ACCESS_TOKEN = 'token';
  static const String KEY_USER = 'user';

  Future<bool> setToken(Token token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(ACCESS_TOKEN, jsonEncode(token));
  }

  Future<Token> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var tokenData = prefs.getString(ACCESS_TOKEN);
    if (tokenData == null) return null;
    return Token.fromJson(jsonDecode(tokenData));
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
