import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:myfootball/models/responses/team_resp.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/services/api.dart';
import 'package:myfootball/services/share_preferences.dart';

class TeamServices {
  final Api _api;
  final SharePreferences _sharePreferences;

  TeamServices({@required Api api, SharePreferences sharePreferences})
      : _api = api,
        _sharePreferences = sharePreferences;

  StreamController<Team> _teamController = StreamController<Team>();

  Stream<Team> get team => _teamController.stream;

  Future<TeamResponse> getTeamDetail(int teamId) async {
    var resp = await _api.getTeamDetail(teamId);
    if (resp.isSuccess) {
      _teamController.add(resp.team);
    }
    return resp;
  }

  Future<int> checkCurrentTeam(List<Team> teams) async {
    if (teams.length > 0) {
      Team _lastTeam = await _sharePreferences.getLastTeam();
      int _teamId;
      if (_lastTeam == null) {
        // no team saved before
        _teamId = teams[0].id;
      } else {
        _teamId = _lastTeam.id;
      }
      await getTeamDetail(_teamId);
      return _teamId;
    }
    return -1;
  }

  Future<TeamResponse> changeTeam(Team team) async {
    _sharePreferences.setLastTeam(team);
    var resp = await getTeamDetail(team.id);
    return resp;
  }
}