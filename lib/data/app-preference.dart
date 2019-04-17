import 'package:shared_preferences/shared_preferences.dart';

class AppPreference {
  static final AppPreference _instance = AppPreference.internal();
  factory AppPreference() => _instance;
  AppPreference.internal();

  // static const String KEY_BIRTHDAY = 'birthday';

  // Future<DateTime> setBirthday(DateTime birthday) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var rs = await prefs.setString(KEY_BIRTHDAY, birthday.toString());
  //   return rs ? birthday : null;
  // }

  // Future<String> getBirthday() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString(KEY_BIRTHDAY);
  // }
}