import 'package:flutter/cupertino.dart';
import 'package:myfootball/model/fund.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/view/ui_helper.dart';
import 'package:myfootball/viewmodel/base_viewmodel.dart';

class TeamFundViewModel extends BaseViewModel {
  Api _api;
  List<Fund> funds = [];
  int page = 1;
  bool canLoadMore = false;

  TeamFundViewModel({@required Api api}) : _api = api;

  Future<void> getFunds(int teamId, bool isRefresh) async {
    if (isRefresh) {
      page = 1;
      funds.clear();
    } else {
      setBusy(page == 1);
    }
    var resp = await _api.getFundByTeam(teamId, page);
    if (resp.isSuccess) {
      this.funds.addAll(resp.funds);
      this.canLoadMore = resp.funds.length == 10;
      page++;
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
