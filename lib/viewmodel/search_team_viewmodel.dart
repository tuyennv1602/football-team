import 'package:flutter/material.dart';
import 'package:myfootball/model/response/base_response.dart';
import 'package:myfootball/model/response/search_team_resp.dart';
import 'package:myfootball/model/team.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/viewmodel/base_viewmodel.dart';

class SearchTeamViewModel extends BaseViewModel {
  Api _api;
  List<Team> teams;
  String key;
  bool isLoading = false;

  SearchTeamViewModel({@required Api api}) : _api = api;

  Future<SearchTeamResponse> searchTeamByKey(String key) async {
    this.key = key;
    _setLoading(true);
    var resp = await _api.searchTeamByKey(key);
    if (resp.isSuccess) {
      teams = resp.teams;
    }
    _setLoading(false);
    return resp;
  }

  void _setLoading(bool isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }

  Future<BaseResponse> createRequest(
      int teamId, String content, String position) async {
    var resp = await _api.createRequestMember(teamId, content, position);
    return resp;
  }
}
