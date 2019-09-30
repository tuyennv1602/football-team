import 'package:flutter/material.dart';
import 'package:myfootball/models/responses/login_resp.dart';
import 'package:myfootball/models/responses/team_resp.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/services/api.dart';
import 'package:myfootball/services/auth_services.dart';
import 'package:myfootball/services/share_preferences.dart';
import 'package:myfootball/viewmodels/base_view_model.dart';

class TeamViewModel extends BaseViewModel {
  AuthServices _authServices;
  Api _api;
  SharePreferences _sharePreferences;
  bool unAuth = false;
  List<Team> teams;
  Team currentTeam;

  TeamViewModel(
      {@required AuthServices authServices,
      SharePreferences sharePreferences,
      Api api})
      : _authServices = authServices,
        _sharePreferences = sharePreferences,
        _api = api;

  Future<LoginResponse> refreshToken() async {
    setBusy(true);
    var resp = await _authServices.refreshToken();
    if (!resp.isSuccess) {
      unAuth = true;
      _sharePreferences.clearToken();
    } else {
      // update teams info
      teams = resp.user.teams;
      if (teams.length > 0) {
        var _lastTeam = await _sharePreferences.getLastTeam();
        if (_lastTeam == null) {
          currentTeam = teams[0];
        } else {
          currentTeam = _lastTeam;
        }
        await getTeamDetail(currentTeam.id);
      }
    }
    setBusy(false);
    return resp;
  }

  Future<TeamResponse> getTeamDetail(int teamId) async {
    var resp = await _api.getTeamDetail(teamId);
    if(resp.isSuccess){
      currentTeam = resp.team;
    }
    notifyListeners();
    return resp;
  }

  changeTeam(Team team) {
    currentTeam = team;
    _sharePreferences.setLastTeam(team);
    getTeamDetail(team.id);
  }
}
