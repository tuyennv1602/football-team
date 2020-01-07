import 'package:flutter/material.dart';
import 'package:myfootball/model/fund_member.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/view/ui_helper.dart';
import 'package:myfootball/viewmodel/base_viewmodel.dart';

class FundRequestViewModel extends BaseViewModel {
  Api _api;
  List<FundMember> members = [];

  FundRequestViewModel({@required Api api}) : _api = api;

  Future<void> getFundsStatus(int teamId, int noticeId) async {
    setBusy(true);
    var resp = await _api.getFundRequestByNotice(teamId, noticeId);
    if (resp.isSuccess) {
      this.members = resp.members;
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
    setBusy(false);
  }

  Future<void> acceptRequest(int index, int requestId) async {
    UIHelper.showProgressDialog;
    var resp = await _api.acceptFundRequest(requestId);
    UIHelper.hideProgressDialog;
    if (resp.isSuccess) {
      this.members[index].status = 1;
      notifyListeners();
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }
}
