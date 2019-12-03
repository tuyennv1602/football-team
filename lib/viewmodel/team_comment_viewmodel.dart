import 'package:flutter/material.dart';
import 'package:myfootball/model/comment.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodel/base_viewmodel.dart';

class TeamCommentViewModel extends BaseViewModel {
  Api _api;
  List<Comment> comments;

  TeamCommentViewModel({@required Api api}) : _api = api;

  Future<void> getComments(int teamId) async {
    setBusy(true);
    var resp = await _api.getCommentByTeamId(teamId, 1);
    if (resp.isSuccess) {
      comments = resp.comments;
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
    setBusy(false);
  }
}
