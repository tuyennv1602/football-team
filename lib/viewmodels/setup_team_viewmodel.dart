import 'package:flutter/cupertino.dart';
import 'package:myfootball/models/responses/base_response.dart';
import 'package:myfootball/services/api.dart';
import 'package:myfootball/services/team_services.dart';
import 'package:myfootball/viewmodels/base_viewmodel.dart';

class SetupTeamViewModel extends BaseViewModel {
  Api _api;
  TeamServices _teamServices;

  SetupTeamViewModel({@required Api api, @required TeamServices teamServices})
      : _api = api,
        _teamServices = teamServices;

  bool isActive = true;

  initActive(int isSearching) {
    this.isActive = isSearching == 1 ? true : false;
    notifyListeners();
  }

  Future<BaseResponse> activeMatching(int groupId) async {
    setBusy(true);
    this.isActive = true;
    var resp = await _api.activeMatching(groupId);
    if (resp.isSuccess) {
      _teamServices.updateActiveSearching(1);
    } else {
      this.isActive = false;
    }
    setBusy(false);
    return resp;
  }

  Future<BaseResponse> inActiveMatching(int groupId) async {
    setBusy(true);
    this.isActive = false;
    var resp = await _api.inActiveMatching(groupId);
    if (resp.isSuccess) {
      _teamServices.updateActiveSearching(0);
    } else {
      this.isActive = false;
    }
    setBusy(false);
    return resp;
  }
}
