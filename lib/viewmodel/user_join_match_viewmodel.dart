import 'package:flutter/material.dart';
import 'package:myfootball/model/match_share.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodel/base_viewmodel.dart';

class UserJoinMatchViewModel extends BaseViewModel {
  Api _api;
  List<MatchShare> waitRequests = [];
  List<MatchShare> acceptedRequest = [];

  UserJoinMatchViewModel({@required Api api}) : _api = api;

  Future<void> getUserJoinRequest(int page) async {
    setBusy(true);
    var resp = await _api.getUserJoinMatch(page);
    if (resp.isSuccess && resp.matchShares != null) {
      resp.matchShares.forEach((item) {
        if (item.requestStatus == 0) {
          waitRequests.add(item);
        } else {
          acceptedRequest.add(item);
        }
      });
    }
    setBusy(false);
  }

  Future<void> cancelJoinRequest(int tab, int index, int matchShareId) async {
    UIHelper.showProgressDialog;
    var resp = await _api.cancelUserJoinRequest(matchShareId);
    UIHelper.hideProgressDialog;
    if (resp.isSuccess) {
      if (tab == 0) {
        waitRequests.removeAt(index);
      }
      notifyListeners();
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }
}
