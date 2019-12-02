import 'package:flutter/material.dart';
import 'package:myfootball/services/api.dart';
import 'package:myfootball/services/firebase_services.dart';
import 'package:myfootball/services/local_storage.dart';
import 'package:myfootball/services/navigation_services.dart';
import 'package:myfootball/services/team_services.dart';
import 'package:myfootball/utils/router_paths.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodels/base_viewmodel.dart';

class UserViewModel extends BaseViewModel {
  LocalStorage _preferences;
  TeamServices _teamServices;
  Api _api;

  UserViewModel(
      {@required LocalStorage sharePreferences,
      @required TeamServices teamServices,
      @required Api api})
      : _preferences = sharePreferences,
        _teamServices = teamServices,
        _api = api;

  Future<void> logout() async {
    UIHelper.showProgressDialog;
    await FirebaseServices.instance.signOut();
    var _logout = await _api.logout();
    var _token = await _preferences.clearToken();
    var _lastTeam = await _preferences.clearLastTeam();
    UIHelper.hideProgressDialog;
    var resp = _token && _lastTeam && _logout.isSuccess;
    if (resp) {
      _teamServices.setTeam(null);
      NavigationService.instance.navigateAndRemove(LOGIN);
    }
  }
}
