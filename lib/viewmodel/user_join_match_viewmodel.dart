import 'package:flutter/material.dart';
import 'package:myfootball/model/match_history.dart';
import 'package:myfootball/model/match_share.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/view/ui_helper.dart';
import 'package:myfootball/viewmodel/base_viewmodel.dart';

class UserJoinMatchViewModel extends BaseViewModel {
  Api _api;
  List<MatchShare> waitRequests = [];
  List<MatchShare> acceptedRequests = [];
  List<MatchHistory> joinedMatches = [];

  UserJoinMatchViewModel({@required Api api}) : _api = api;

  Future<void> getPendingRequests(int page) async {
    setBusy(true);
    var resp = await _api.getPendingMatch(page);
    if (resp.isSuccess) {
     this.waitRequests = resp.matchShares;
    }
    setBusy(false);
  }


  Future<void> getAcceptedRequest(int page) async {
    setBusy(true);
    var resp = await _api.getAcceptedMatch(page);
    if (resp.isSuccess) {
      this.acceptedRequests = resp.matchShares;
    }
    setBusy(false);
  }


  Future<void> getJoinedMatch(int page) async {
    setBusy(true);
    var resp = await _api.getJoinedMatch(page);
    if (resp.isSuccess) {
      this.joinedMatches = resp.matchHistories;
    }
    setBusy(false);
  }

  Future<void> cancelJoinRequest(int tab, int index, int matchUserId) async {
    UIHelper.showProgressDialog;
    var resp = await _api.cancelUserJoinRequest(matchUserId);
    UIHelper.hideProgressDialog;
    if (resp.isSuccess) {
      if (tab == 0) {
        waitRequests.removeAt(index);
      } else if (tab == 1) {
        acceptedRequests.removeAt(index);
      }
      notifyListeners();
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }
}
