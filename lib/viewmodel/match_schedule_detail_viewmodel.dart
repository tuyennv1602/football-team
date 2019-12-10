import 'package:flutter/material.dart';
import 'package:myfootball/model/match_schedule.dart';
import 'package:myfootball/model/member.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodel/base_viewmodel.dart';

class MatchScheduleDetailViewModel extends BaseViewModel {
  Api _api;
  List<Member> myTeamMembers;
  List<Member> opponentTeamMembers;
  MatchSchedule matchSchedule;

  MatchScheduleDetailViewModel(
      {@required Api api, @required this.matchSchedule})
      : _api = api;

  Future<void> getMyTeamMembers(int teamId) async {
    setBusy(true);
    var resp = await _api.getJoinedMember(matchSchedule.matchId, teamId);
    if (resp.isSuccess) {
      this.myTeamMembers = resp.members;
    }
    setBusy(false);
  }

  Future<void> getOpponentTeamMembers(int teamId) async {
    setBusy(true);
    var resp = await _api.getJoinedMember(matchSchedule.matchId, teamId);
    if (resp.isSuccess) {
      this.opponentTeamMembers = resp.members;
    }
    setBusy(false);
  }

  Future<String> createCode(int teamId) async {
    UIHelper.showProgressDialog;
    var resp = await _api.createCode(matchSchedule.matchId, teamId);
    UIHelper.hideProgressDialog;
    if (resp.isSuccess) {
      this.matchSchedule.getMyTeam.code = resp.code;
      notifyListeners();
      return resp.code;
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
    return null;
  }
}
