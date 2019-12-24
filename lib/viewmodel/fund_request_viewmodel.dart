import 'package:flutter/material.dart';
import 'package:myfootball/model/fund_member.dart';
import 'package:myfootball/model/response/base_response.dart';
import 'package:myfootball/service/api.dart';
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
    }
    setBusy(false);
  }

  Future<BaseResponse> acceptRequest(int index, int requestId) async {
    var resp = await _api.acceptFundRequest(requestId);
    if (resp.isSuccess) {
      this.members[index].status = 1;
      notifyListeners();
    }
    return resp;
  }
}
