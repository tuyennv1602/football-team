import 'package:myfootball/models/invite_matching_request.dart';
import 'package:myfootball/models/responses/base_response.dart';

class InviteMatchingResponse extends BaseResponse {
  List<InviteMatchingRequest> requests;

  InviteMatchingResponse.success(Map<String, dynamic> json)
      : super.success(json) {
    if (json['object'] != null) {
      requests = new List<InviteMatchingRequest>();
      json['object'].forEach((v) {
        requests.add(new InviteMatchingRequest.fromJson(v));
      });
    }
  }

  InviteMatchingResponse.error(String message) : super.error(message);
}
