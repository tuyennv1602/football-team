import 'package:myfootball/models/responses/base_response.dart';
import '../invite_request.dart';

class InviteRequestResponse extends BaseResponse {
  List<InviteRequest> requests;

  InviteRequestResponse.success(int currentTeamId, Map<String, dynamic> json)
      : super.success(json) {
    if (json['object'] != null) {
      requests = new List<InviteRequest>();
      json['object'].forEach((v) {
        var request = InviteRequest.fromJson(v);
        request.currentTeamId = currentTeamId;
        requests.add(request);
      });
    }
  }

  InviteRequestResponse.error(String message) : super.error(message);
}
