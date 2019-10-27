import 'package:flutter/cupertino.dart';
import 'package:myfootball/models/matching.dart';
import 'package:myfootball/models/responses/matching_resp.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/services/api.dart';
import 'package:myfootball/services/team_services.dart';
import 'package:myfootball/viewmodels/base_viewmodel.dart';

class FindMatchingViewModel extends BaseViewModel {
  Api _api;
  TeamServices _teamServices;
  List<Matching> matchings;
  Matching currentTeam;

  FindMatchingViewModel(
      {@required Api api, @required TeamServices teamServices})
      : _api = api,
        _teamServices = teamServices;

  Future<MatchingResponse> findMatching(Team team) async {
    setBusy(true);
    var resp = await _api.findMatching(team.id, team.groupMatchingInfo[0], 1);
    if (resp.isSuccess) {
      matchings = resp.matchings;
      if (matchings.length > 0) {
        changeCurrentTeam(matchings[0]);
      }
    }
    setBusy(false);
    return resp;
  }

  changeCurrentTeam(Matching matching) {
    this.currentTeam = matching;
    notifyListeners();
  }
}
