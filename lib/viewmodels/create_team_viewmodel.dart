import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfootball/models/responses/team_resp.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/models/user.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/services/api.dart';
import 'package:myfootball/services/auth_services.dart';
import 'package:myfootball/services/firebase_services.dart';
import 'package:myfootball/services/local_storage.dart';
import 'package:myfootball/viewmodels/base_viewmodel.dart';

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
    int userId = user.id;
    setBusy(true);
    var resp = await _api.createTeam(
        userId,
        Team(
            manager: userId,
            name: name,
            bio: bio,
            dress: getColorValue(dressColor.toString())));
    if (resp.isSuccess) {
      var _team = resp.team;
      if (image != null) {
        var _imageLink = await _uploadImage(userId, name);
        if (_imageLink != null) {
          // upload image success and update team info
          _team.logo = _imageLink;
          await _api.updateTeam(_team);
        }
      }
      _sharePreferences.setLastTeam(_team);
      user.addTeam(_team);
      _authServices.updateUser(user);
    }
    setBusy(false);
    return resp;
  }

  Future<String> _uploadImage(int managerId, String teamName) async {
    if (image == null) return null;
    var name = '$managerId-${teamName.trim().replaceAll(" ", "-")}';
    return FirebaseServices().uploadImage(image, 'team', name);
  }

  void setDressColor(Color color) {
    this.dressColor = color;
    notifyListeners();
  }
}
