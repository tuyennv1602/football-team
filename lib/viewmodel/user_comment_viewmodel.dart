import 'package:flutter/material.dart';
import 'package:myfootball/model/comment.dart';
import 'package:myfootball/model/response/base_response.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/viewmodel/base_viewmodel.dart';

class UserCommentViewModel extends BaseViewModel {
  Api _api;
  List<Comment> comments;

  UserCommentViewModel({@required Api api}) : _api = api;

  Future<void> getComments(int userId) async {
    setBusy(true);
    var resp = await _api.getCommentByUserId(userId, 1);
    if (resp.isSuccess) {
      comments = resp.comments;
    }
    setBusy(false);
  }

  Future<BaseResponse> submitReview(
      int userId, double rating, String comment) async {
    var resp = await _api.reviewUser(userId, rating, comment);
    if (resp.isSuccess) {
      this.comments.add(resp.review.comment);
      notifyListeners();
    }
    return resp;
  }
}
