import 'package:flutter/material.dart';
import 'package:myfootball/model/invite_request.dart';
import 'package:myfootball/model/match_schedule.dart';
import 'package:myfootball/model/response/base_response.dart';
import 'package:myfootball/model/response/match_schedule_resp.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/viewmodel/base_viewmodel.dart';

class MatchScheduleViewModel extends BaseViewModel {
  Api _api;
  List<MatchSchedule> matchSchedules = [];
  int teamId;

  MatchScheduleViewModel({@required Api api, @required this.teamId})
      : _api = api;

  Future<MatchScheduleResponse> getMatchSchedules(
      int page, bool isRefresh) async {
    setBusy(!isRefresh);
    var resp = await _api.getMatchSchedule(teamId, page);
    if (resp.isSuccess) {
      this.matchSchedules = resp.matchSchedules;
    }
    setBusy(false);
    return resp;
  }

  Future<BaseResponse> joinMatch(int index, int matchId) async {
    var resp = await _api.joinMatch(teamId, matchId);
    if (resp.isSuccess) {
      matchSchedules[index].isJoined = true;
      notifyListeners();
    }
    return resp;
  }

  Future<BaseResponse> leaveMatch(int index, int matchId) async {
    var resp = await _api.leaveMatch(teamId, matchId);
    if (resp.isSuccess) {
      matchSchedules[index].isJoined = false;
      notifyListeners();
    }
    return resp;
  }

  Future<BaseResponse> sendInvite(InviteRequest inviteRequest) async {
    var resp = await _api.sendInviteJoin(inviteRequest);
    return resp;
  }
}
