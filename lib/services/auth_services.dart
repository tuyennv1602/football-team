import 'dart:async';

import 'package:myfootball/models/device_info.dart';
import 'package:myfootball/models/headers.dart';
import 'package:myfootball/models/responses/base-response.dart';
import 'package:myfootball/models/responses/login_resp.dart';
import 'package:myfootball/models/token.dart';
import 'package:myfootball/models/user.dart';
import 'package:myfootball/services/base-api.dart';
import 'package:myfootball/services/share_preferences.dart';

import 'api.dart';

class AuthServices {
  final Api _api;
  final SharePreferences _preferences;

  AuthServices({Api api, SharePreferences sharePreferences})
      : _api = api,
        _preferences = sharePreferences;

  StreamController<User> _userController = StreamController<User>();

  Stream<User> get user => _userController.stream;

  updateUser(User user) {
    _userController.add(user);
  }

  Future<LoginResponse> loginEmail(String email, String password) async {
    var resp = await _api.loginEmail(email, password);
    if (resp.isSuccess) {
      updateUser(resp.user);
      _preferences
          .setToken(Token(token: resp.token, refreshToken: resp.refreshToken));
      BaseApi.setHeader(Headers(accessToken: resp.token));
    }
    return resp;
  }

  Future<BaseResponse> registerDevice(DeviceInfo deviceInfo) async {
    return await _api.registerDevice(deviceInfo);
  }

  Future<LoginResponse> refreshToken() async {
    var token = await _preferences.getToken();
    if (token != null) {
      var resp = await _api.refreshToken(token.refreshToken);
      if (resp.isSuccess) {
        updateUser(resp.user);
        _preferences.setToken(
            Token(token: resp.token, refreshToken: resp.refreshToken));
        BaseApi.setHeader(Headers(accessToken: resp.token));
      }
      return resp;
    }
    return LoginResponse.error('Phiên đăng nhập đã hết hạn');
  }
}
