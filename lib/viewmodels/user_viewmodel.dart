import 'package:flutter/cupertino.dart';
import 'package:myfootball/services/local_storage.dart';
import 'package:myfootball/services/navigation_services.dart';
import 'package:myfootball/services/team_services.dart';
import 'package:myfootball/utils/router_paths.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodels/base_viewmodel.dart';

class UserViewModel extends BaseViewModel {
  LocalStorage _preferences;
  TeamServices _teamServices;

  UserViewModel(
      {@required LocalStorage sharePreferences,
      @required TeamServices teamServices})
      : _preferences = sharePreferences,
        _teamServices = teamServices;

  Future<void> logout() async {
    UIHelper.showProgressDialog;
    var _token = await _preferences.clearToken();
    var _lastTeam = await _preferences.clearLastTeam();
    UIHelper.hideProgressDialog;
    var resp = _token && _lastTeam;
    if (resp) {
      _teamServices.setTeam(null);
      NavigationService.instance().navigateAndRemove(LOGIN);
    }
  }
}
