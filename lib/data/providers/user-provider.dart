import 'package:dio/dio.dart';
import 'package:myfootball/data/app-api.dart';
import 'package:myfootball/models/responses/base-response.dart';
import 'package:myfootball/models/responses/login-response.dart';

class UserApiProvider {
  static final UserApiProvider _instance = UserApiProvider.internal();
  factory UserApiProvider() => _instance;
  UserApiProvider.internal();

  Future<LoginResponse> loginWithEmail(String email, String password) async {
    try {
      FormData formData = new FormData.from({
        'email': email,
        'password': password,
      });
      var response = await AppApi.getApi('user/login', queryParams: formData);
      return LoginResponse.success(response.data);
    } on DioError catch (e) {
      return LoginResponse.error(e.message);
    }
  }

  Future<BaseResponse> forgotPassword(String email) async {
    try {
      var response =
          await AppApi.postApi('user/forgot-password', body: {"email": email});
      return BaseResponse.success(response.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }

  Future<BaseResponse> register(String userName, String email, String password,
      String phoneNumber, List<int> roles) async {
    try {
      var response = await AppApi.postApi('user/register', body: {
        "userName": userName,
        "email": email,
        "password": password,
        "phone": phoneNumber,
        "roleList": roles
      });
      return BaseResponse.success(response.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }

  Future<BaseResponse> changePassword(
      String email, String password, String code) async {
    try {
      var response = await AppApi.postApi('user/change-password',
          body: {"email": email, "password": password, "code": code});
      return BaseResponse.success(response.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }
}
