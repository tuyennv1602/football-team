import 'package:flutter/material.dart';
import 'package:myfootball/model/member.dart';
import 'package:myfootball/model/team.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/service/team_services.dart';
import 'package:myfootball/utils/ui_helper.dart';
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

  Future<void> addCaptain(int memberId) async {
    UIHelper.showProgressDialog;
    var resp = await _api.addCaptain(team.id, memberId);
    UIHelper.hideProgressDialog;
    if (resp.isSuccess) {
      team.captainId = memberId;
      _teamServices.setTeam(team);
      notifyListeners();
      UIHelper.showSimpleDialog('Đã thêm đội trưởng đội bóng!',
          isSuccess: true);
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }

  Future<void> kickMember(int index, int memberId) async {
    UIHelper.showProgressDialog;
    var resp = await _api.removeMember(team.id, memberId);
    UIHelper.hideProgressDialog;
    if (resp.isSuccess) {
      team.members.removeAt(index);
      _teamServices.setTeam(team);
      notifyListeners();
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }
}
