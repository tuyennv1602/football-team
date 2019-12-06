import 'package:flutter/material.dart';
import 'package:myfootball/model/comment.dart';
import 'package:myfootball/model/member.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodel/base_viewmodel.dart';

class MemberDetailViewModel extends BaseViewModel {
  Api _api;
  List<Comment> comments;
  Member member;

  MemberDetailViewModel({@required Api api}) : _api = api;

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
}
