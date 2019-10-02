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
import 'package:myfootball/services/share_preferences.dart';
import 'package:myfootball/viewmodels/base_view_model.dart';

class CreateTeamViewModel extends BaseViewModel {
  Api _api;
  File image;
  Color dressColor = Colors.red;
  SharePreferences _sharePreferences;
  AuthServices _authServices;

  CreateTeamViewModel(
      {@required Api api,
      @required AuthServices authServices,
      SharePreferences sharePreferences})
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
          print(_imageLink);
          _team.logo = _imageLink;
          var _updateTeamResp = await _api.updateTeam(_team);
          print(_updateTeamResp.statusCode);
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
    var name = '$managerId-$teamName';
    return FirebaseServices().uploadImage(image, 'team', name);
  }

  void setDressColor(Color color) {
    this.dressColor = color;
    notifyListeners();
  }
}
