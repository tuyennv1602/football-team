import 'package:flutter/cupertino.dart';
import 'package:myfootball/model/response/team_request_resp.dart';
import 'package:myfootball/model/team_request.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/service/team_services.dart';
import 'package:myfootball/utils/ui_helper.dart';
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

  Future<void> acceptRequest(int index, int requestId, int teamId) async {
    UIHelper.showProgressDialog;
    var resp = await _api.approveRequestMember(requestId);
    UIHelper.hideProgressDialog;
    if (resp.isSuccess) {
      await _teamServices.getTeamDetail(teamId);
      teamRequests.removeAt(index);
      notifyListeners();
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }

  Future<void> rejectRequest(int index, int requestId) async {
    UIHelper.showProgressDialog;
    var resp = await _api.rejectRequestMember(requestId);
    UIHelper.hideProgressDialog;
    if (resp.isSuccess) {
      teamRequests.removeAt(index);
      notifyListeners();
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }
}
