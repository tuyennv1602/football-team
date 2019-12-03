import 'package:flutter/material.dart';
import 'package:myfootball/model/response/team_resp.dart';
import 'package:myfootball/model/team.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/service/auth_services.dart';
import 'package:myfootball/service/navigation_services.dart';
import 'package:myfootball/service/team_services.dart';
import 'package:myfootball/utils/router_paths.dart';
import 'package:myfootball/utils/ui_helper.dart';
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
          onConfirmed: () => NavigationService.instance.navigateAndRemove(LOGIN));
    }
    setBusy(false);
  }

  Future<TeamResponse> changeTeam(Team team) async {
    var resp = await _teamServices.changeTeam(team);
    return resp;
  }
}
