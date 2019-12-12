import 'package:flutter/material.dart';
import 'package:myfootball/model/match_share.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodel/base_viewmodel.dart';

class UserJoinMatchViewModel extends BaseViewModel {
  Api _api;
  List<MatchShare> waitRequests = [];
  List<MatchShare> acceptedRequest = [];
  List<MatchShare> joined = [];

  UserJoinMatchViewModel({@required Api api}) : _api = api;

  Future<void> getUserJoinRequest(int page) async {
    setBusy(true);
    var resp = await _api.getUserJoinMatch(page);
    if (resp.isSuccess && resp.matchShares != null) {
      resp.matchShares.forEach((item) {
        if (item.requestStatus == 4) {
          waitRequests.add(item);
        } else if (item.requestStatus == 1) {
          acceptedRequest.add(item);
        } else {}
      });
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
        acceptedRequest.removeAt(index);
      }
      notifyListeners();
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }
}
