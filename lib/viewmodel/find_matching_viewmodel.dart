import 'package:flutter/cupertino.dart';
import 'package:myfootball/model/matching.dart';
import 'package:myfootball/model/response/matching_resp.dart';
import 'package:myfootball/model/team.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/viewmodel/base_viewmodel.dart';

class FindMatchingViewModel extends BaseViewModel {
  Api _api;
  List<Matching> matchings;
  Matching currentTeam;

  FindMatchingViewModel({@required Api api}) : _api = api;

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
