import 'package:flutter/cupertino.dart';
import 'package:myfootball/models/fund.dart';
import 'package:myfootball/services/api.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodels/base_viewmodel.dart';

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
}
