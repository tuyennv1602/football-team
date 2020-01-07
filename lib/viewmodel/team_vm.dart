import 'package:flutter/material.dart';
import 'package:myfootball/model/response/team_resp.dart';
import 'package:myfootball/model/team.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/service/auth_services.dart';
import 'package:myfootball/router/navigation.dart';
import 'package:myfootball/service/team_services.dart';
import 'package:myfootball/router/paths.dart';
import 'package:myfootball/view/ui_helper.dart';
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

  Future<void> refreshToken() async {
    setBusy(true);
    var resp = await _authServices.refreshToken();
    if (resp.isSuccess) {
      teams = resp.user.teams;
      await _teamServices.checkCurrentTeam(resp.user.teams);
    } else {
      UIHelper.showSimpleDialog(resp.getErrorMessage,
          onConfirmed: () => Navigation.instance.navigateAndRemove(LOGIN));
    }
    setBusy(false);
  }

  Future<TeamResponse> changeTeam(Team team) async {
    var resp = await _teamServices.changeTeam(team);
    return resp;
  }

  Future<void> leaveTeam(int teamId) async {
    UIHelper.showProgressDialog;
    var resp = await _api.leaveTeam(teamId);
    UIHelper.hideProgressDialog;
    if(resp.isSuccess){
      int index = teams.indexWhere((team) => team.id == teamId);
      teams.removeAt(index);
      if(teams.length > 0){
        changeTeam(teams[0]);
      }else{
        changeTeam(null);
      }
      notifyListeners();
    }else{
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }
}
