import '../team.dart';
import 'base_response.dart';

class SearchTeamResponse extends BaseResponse {
  List<Team> teams;

  SearchTeamResponse.success(Map<String, dynamic> json) : super.success(json) {
    if (json['object'] != null) {
      teams = new List<Team>();
      json['object'].forEach((v) {
        var team = new Team.fromJson(v);
        teams.add(team);
      });
    }
  }

  SearchTeamResponse.error(String message) : super.error(message);
}
