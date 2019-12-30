import 'package:flutter/material.dart';
import 'package:myfootball/model/match_history.dart';
import 'package:myfootball/model/match_share.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodel/base_viewmodel.dart';

class UserJoinMatchViewModel extends BaseViewModel {
  Api _api;
  List<MatchShare> waitRequests = [];
  List<MatchShare> acceptedRequests = [];
  List<MatchHistory> joinedMatches = [];
  bool isLoadingRequest = true;
  bool isLoadingAccepted = true;
  bool isLoadingJoined = true;


  UserJoinMatchViewModel({@required Api api}) : _api = api;

  Future<void> getPendingRequests(int page) async {
    isLoadingRequest = true;
    notifyListeners();
    var resp = await _api.getPendingMatch(page);
    if (resp.isSuccess) {
      this.waitRequests = resp.matchShares;
    }
    isLoadingRequest = false;
    notifyListeners();
  }

  Future<void> getAcceptedRequest(int page) async {
    isLoadingAccepted = true;
    notifyListeners();
    var resp = await _api.getAcceptedMatch(page);
    if (resp.isSuccess) {
      this.acceptedRequests = resp.matchShares;
    }
    isLoadingAccepted = false;
    notifyListeners();
  }

  Future<void> getJoinedMatch(int page) async {
    isLoadingJoined = true;
    notifyListeners();
    var resp = await _api.getJoinedMatch(page);
    if (resp.isSuccess) {
      this.joinedMatches = resp.matchHistories;
    }
    isLoadingJoined = false;
    notifyListeners();
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
