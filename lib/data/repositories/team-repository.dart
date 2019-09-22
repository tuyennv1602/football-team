import 'package:myfootball/data/providers/team-provider.dart';
import 'package:myfootball/models/responses/search-team-response.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/models/responses/team-response.dart';

class TeamReposiroty {
  TeamProvider _teamProvider = TeamProvider();

  Future<TeamResponse> createTeam(Team team) async {
    return _teamProvider.createTeam(team);
  }

  Future<SearchTeamResponse> searchTeamByKey(String key) async {
    return _teamProvider.searchTeamByKey(key);
  }

  Future<TeamResponse> getTeamDetail(int id) async {
    return _teamProvider.getTeamDetail(id);
  }
}
