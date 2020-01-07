import 'package:flutter/material.dart';
import 'package:myfootball/model/team.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/viewmodel/base_viewmodel.dart';

class RankingViewModel extends BaseViewModel {
  Api _api;
  List<Team> teams = [];

  RankingViewModel({@required Api api}) : _api = api;

  Future<void> getRanking(bool isRefresh) async {
    setBusy(!isRefresh);
    var resp = await _api.getRanking();
    if (resp.isSuccess) {
      this.teams = resp.teams;
    }
    setBusy(false);
  }
}
