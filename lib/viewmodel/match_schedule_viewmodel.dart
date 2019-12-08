import 'package:flutter/material.dart';
import 'package:myfootball/model/invite_request.dart';
import 'package:myfootball/model/match_schedule.dart';
import 'package:myfootball/model/response/match_schedule_resp.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodel/base_viewmodel.dart';

class MatchScheduleViewModel extends BaseViewModel {
  Api _api;
  List<MatchSchedule> matchSchedules = [];
  int teamId;

  MatchScheduleViewModel({@required Api api, @required this.teamId})
      : _api = api;

  Future<MatchScheduleResponse> getMatchSchedules(int teamId) async {
    setBusy(true);
    var resp = await _api.getMatchSchedules(teamId, 1);
    if (resp.isSuccess) {
      this.matchSchedules = resp.matchSchedules;
    }
    setBusy(false);
    return resp;
  }

  Future<void> joinMatch(int index, int matchId) async {
    UIHelper.showProgressDialog;
    var resp = await _api.joinMatch(teamId, matchId);
    UIHelper.hideProgressDialog;
    if (resp.isSuccess) {
      matchSchedules[index].isJoined = true;
      notifyListeners();
      UIHelper.showSimpleDialog('Đăng ký thi đấu thành công!', isSuccess: true);
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }

  Future<void> leaveMatch(int index, int matchId) async {
    UIHelper.showProgressDialog;
    var resp = await _api.leaveMatch(teamId, matchId);
    UIHelper.hideProgressDialog;
    if (resp.isSuccess) {
      matchSchedules[index].isJoined = false;
      notifyListeners();
      UIHelper.showSimpleDialog('Đã huỷ đăng ký thi đấu!', isSuccess: true);
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }

  Future<void> sendInvite(InviteRequest inviteRequest) async {
    UIHelper.showProgressDialog;
    var resp = await _api.sendInviteJoin(inviteRequest);
    UIHelper.hideProgressDialog;
    if (resp.isSuccess) {
      UIHelper.showSimpleDialog('Đã gửi lời mời!', isSuccess: true);
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }
}
