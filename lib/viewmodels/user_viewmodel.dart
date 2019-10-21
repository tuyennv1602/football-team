import 'package:flutter/cupertino.dart';
import 'package:myfootball/services/share_preferences.dart';
import 'package:myfootball/services/team_services.dart';
import 'package:myfootball/viewmodels/base_viewmodel.dart';

class UserViewModel extends BaseViewModel {
  SharePreferences _preferences;
  TeamServices _teamServices;

  UserViewModel(
      {@required SharePreferences sharePreferences,
      @required TeamServices teamServices})
      : _preferences = sharePreferences,
        _teamServices = teamServices;

  Future<bool> logout() async {
    setBusy(true);
    var _token = await _preferences.clearToken();
    var _lastTeam = await _preferences.clearLastTeam();
    var resp = _token && _lastTeam;
    if (resp) {
      _teamServices.setTeam(null);
    }
    setBusy(false);
    return resp;
  }
}
