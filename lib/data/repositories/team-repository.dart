import 'package:myfootball/data/providers/team-provider.dart';
import 'package:myfootball/models/responses/search-team-response.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/models/responses/create-team-response.dart';

class TeamReposiroty {
  TeamProvider _groupProvider = TeamProvider();

  Future<CreateTeamResponse> createTeam(Team team) async {
    return _groupProvider.createTeam(team);
  }

  Future<SearchTeamResponse> searchTeamByKey(String key) async {
    return _groupProvider.searchTeamByKey(key);
  }
}
