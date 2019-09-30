import 'package:flutter/cupertino.dart';
import 'package:myfootball/models/responses/team_request_resp.dart';
import 'package:myfootball/models/team_request.dart';
import 'package:myfootball/services/api.dart';
import 'package:myfootball/viewmodels/base_view_model.dart';

class MemberMangerViewModel extends BaseViewModel {
  Api _api;
  List<TeamRequest> teamRequests = [];

  MemberMangerViewModel({@required Api api}) : _api = api;

  Future<TeamRequestResponse> getTeamRequests(int teamId) async {
    setBusy(true);
    var resp = await _api.getTeamRequest(teamId);
    if (resp.isSuccess) {
      teamRequests = resp.teamRequests;
    }
    setBusy(false);
    return resp;
  }
}
