import 'package:myfootball/models/responses/base_response.dart';
import 'package:myfootball/models/user_request.dart';

class UserRequestResponse extends BaseResponse {
  List<UserRequest> userRequests;

  UserRequestResponse.success(Map<String, dynamic> json) : super.success(json) {
    if (json['object'] != null) {
      userRequests = new List<UserRequest>();
      json['object'].forEach((v) {
        var userRequest = new UserRequest.fromJson(v);
        userRequests.add(userRequest);
      });
    }
  }

  UserRequestResponse.error(String message) : super.error(message);
}
