import 'package:myfootball/models/team.dart';
import 'package:myfootball/models/responses/base-response.dart';

class TeamResponse extends BaseResponse {
  Team team;

  TeamResponse.success(Map<String, dynamic> json) : super.success(json) {
    if (json['object'] != null) {
      team = Team.fromJson(json['object'][0]);
    }
  }

  TeamResponse.error(String message) : super.error(message);
}
