import 'package:flutter/cupertino.dart';
import 'package:myfootball/models/responses/base_response.dart';
import 'package:myfootball/models/responses/search_team_resp.dart';
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
    _setLoading((true));
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
      int teamId, String content, List<String> positions) async {
    setBusy(true);
    var resp =
        await _api.createRequestMember(teamId, content, positions.join(','));
    setBusy(false);
    return resp;
  }
}
