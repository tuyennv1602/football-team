import 'package:flutter/material.dart';
import 'package:myfootball/model/comment.dart';
import 'package:myfootball/model/ground.dart';
import 'package:myfootball/model/response/review_resp.dart';
import 'package:myfootball/service/api.dart';
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

  Future<void> getGroundDetail() async {
    setBusy(true);
    var resp = await _api.getGroundDetail(_groundId);
    if (resp.isSuccess) {
      this.ground = resp.ground;
    }
    setBusy(false);
  }

  Future<void> getComments() async {
    setLoading(true);
    var resp = await _api.getCommentByGroundId(_groundId, 1);
    if (resp.isSuccess) {
      comments = resp.comments;
    }
    setLoading(false);
  }

  Future<ReviewResponse> submitReview(double rating, String comment) async {
    var resp = await _api.reviewGround(_groundId, rating, comment);
    if (resp.isSuccess) {
      this.ground.rating = resp.review.rating;
      this.comments.add(resp.review.comment);
      notifyListeners();
    }
    return resp;
  }

  setLoading(bool isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }
}
