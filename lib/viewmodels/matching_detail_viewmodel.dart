import 'package:flutter/material.dart';
import 'package:myfootball/models/member.dart';
import 'package:myfootball/models/responses/member_resp.dart';
import 'package:myfootball/services/api.dart';
import 'package:myfootball/viewmodels/base_viewmodel.dart';

class MatchingDetailViewModel extends BaseViewModel {
  Api _api;
  List<Member> myTeamMembers;
  List<Member> opponentTeamMembers;

  MatchingDetailViewModel({@required Api api}) : _api = api;

  Future<MemberResponse> getMyTeamMembers(int matchId, int teamId) async {
    setBusy(true);
    var resp = await _api.getJoinedMember(matchId, teamId);
    if (resp.isSuccess) {
      this.myTeamMembers = resp.members;
    }
    setBusy(false);
    return resp;
  }

  Future<MemberResponse> getOpponentTeamMembers(int matchId, int teamId) async {
    setBusy(true);
    var resp = await _api.getJoinedMember(matchId, teamId);
    if (resp.isSuccess) {
      this.opponentTeamMembers = resp.members;
    }
    setBusy(false);
    return resp;
  }
}
