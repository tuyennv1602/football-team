import 'package:myfootball/models/team.dart';
import 'package:myfootball/models/responses/base-response.dart';

class CreateTeamResponse extends BaseResponse {
  Team group;

  CreateTeamResponse.success(Map<String, dynamic> json) : super.success(json) {
    group = json['object'] != null ? Team.fromJson(json['object']) : null;
  }

  CreateTeamResponse.error(String message) : super.error(message);
}
