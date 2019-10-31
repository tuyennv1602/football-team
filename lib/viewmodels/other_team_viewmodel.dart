import 'package:flutter/material.dart';
import 'package:myfootball/models/responses/team_resp.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/services/api.dart';
import 'package:myfootball/viewmodels/base_viewmodel.dart';

class OtherTeamViewModel extends BaseViewModel {
  Api _api;
  Team team;

  OtherTeamViewModel({@required Api api}) : _api = api;

  Future<TeamResponse> getTeamDetail(int teamId) async {
    setBusy(true);
    var resp = await _api.getTeamDetail(teamId);
    if (resp.isSuccess) {
      this.team = resp.team;
    }
    setBusy(false);
    return resp;
  }
}
