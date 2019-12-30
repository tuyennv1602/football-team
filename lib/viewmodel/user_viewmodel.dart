import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myfootball/model/user.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/service/auth_services.dart';
import 'package:myfootball/service/firebase_services.dart';
import 'package:myfootball/service/local_storage.dart';
import 'package:myfootball/router/navigation.dart';
import 'package:myfootball/service/team_services.dart';
import 'package:myfootball/router/paths.dart';
import 'package:myfootball/utils/ui_helper.dart';
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
        _teamServices = teamServices,
        _api = api,
        _authServices = authServices;

  Future<void> logout() async {
    UIHelper.showProgressDialog;
    var _logout = await _api.logout();
    var _token = await _preferences.clearToken();
    var _lastTeam = await _preferences.clearLastTeam();
    await FacebookLogin().logOut();
    var _googleSignIn = GoogleSignIn();
    if ((await _googleSignIn.isSignedIn())) {
      await _googleSignIn.disconnect();
    }
    UIHelper.hideProgressDialog;
    var resp = _token && _lastTeam && _logout.isSuccess;
    if (resp) {
      _teamServices.setTeam(null);
      Navigation.instance.navigateAndRemove(LOGIN);
    }
  }

  Future<void> updateAvatar(User user, File image) async {
    UIHelper.showProgressDialog;
    var link = await FirebaseServices.instance
        .uploadImage(image, 'user', 'id_${user.id}');
    if (link != null) {
      var resp = await _api.updateProfile(link, user.name);
      UIHelper.hideProgressDialog;
      if (resp.isSuccess) {
        user.avatar = link;
        _authServices.updateUser(user);
        _teamServices.getTeamDetail(null);
        notifyListeners();
      } else {
        UIHelper.showSimpleDialog(resp.errorMessage);
      }
    } else {
      UIHelper.hideProgressDialog;
      UIHelper.showSimpleDialog('Có lỗi xảy tra, vui lòng thử lại');
    }
  }

  Future<void> updateName(User user, String name) async {
    UIHelper.showProgressDialog;
    var resp = await _api.updateProfile(user.avatar, name);
    UIHelper.hideProgressDialog;
    if (resp.isSuccess) {
      user.name = name;
      _authServices.updateUser(user);
      _teamServices.getTeamDetail(null);
      notifyListeners();
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }

  Future<void> forgotPassword(String email) async {
    UIHelper.showProgressDialog;
    var resp = await _api.forgotPassword(email);
    UIHelper.hideProgressDialog;
    if (resp.isSuccess) {
      Navigation.instance.navigateTo(CHANGE_PASSWORD, arguments: email);
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }
}
