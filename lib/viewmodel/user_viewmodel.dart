import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myfootball/model/response/base_response.dart';
import 'package:myfootball/model/user.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/service/auth_services.dart';
import 'package:myfootball/service/firebase_services.dart';
import 'package:myfootball/service/local_storage.dart';
import 'package:myfootball/service/team_services.dart';
import 'package:myfootball/viewmodel/base_viewmodel.dart';

class UserViewModel extends BaseViewModel {
  LocalStorage _preferences;
  TeamServices _teamServices;
  AuthServices _authServices;
  Api _api;

  UserViewModel(
      {@required LocalStorage sharePreferences,
      @required TeamServices teamServices,
      @required Api api,
      @required AuthServices authServices})
      : _preferences = sharePreferences,
        _api = api,
        _teamServices = teamServices,
        _authServices = authServices;

  Future<bool> logout() async {
    var _logout = await _api.logout();
    var _token = await _preferences.clearToken();
    var _lastTeam = await _preferences.clearLastTeam();
    var resp = _token && _lastTeam && _logout.isSuccess;
    if (resp) {
      _teamServices.setTeam(null);
    }
    return resp;
  }

  Future<BaseResponse> updateAvatar(User user, File image) async {
    var link = await FirebaseServices.instance
        .uploadImage(image, 'user', 'id_${user.id}');
    if (link != null) {
      var resp = await _api.updateProfile(link, user.name);
      if (resp.isSuccess) {
        user.avatar = link;
        _authServices.updateUser(user);
        _teamServices.getTeamDetail(null);
        notifyListeners();
      }
      return resp;
    } else {
      return BaseResponse(
          success: false, errorMessage: 'Có lỗi xảy tra, vui lòng thử lại');
    }
  }

  Future<BaseResponse> updateName(User user, String name) async {
    var resp = await _api.updateProfile(user.avatar, name);
    if (resp.isSuccess) {
      user.name = name;
      _authServices.updateUser(user);
      _teamServices.getTeamDetail(null);
      notifyListeners();
    }
    return resp;
  }

  Future<BaseResponse> forgotPassword(String email) async {
    var resp = await _api.forgotPassword(email);
    return resp;
  }
}
