import 'package:flutter/cupertino.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/services/api.dart';
import 'package:myfootball/viewmodels/base_viewmodel.dart';

class SocialViewModel extends BaseViewModel {
  Api _api;

  List<Team> teams = [];

  SocialViewModel({@required Api api}) : _api = api;

  Future<void> getRanking() async {
    var resp = await _api.getRanking();
    if (resp.isSuccess) {
      this.teams = resp.teams;
      notifyListeners();
    }
  }
}
