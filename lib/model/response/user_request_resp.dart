import '../user_request.dart';
import 'base_response.dart';

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
