import 'package:myfootball/data/providers/team-provider.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/models/responses/create-team-response.dart';

class TeamReposiroty {
  TeamProvider _groupProvider = TeamProvider();

  Future<CreateTeamResponse> createGroup(Team group) async {
    return _groupProvider.createGroup(group);
  }
}
