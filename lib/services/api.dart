import 'package:dio/dio.dart';
import 'package:myfootball/models/device-info.dart';
import 'package:myfootball/models/responses/base-response.dart';
import 'package:myfootball/models/responses/login-response.dart';
import 'package:myfootball/models/responses/search-team-response.dart';
import 'package:myfootball/models/responses/team-response.dart';
import 'package:myfootball/models/responses/user-request-response.dart';
import 'package:myfootball/models/team.dart';

import 'base-api.dart';

class Api {
  final _api = BaseApi();

  Future<LoginResponse> loginEmail(String email, String password) async {
    try {
      var response = await _api.getAuthApi('user/login',
          queryParams: FormData.from({
            'email': email,
            'password': password,
          }));
      return LoginResponse.success(response.data);
    } on DioError catch (e) {
      return LoginResponse.error(e.message);
    }
  }

  Future<BaseResponse> registerDevice(DeviceInfo deviceInfo) async {
    try {
      var resp = await _api.postApi('device-info', body: deviceInfo.toJson());
      return BaseResponse.success(resp.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }

  Future<BaseResponse> register(String name, String email, String password,
      String phoneNumber, List<int> roles) async {
    try {
      // for body
      var response = await _api.postAuthApi('user/register', body: {
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

  Future<BaseResponse> forgotPassword(String email) async {
    try {
      var response = await _api
          .postAuthApi('user/forgot-password', body: {"email": email});
      return BaseResponse.success(response.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }

  Future<BaseResponse> changePassword(
      String email, String password, String code) async {
    try {
      var response = await _api.postAuthApi('user/change-password',
          body: {"email": email, "password": password, "code": code});
      return BaseResponse.success(response.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }

  Future<LoginResponse> refreshToken(String refreshToken) async {
    try {
      var resp =
          await _api.getAuthApi('user/login/refresh-token/$refreshToken');
      return LoginResponse.success(resp.data);
    } on DioError catch (e) {
      return LoginResponse.error(e.message);
    }
  }

  Future<UserRequestResponse> getUserRequest() async {
    try {
      var resp = await _api.getApi('request-member/find-by-user-id');
      return UserRequestResponse.success(resp.data);
    } on DioError catch (e) {
      return UserRequestResponse.error(e.message);
    }
  }

  Future<BaseResponse> createRequestMember(
      int userId, int teamId, String content) async {
    try {
      var response = await _api.postApi('request-member/create',
          body: {"user_id": userId, "group_id": teamId, "content": content});
      return BaseResponse.success(response.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }

  Future<BaseResponse> cancelRequestMember(int requestId) async {
    try {
      var response =
          await _api.postApi('request-member/cancel', body: {"id": requestId});
      return BaseResponse.success(response.data);
    } on DioError catch (e) {
      return BaseResponse.error(e.message);
    }
  }

  Future<TeamResponse> createTeam(Team team) async {
    try {
      var response = await _api.postApi('group/create', body: {
        "manager": team.userId,
        "name": team.name,
        "dress": team.dress,
        "bio": team.bio,
        "logo": team.logo
      });
      return TeamResponse.success(response.data);
    } on DioError catch (e) {
      return TeamResponse.error(e.message);
    }
  }

  Future<SearchTeamResponse> searchTeamByKey(String key) async {
    try {
      FormData formData = new FormData.from({
        "text_search": key,
      });
      var resp = await _api.getApi("group/search", queryParams: formData);
      return SearchTeamResponse.success(resp.data);
    } on DioError catch (e) {
      return SearchTeamResponse.error(e.message);
    }
  }

  Future<TeamResponse> getTeamDetail(int id) async {
    try {
      var resp = await _api.getApi("group/$id");
      return TeamResponse.success(resp.data);
    } on DioError catch (e) {
      return TeamResponse.error(e.message);
    }
  }
}
