import 'package:myfootball/models/responses/base-response.dart';
import 'package:myfootball/models/user.dart';

class LoginResponse extends BaseResponse {

  User user;

  LoginResponse.success(Map<String, dynamic> json) : super.success(json){
    user = json['object'] != null ? User.fromJson(json['object']) : null;
  }

  LoginResponse.error(String message) : super.error(message);

}