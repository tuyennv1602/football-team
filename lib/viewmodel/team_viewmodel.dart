import 'package:flutter/material.dart';
import 'package:myfootball/model/response/base_response.dart';
import 'package:myfootball/model/response/login_resp.dart';
import 'package:myfootball/model/response/team_resp.dart';
import 'package:myfootball/model/team.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/service/auth_services.dart';
import 'package:myfootball/service/team_services.dart';
import 'package:myfootball/viewmodel/base_viewmodel.dart';

class TeamViewModel extends BaseViewModel {
  final AuthServices _authServices;
  final TeamServices _teamServices;
  final Api _api;
  List<Team> teams;

  TeamViewModel(
      {@required AuthServices authServices,
      @required TeamServices teamServices,
      Api api})
      : _authServices = authServices,
        _teamServices = teamServices,
        _api = api;

  Future<LoginResponse> refreshToken() async {
    setBusy(true);
    var resp = await _authServices.refreshToken();
    if (resp.isSuccess) {
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

  Future<BaseResponse> leaveTeam(int teamId) async {
    var resp = await _api.leaveTeam(teamId);
    if (resp.isSuccess) {
      int index = teams.indexWhere((team) => team.id == teamId);
      teams.removeAt(index);
      if (teams.length > 0) {
        changeTeam(teams[0]);
      } else {
        changeTeam(null);
      }
      notifyListeners();
    }
    return resp;
  }
}
