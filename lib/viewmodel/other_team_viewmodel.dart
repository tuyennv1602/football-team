import 'package:flutter/material.dart';
import 'package:myfootball/model/comment.dart';
import 'package:myfootball/model/response/base_response.dart';
import 'package:myfootball/model/response/comments_resp.dart';
import 'package:myfootball/model/response/team_resp.dart';
import 'package:myfootball/model/team.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/viewmodel/base_viewmodel.dart';

class OtherTeamViewModel extends BaseViewModel {
  Api _api;
  Team team;
  List<Comment> comments;
  bool isLoading;

  OtherTeamViewModel({@required Api api, @required this.team}) : _api = api;

  Future<TeamResponse> getTeamDetail() async {
    setBusy(true);
    var resp = await _api.getTeamDetail(team.id);
    if (resp.isSuccess) {
      this.team = resp.team;
    }
    setBusy(false);
    return resp;
  }

  Future<CommentResponse> getComments() async {
    setLoading(true);
    var resp = await _api.getCommentByTeamId(team.id, 1);
    if (resp.isSuccess) {
      comments = resp.comments;
    }
    setLoading(false);
    return resp;
  }

  Future<BaseResponse> submitReview(double rating, String comment) async {
    var resp = await _api.reviewTeam(team.id, rating, comment);
    if (resp.isSuccess) {
      this.team.rating = resp.review.rating;
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
