import 'package:flutter/material.dart';
import 'package:myfootball/model/response/base_response.dart';
import 'package:myfootball/model/team.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/service/team_services.dart';
import 'package:myfootball/viewmodel/base_viewmodel.dart';

class MemberViewModel extends BaseViewModel {
  Api _api;
  Team team;
  TeamServices _teamServices;

  MemberViewModel(
      {@required Api api,
      @required this.team,
      @required TeamServices teamServices})
      : _api = api,
        _teamServices = teamServices;

  Future<BaseResponse> addCaptain(int memberId) async {
    var resp = await _api.addCaptain(team.id, memberId);
    if (resp.isSuccess) {
      team.captainId = memberId;
      _teamServices.setTeam(team);
      notifyListeners();
    }
    return resp;
  }

  Future<BaseResponse> kickMember(int index, int memberId) async {
    var resp = await _api.removeMember(team.id, memberId);
    if (resp.isSuccess) {
      team.members.removeAt(index);
      _teamServices.setTeam(team);
      notifyListeners();
    }
    return resp;
  }
}
