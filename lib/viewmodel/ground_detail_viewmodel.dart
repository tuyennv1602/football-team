import 'package:flutter/material.dart';
import 'package:myfootball/model/comment.dart';
import 'package:myfootball/model/ground.dart';
import 'package:myfootball/model/response/comments_resp.dart';
import 'package:myfootball/model/response/ground_resp.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodel/base_viewmodel.dart';

class GroundDetailViewModel extends BaseViewModel {
  Api _api;
  Ground ground;
  int _groundId;
  List<Comment> comments;
  bool isLoading;

  GroundDetailViewModel({@required Api api, @required int groundId})
      : _api = api,
        _groundId = groundId;

  Future<GroundResponse> getGroundDetail() async {
    setBusy(true);
    var resp = await _api.getGroundDetail(_groundId);
    if (resp.isSuccess) {
      this.ground = resp.ground;
    }
    setBusy(false);
    return resp;
  }

  Future<CommentResponse> getComments() async {
    setLoading(true);
    var resp = await _api.getCommentByGroundId(_groundId, 1);
    if (resp.isSuccess) {
      comments = resp.comments;
    }
    setLoading(false);
    return resp;
  }

  Future<void> submitReview(double rating, String comment) async {
    UIHelper.showProgressDialog;
    var resp = await _api.reviewGround(_groundId, rating, comment);
    UIHelper.hideProgressDialog;
    if (resp.isSuccess) {
      this.ground.rating = resp.review.rating;
      this.comments.add(resp.review.comment);
      notifyListeners();
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }

  setLoading(bool isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }
}
