import 'package:flutter/material.dart';
import 'package:myfootball/models/match_schedule.dart';
import 'package:myfootball/models/responses/base_response.dart';
import 'package:myfootball/models/responses/match_schedule_resp.dart';
import 'package:myfootball/services/api.dart';
import 'package:myfootball/viewmodels/base_viewmodel.dart';

class MatchScheduleViewModel extends BaseViewModel {
  Api _api;
  List<MatchSchedule> matchSchedules;

  MatchScheduleViewModel({@required Api api}) : _api = api;

  Future<MatchScheduleResponse> getMatchSchedules(int teamId) async {
    setBusy(true);
    var resp = await _api.getMatchSchedules(teamId);
    if (resp.isSuccess) {
      this.matchSchedules = resp.matchSchedules;
    }
    setBusy(false);
    return resp;
  }

}
