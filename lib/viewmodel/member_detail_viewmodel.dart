import 'package:flutter/material.dart';
import 'package:myfootball/model/comment.dart';
import 'package:myfootball/model/member.dart';
import 'package:myfootball/model/response/base_response.dart';
import 'package:myfootball/model/response/review_resp.dart';
import 'package:myfootball/service/api.dart';
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
    }
    setBusy(false);
  }

  Future<ReviewResponse> submitReview(
      int userId, double rating, String comment) async {
    var resp = await _api.reviewUser(userId, rating, comment);
    if (resp.isSuccess) {
      this.member.rating = resp.review.rating;
      this.comments.add(resp.review.comment);
      notifyListeners();
    }
    return resp;
  }

  Future<BaseResponse> updateInfo(
      int teamId, String position, String number) async {
    var resp = await _api.updateMember(teamId, position, number);
    if (resp.isSuccess) {
      this.member.position = position;
      this.member.number = number;
      notifyListeners();
    }
    return resp;
  }
}
