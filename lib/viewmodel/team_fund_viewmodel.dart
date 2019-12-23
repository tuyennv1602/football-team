import 'package:flutter/cupertino.dart';
import 'package:myfootball/model/fund.dart';
import 'package:myfootball/model/response/base_response.dart';
import 'package:myfootball/service/api.dart';
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
    }
    setBusy(false);
  }

  Future<BaseResponse> sendRequest(int index, int noticeId) async {
    var resp = await _api.sendFundRequest(noticeId);
    if (resp.isSuccess) {
      funds[index].status = 4;
      notifyListeners();
    }
    return resp;
  }
}
