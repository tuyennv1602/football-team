import 'dart:async';

import 'package:myfootball/models/device_info.dart';
import 'package:myfootball/models/headers.dart';
import 'package:myfootball/models/responses/base_response.dart';
import 'package:myfootball/models/responses/login_resp.dart';
import 'package:myfootball/models/token.dart';
import 'package:myfootball/models/user.dart';
import 'package:myfootball/services/base_api.dart';
import 'package:myfootball/services/local_storage.dart';

import 'api.dart';

class AuthServices {
  final Api _api;
  final LocalStorage _preferences;

  AuthServices({Api api, LocalStorage sharePreferences})
      : _api = api,
        _preferences = sharePreferences;

  StreamController<User> _userController = StreamController<User>();

  Stream<User> get user => _userController.stream;

  updateUser(User user) {
    _userController.add(user);
  }

  Future<LoginResponse> loginEmail(
      String deviceId, String email, String password) async {
    var resp = await _api.loginEmail(email, password);
    if (resp.isSuccess) {
      updateUser(resp.user);
      _preferences.setToken(Token(
          deviceId: deviceId,
          token: resp.token,
          refreshToken: resp.refreshToken));
      BaseApi.setHeader(Headers(accessToken: resp.token, deviceId: deviceId));
    }
    return resp;
  }

  Future<BaseResponse> registerDevice(DeviceInfo deviceInfo) async {
    return await _api.registerDevice(deviceInfo);
  }

  Future<LoginResponse> refreshToken() async {
    var token = await _preferences.getToken();
    BaseApi.setHeader(Headers(deviceId: token.deviceId));
    if (token != null) {
      var resp = await _api.refreshToken(token.refreshToken);
      if (resp.isSuccess) {
        updateUser(resp.user);
        _preferences.setToken(Token(
            deviceId: token.deviceId,
            token: resp.token,
            refreshToken: resp.refreshToken));
        BaseApi.setHeader(
            Headers(deviceId: token.deviceId, accessToken: resp.token));
      } else {
        _preferences.clearLastTeam();
        _preferences.clearToken();
      }
      return resp;
    }
    return LoginResponse.error('Phiên đăng nhập đã hết hạn');
  }
}
