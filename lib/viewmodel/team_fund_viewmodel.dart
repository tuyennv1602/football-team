import 'package:flutter/cupertino.dart';
import 'package:myfootball/model/fund.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodel/base_viewmodel.dart';

class TeamFundViewModel extends BaseViewModel {
  Api _api;

  List<Fund> funds = [];

  TeamFundViewModel({@required Api api}) : _api = api;

  Future<void> getFunds(int teamId) async {
    setBusy(true);
    var resp = await _api.getFundsByTeam(teamId);
    if (resp.isSuccess) {
      this.funds = resp.funds;
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
    setBusy(false);
  }

  Future<void> sendRequest(int index, int noticeId) async {
    UIHelper.showProgressDialog;
    var resp = await _api.sendFundRequest(noticeId);
    UIHelper.hideProgressDialog;
    if (resp.isSuccess) {
      funds[index].status = 4;
      notifyListeners();
      UIHelper.showSimpleDialog(
          'Yêu cầu của bạn đã được gửi. Vui lòng chờ xác nhận',
          isSuccess: true);
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }
}
