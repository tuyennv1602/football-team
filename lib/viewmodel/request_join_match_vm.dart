import 'package:flutter/material.dart';
import 'package:myfootball/model/match_user.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/view/ui_helper.dart';
import 'package:myfootball/viewmodel/base_viewmodel.dart';

class RequestJoinMatchViewModel extends BaseViewModel {
  Api _api;

  List<MatchUser> matchUsers;

  RequestJoinMatchViewModel({@required Api api}) : _api = api;

  Future<void> getAllRequests(int matchId, int teamId) async {
    setBusy(true);
    var resp = await _api.getRequestJoin(matchId, teamId);
    if (resp.isSuccess) {
      this.matchUsers = resp.matchUsers;
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
    setBusy(false);
  }

  Future<bool> acceptRequest(int index, int matchUserId) async {
    UIHelper.showProgressDialog;
    var resp = await _api.acceptUserJoinRequest(matchUserId);
    UIHelper.hideProgressDialog;
    if (resp.isSuccess) {
      this.matchUsers.removeAt(index);
      notifyListeners();
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
    return resp.isSuccess;
  }

  Future<void> rejectRequest(int index, int matchUserId) async {
    UIHelper.showProgressDialog;
    var resp = await _api.rejectUserJoinRequest(matchUserId);
    UIHelper.hideProgressDialog;
    if (resp.isSuccess) {
      this.matchUsers.removeAt(index);
      notifyListeners();
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }
}
