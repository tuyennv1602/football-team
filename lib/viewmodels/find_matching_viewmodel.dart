import 'package:flutter/cupertino.dart';
import 'package:myfootball/services/api.dart';
import 'package:myfootball/services/team_services.dart';
import 'package:myfootball/viewmodels/base_viewmodel.dart';

class FindMatchingViewModel extends BaseViewModel {
  Api _api;
  TeamServices _teamServices;

  FindMatchingViewModel(
      {@required Api api, @required TeamServices teamServices})
      : _api = api,
        _teamServices = teamServices;
}
