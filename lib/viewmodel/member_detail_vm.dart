import 'package:flutter/material.dart';
import 'package:myfootball/model/comment.dart';
import 'package:myfootball/model/member.dart';
import 'package:myfootball/model/team.dart';
import 'package:myfootball/router/navigation.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/service/team_services.dart';
import 'package:myfootball/view/ui_helper.dart';
import 'package:myfootball/viewmodel/base_viewmodel.dart';

class MemberDetailViewModel extends BaseViewModel {
  Api _api;
  List<Comment> comments;
  Member member;
  TeamServices _teamServices;
  Team team;

  MemberDetailViewModel(
      {@required Api api,
      @required TeamServices teamServices,
      @required this.team})
      : _api = api,
        _teamServices = teamServices;

  initMember(Member member) {
    this.member = member;
  }

  Future<void> getCommentsByUser(int userId, int page) async {
    setBusy(true);
    var resp = await _api.getCommentByUserId(userId, page);
    if (resp.isSuccess) {
      this.comments = resp.comments;
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
    setBusy(false);
  }

  Future<double> submitReview(int userId, double rating, String comment) async {
    UIHelper.showProgressDialog;
    var resp = await _api.reviewUser(userId, rating, comment);
    UIHelper.hideProgressDialog;
    if (resp.isSuccess) {
      this.member.rating = resp.review.rating;
      this.comments.add(resp.review.comment);
      notifyListeners();
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
    return this.member.rating;
  }

  Future<void> updateInfo(String position, String number) async {
    UIHelper.showProgressDialog;
    var resp = await _api.updateMember(team.id, position, number);
    UIHelper.hideProgressDialog;
    if (resp.isSuccess) {
      this.member.position = position;
      this.member.number = number;
      notifyListeners();
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }

  Future<void> addCaptain(int memberId) async {
    UIHelper.showProgressDialog;
    var resp = await _api.addCaptain(team.id, memberId);
    UIHelper.hideProgressDialog;
    if (resp.isSuccess) {
      team.captainId = memberId;
      _teamServices.setTeam(team);
      UIHelper.showSimpleDialog('Đã thêm đội trưởng đội bóng!',
          isSuccess: true);
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }

  Future<void> kickMember(int memberId) async {
    UIHelper.showProgressDialog;
    var resp = await _api.removeMember(team.id, memberId);
    UIHelper.hideProgressDialog;
    if (resp.isSuccess) {
      var index = team.members.indexWhere((member) => member.id == memberId);
      this.team.members.removeAt(index);
      _teamServices.setTeam(team);
      Navigation.instance.goBack();
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }
}
