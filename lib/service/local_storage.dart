import 'dart:convert';
import 'package:myfootball/model/team.dart';
import 'package:myfootball/model/token.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String ACCESS_TOKEN = 'token';
  static const String TEAM = 'team';

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

  Future<bool> setLastTeam(Team team) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(TEAM, jsonEncode(team));
  }

  Future<Team> getLastTeam() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var teamData = prefs.getString(TEAM);
    if (teamData == null) return null;
    return Team.fromJson(jsonDecode(teamData));
  }

  Future<bool> clearLastTeam() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(TEAM);
  }
}
