import 'package:flutter/cupertino.dart';
import 'package:myfootball/models/responses/search-team-response.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/services/api.dart';
import 'package:myfootball/viewmodels/base_view_model.dart';

class RequestMemberViewModel extends BaseViewModel {
  Api _api;
  List<Team> teams;
  String key;
  bool isLoading = false;

  RequestMemberViewModel({@required Api api}) : _api = api;

  Future<SearchTeamResponse> searchTeamByKey(String key) async {
    this.key = key;
    isLoading = true;
    notifyListeners();
    var resp = await _api.searchTeamByKey(key);
    if (resp.isSuccess) {
      teams = resp.teams;
    }
    isLoading = false;
    notifyListeners();
    return resp;
  }
}
