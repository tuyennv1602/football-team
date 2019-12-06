import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfootball/model/response/team_resp.dart';
import 'package:myfootball/model/team.dart';
import 'package:myfootball/model/user.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/service/auth_services.dart';
import 'package:myfootball/service/firebase_services.dart';
import 'package:myfootball/service/local_storage.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodel/base_viewmodel.dart';

class CreateTeamViewModel extends BaseViewModel {
  Api _api;
  File image;
  Color dressColor = Color(0xFFF6D2D1);
  LocalStorage _sharePreferences;
  AuthServices _authServices;

  CreateTeamViewModel(
      {@required Api api,
      @required AuthServices authServices,
      LocalStorage sharePreferences})
      : _api = api,
        _authServices = authServices,
        _sharePreferences = sharePreferences;

  void setImage(File image) {
    this.image = image;
    notifyListeners();
  }

  Future<TeamResponse> createTeam(User user, String name, String bio) async {
    UIHelper.showProgressDialog;
    var resp = await _api.createTeam(
      Team(
        managerId: user.id,
        name: name,
        bio: bio,
        dress: getColorValue(
          dressColor.toString(),
        ),
      ),
    );
    if (resp.isSuccess) {
      var _team = resp.team;
      if (image != null) {
        var _imageLink = await _uploadImage(_team.id, name);
        if (_imageLink != null) {
          // upload image success and update team info
          _team.logo = _imageLink;
          await _api.updateTeam(_team);
        }
        UIHelper.hideProgressDialog;
      } else {
        UIHelper.hideProgressDialog;
      }
      _sharePreferences.setLastTeam(_team);
      user.addTeam(_team);
      _authServices.updateUser(user);
      UIHelper.showSimpleDialog('Đăng ký đội bóng thành công', isSuccess: true);
    } else {
      UIHelper.hideProgressDialog;
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
    return resp;
  }

  Future<String> _uploadImage(int teamId, String teamName) async {
    if (image == null) return null;
    var name = 'id_$teamId';
    return FirebaseServices.instance.uploadImage(image, 'team', name);
  }

  void setDressColor(Color color) {
    this.dressColor = color;
    notifyListeners();
  }
}
