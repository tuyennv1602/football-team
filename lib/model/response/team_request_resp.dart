import '../team_request.dart';
import 'base_response.dart';

class TeamRequestResponse extends BaseResponse {
  List<TeamRequest> teamRequests;

  TeamRequestResponse.success(Map<String, dynamic> json) : super.success(json) {
    if (json['object'] != null) {
      teamRequests = new List<TeamRequest>();
      json['object'].forEach((v) {
        var userRequest = new TeamRequest.fromJson(v);
        teamRequests.add(userRequest);
      });
    }
  }

  TeamRequestResponse.error(String message) : super.error(message);
}
