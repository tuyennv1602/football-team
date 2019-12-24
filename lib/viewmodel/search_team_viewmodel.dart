import 'package:flutter/material.dart';
import 'package:myfootball/model/response/base_response.dart';
import 'package:myfootball/model/response/search_team_resp.dart';
import 'package:myfootball/model/team.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/viewmodel/base_viewmodel.dart';

class SearchTeamViewModel extends BaseViewModel {
  Api _api;
  List<Team> teams = [];
  List<Team> allTeams = [];
  String key = '';
  bool isLoading = false;

  SearchTeamViewModel({@required Api api}) : _api = api;

  Future<void> getAllTeam(bool isRefresh) async {
    setBusy(!isRefresh);
    var resp = await _api.getAllTeam(1);
    if (resp.isSuccess) {
      this.allTeams = resp.teams;
      this.teams = resp.teams;
    }
    setBusy(false);
  }

  Future<void> searchTeamByKey(String key) async {
    if (key.isEmpty) {
      this.key = '';
      this.teams = this.allTeams;
      isLoading = false;
      notifyListeners();
    } else {
      this.key = key;
      this.isLoading = true;
      notifyListeners();
      var resp = await _api.searchTeamByKey(key, 1);
      if (resp.isSuccess) {
        teams = resp.teams;
      }
      this.isLoading = false;
      notifyListeners();
    }
  }

  Future<BaseResponse> createRequest(
      int teamId, String content, String position) async {
    var resp = await _api.createRequestMember(teamId, content, position);
    return resp;
  }
}
