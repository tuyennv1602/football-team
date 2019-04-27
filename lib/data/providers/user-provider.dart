import 'package:dio/dio.dart';
import 'package:myfootball/data/api-config.dart';
import 'package:myfootball/http.dart';
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
      var response = await dio.get('${ApiConfig.HOST}/user/login',
          queryParameters: formData);
      return LoginResponse.success(response.data);
    } on DioError catch (e) {
      return LoginResponse.error(e.message);
    }
  }

  Future<BaseResponse> forgotPassword(String email) async {
    try {
      var response = await dio.post('${ApiConfig.HOST}/user/forgot-password',
          data: {"email": email});
      return BaseResponse.success(response.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }

  Future<BaseResponse> register(String userName, String email, String password,
      String phoneNumber) async {
    try {
      var response = await dio.post('${ApiConfig.HOST}/user/register', data: {
        "userName": userName,
        "email": email,
        "password": password,
        "phoneNumber": phoneNumber
      });
      return BaseResponse.success(response.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }
}
