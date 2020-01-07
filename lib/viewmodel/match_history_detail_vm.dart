import 'package:flutter/material.dart';
import 'package:myfootball/model/match_history.dart';
import 'package:myfootball/model/member.dart';
import 'package:myfootball/model/response/member_resp.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/view/ui_helper.dart';
import 'package:myfootball/viewmodel/base_viewmodel.dart';

class MatchHistoryDetailViewModel extends BaseViewModel {
  Api _api;
  List<Member> myTeamMembers;
  List<Member> opponentTeamMembers;
  MatchHistory matchHistory;

  MatchHistoryDetailViewModel({@required Api api, @required this.matchHistory})
      : _api = api;

  Future<MemberResponse> getMyTeamMembers(int teamId) async {
    setBusy(true);
    var resp = await _api.getJoinedMember(matchHistory.matchId, teamId);
    if (resp.isSuccess) {
      this.myTeamMembers = resp.members;
    }
    setBusy(false);
    return resp;
  }

  Future<MemberResponse> getOpponentTeamMembers(int teamId) async {
    setBusy(true);
    var resp = await _api.getJoinedMember(matchHistory.matchId, teamId);
    if (resp.isSuccess) {
      this.opponentTeamMembers = resp.members;
    }
    setBusy(false);
    return resp;
  }

  Future<bool> confirmScore() async {
    var resp = await _api.memberConfirm(matchHistory.matchId);
    if (resp.isSuccess) {
      matchHistory.countConfirmed++;
      matchHistory.userConfirmed = true;
      notifyListeners();
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
    return resp.isSuccess;
  }

  Future<bool> cancelConfirmScore() async {
    var resp = await _api.memberCancelConfirm(matchHistory.matchId);
    if (resp.isSuccess) {
      matchHistory.countConfirmed--;
      matchHistory.userConfirmed = false;
      notifyListeners();
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
    return resp.isSuccess;
  }
}
