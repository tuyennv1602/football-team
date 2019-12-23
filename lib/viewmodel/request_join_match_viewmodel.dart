import 'package:flutter/material.dart';
import 'package:myfootball/model/match_user.dart';
import 'package:myfootball/model/response/base_response.dart';
import 'package:myfootball/service/api.dart';
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
    }
    setBusy(false);
  }

  Future<BaseResponse> acceptRequest(int index, int matchUserId) async {
    var resp = await _api.acceptUserJoinRequest(matchUserId);
    if (resp.isSuccess) {
      this.matchUsers.removeAt(index);
      notifyListeners();
    }
    return resp;
  }

  Future<BaseResponse> rejectRequest(int index, int matchUserId) async {
    var resp = await _api.rejectUserJoinRequest(matchUserId);
    if (resp.isSuccess) {
      this.matchUsers.removeAt(index);
      notifyListeners();
    }
    return resp;
  }
}
