import '../team.dart';
import 'base_response.dart';

class TeamResponse extends BaseResponse {
  Team team;

  TeamResponse.success(Map<String, dynamic> json) : super.success(json) {
    if (json['object'] != null) {
      team = Team.fromJson(json['object']);
    }
  }

  TeamResponse.error(String message) : super.error(message);
}
