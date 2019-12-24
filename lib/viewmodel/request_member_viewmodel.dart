import 'package:flutter/cupertino.dart';
import 'package:myfootball/model/response/base_response.dart';
import 'package:myfootball/model/response/team_request_resp.dart';
import 'package:myfootball/model/team_request.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/service/team_services.dart';
import 'package:myfootball/viewmodel/base_viewmodel.dart';

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
    var resp = await _api.getJoinTeamRequest(teamId);
    if (resp.isSuccess) {
      teamRequests = resp.teamRequests;
    }
    setBusy(false);
    return resp;
  }

  Future<BaseResponse> acceptRequest(
      int index, int requestId, int teamId) async {
    var resp = await _api.approveRequestMember(requestId);
    if (resp.isSuccess) {
      await _teamServices.getTeamDetail(teamId);
      teamRequests.removeAt(index);
      notifyListeners();
    }
    return resp;
  }

  Future<BaseResponse> rejectRequest(int index, int requestId) async {
    var resp = await _api.rejectRequestMember(requestId);
    if (resp.isSuccess) {
      teamRequests.removeAt(index);
      notifyListeners();
    }
    return resp;
  }
}
