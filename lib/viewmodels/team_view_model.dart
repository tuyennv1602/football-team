import 'package:flutter/material.dart';
import 'package:myfootball/models/responses/login_resp.dart';
import 'package:myfootball/models/responses/team_resp.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/services/api.dart';
import 'package:myfootball/services/auth_services.dart';
import 'package:myfootball/services/share_preferences.dart';
import 'package:myfootball/services/team_services.dart';
import 'package:myfootball/viewmodels/base_view_model.dart';

class TeamViewModel extends BaseViewModel {
  final AuthServices _authServices;
  final TeamServices _teamServices;
  final Api _api;
  final SharePreferences _sharePreferences;
  bool unAuth = false;
  List<Team> teams;

  TeamViewModel(
      {@required AuthServices authServices,
      @required TeamServices teamServices,
      SharePreferences sharePreferences,
      Api api})
      : _authServices = authServices,
        _teamServices = teamServices,
        _sharePreferences = sharePreferences,
        _api = api;

  Future<LoginResponse> refreshToken() async {
    setBusy(true);
    var resp = await _authServices.refreshToken();
    if (!resp.isSuccess) {
      unAuth = true;
      _sharePreferences.clearToken();
    } else {
      teams = resp.user.teams;
      await _teamServices.checkCurrentTeam(resp.user.teams);
    }
    setBusy(false);
    return resp;
  }

  Future<TeamResponse> changeTeam(Team team) async {
    var resp = await _teamServices.changeTeam(team);
    return resp;
  }
}
