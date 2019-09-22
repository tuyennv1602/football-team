import 'package:dio/dio.dart';
import 'package:myfootball/data/app-api.dart';
import 'package:myfootball/models/device-info.dart';
import 'package:myfootball/models/responses/base-response.dart';
import 'package:myfootball/models/responses/login-response.dart';
import 'package:myfootball/models/responses/user-request-response.dart';

class UserProvider {
  Future<LoginResponse> loginWithEmail(String email, String password) async {
    try {
      // for param
      FormData formData = new FormData.from({
        'email': email,
        'password': password,
      });
      var response =
          await AppApi.getAuthApi('user/login', queryParams: formData);
      return LoginResponse.success(response.data);
    } on DioError catch (e) {
      return LoginResponse.error(e.message);
    }
  }

  Future<BaseResponse> forgotPassword(String email) async {
    try {
      var response = await AppApi.postAuthApi('user/forgot-password',
          body: {"email": email});
      return BaseResponse.success(response.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }

  Future<BaseResponse> register(String name, String email, String password,
      String phoneNumber, List<int> roles) async {
    try {
      // for body
      var response = await AppApi.postAuthApi('user/register', body: {
        "name": name,
        "email": email,
        "password": password,
        "phone": phoneNumber,
        "roles": roles
      });
      return BaseResponse.success(response.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }

  Future<BaseResponse> changePassword(
      String email, String password, String code) async {
    try {
      var response = await AppApi.postAuthApi('user/change-password',
          body: {"email": email, "password": password, "code": code});
      return BaseResponse.success(response.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }

  Future<BaseResponse> createRequestMember(
      int userId, int teamId, String content) async {
    try {
      var response = await AppApi.postApi('request-member/create',
          body: {"user_id": userId, "group_id": teamId, "content": content});
      return BaseResponse.success(response.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }

  Future<BaseResponse> cancelRequestMember(int requestId) async {
    try {
      var response = await AppApi.postApi('request-member/cancel',
          body: {"id": requestId});
      return BaseResponse.success(response.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }

  Future<LoginResponse> refreshToken(String refreshToken) async {
    try {
      var resp =
          await AppApi.getAuthApi('user/login/refresh-token/$refreshToken');
      return LoginResponse.success(resp.data);
    } on DioError catch (e) {
      return LoginResponse.error(e.message);
    }
  }

  Future<BaseResponse> registerDevice(DeviceInfo deviceInfo) async {
    try {
      var resp = await AppApi.postApi('device-info', body: deviceInfo.toJson());
      return BaseResponse.success(resp.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }

  Future<UserRequestResponse> getUserRequests() async {
    try {
      var resp = await AppApi.getApi('request-member/find-by-user-id');
      return UserRequestResponse.success(resp.data);
    } on DioError catch (e) {
      return UserRequestResponse.error(e.message);
    }
  }
}
