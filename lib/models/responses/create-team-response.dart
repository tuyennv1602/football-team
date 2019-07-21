import 'package:myfootball/models/team.dart';
import 'package:myfootball/models/responses/base-response.dart';

class CreateTeamResponse extends BaseResponse {
  Team team;
  
  CreateTeamResponse.success(Map<String, dynamic> json) : super.success(json) {
    team = json['object'] != null ? Team.fromJson(json['object']) : null;
  }

  CreateTeamResponse.error(String message) : super.error(message);
}
