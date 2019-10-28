import 'package:myfootball/models/responses/base_response.dart';
import '../invite_request.dart';

class InviteRequestResponse extends BaseResponse {
  List<InviteRequest> requests;

  InviteRequestResponse.success(Map<String, dynamic> json)
      : super.success(json) {
    if (json['object'] != null) {
      requests = new List<InviteRequest>();
      json['object'].forEach((v) {
        requests.add(new InviteRequest.fromJson(v));
      });
    }
  }

  InviteRequestResponse.error(String message) : super.error(message);
}