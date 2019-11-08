import 'package:flutter/cupertino.dart';
import 'package:myfootball/models/responses/base_response.dart';
import 'package:myfootball/models/responses/team_request_resp.dart';
import 'package:myfootball/models/team_request.dart';
import 'package:myfootball/services/api.dart';
import 'package:myfootball/services/team_services.dart';
import 'package:myfootball/viewmodels/base_viewmodel.dart';

class RequestMemberViewModel extends BaseViewModel {
  Api _api;
  TeamServices _teamServices;
  List<TeamRequest> teamRequests = [];

  RequestMemberViewModel(
      {@required Api api, @required TeamServices teamServices})
      : _api = api,
        _teamServices = teamServices;

  Future<TeamRequestResponse> getTeamRequests(int teamId) async {
    setBusy(true);
    var resp = await _api.getTeamRequest(teamId);
    if (resp.isSuccess) {
      teamRequests = resp.teamRequests;
    }
    setBusy(false);
    return resp;
  }

  Future<BaseResponse> acceptRequest(
      int index, int requestId, int teamId) async {
    var resp = await _api.approveRequestMember(requestId);
    await _teamServices.getTeamDetail(teamId);
    teamRequests.removeAt(index);
    notifyListeners();
    return resp;
  }

  Future<BaseResponse> rejectRequest(int index, int requestId) async {
    var resp = await _api.rejectRequestMember(requestId);
    teamRequests.removeAt(index);
    notifyListeners();
    return resp;
  }
}
