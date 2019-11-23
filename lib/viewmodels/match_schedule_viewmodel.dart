import 'package:flutter/material.dart';
import 'package:myfootball/models/match_schedule.dart';
import 'package:myfootball/models/responses/match_schedule_resp.dart';
import 'package:myfootball/services/api.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodels/base_viewmodel.dart';

class MatchScheduleViewModel extends BaseViewModel {
  Api _api;
  List<MatchSchedule> matchSchedules = [];

  MatchScheduleViewModel({@required Api api}) : _api = api;

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
    var resp = await _api.joinMatch(matchId);
    UIHelper.hideProgressDialog;
    if (resp.isSuccess) {
      matchSchedules[index].isJoined = true;
      notifyListeners();
      UIHelper.showSimpleDialog('Đăng ký thành công!', isSuccess: true);
    }else{
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }

  Future<void> leaveMatch(int index, int matchId) async {
    UIHelper.showProgressDialog;
    var resp = await _api.leaveMatch(matchId);
    UIHelper.hideProgressDialog;
    if (resp.isSuccess) {
      matchSchedules[index].isJoined = false;
      notifyListeners();
      UIHelper.showSimpleDialog('Đã huỷ đăng ký thi đấu!', isSuccess: true);
    }else{
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }
}
