import 'package:flutter/material.dart';
import 'package:myfootball/models/member.dart';
import 'package:myfootball/services/api.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodels/base_viewmodel.dart';

class FundRequestViewModel extends BaseViewModel {
  Api _api;
  List<Member> members = [];

  FundRequestViewModel({@required Api api}) : _api = api;

  Future<void> getFundsStatus(int teamId, int noticeId) async {
    setBusy(true);
    var resp = await _api.getFundStatusByNoticeId(teamId, noticeId);
    if (resp.isSuccess) {
      this.members = resp.members;
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
    setBusy(false);
  }
}
