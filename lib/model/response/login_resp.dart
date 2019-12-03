import '../user.dart';
import 'base_response.dart';

class LoginResponse extends BaseResponse {
  User user;
  String refreshToken;
  String token;

  LoginResponse.success(Map<String, dynamic> json) : super.success(json) {
    user = json['object'] != null ? User.fromJson(json['object']) : null;
    token = json['token'];
    refreshToken = json['refresh_token'];
  }

  LoginResponse.error(String message) : super.error(message);
}
