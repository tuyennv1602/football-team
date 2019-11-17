import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:myfootball/models/responses/base_response.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/services/api.dart';
import 'package:myfootball/services/firebase_services.dart';
import 'package:myfootball/services/navigation_services.dart';
import 'package:myfootball/services/team_services.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodels/base_viewmodel.dart';

class UpdateTeamViewModel extends BaseViewModel {
  Api _api;
  TeamServices _teamServices;
  Color dressColor = Color(0xFFF6D2D1);
  File image;

  UpdateTeamViewModel({@required Api api, @required TeamServices teamServices})
      : _api = api,
        _teamServices = teamServices;

  void setImage(File image) {
    this.image = image;
    notifyListeners();
  }

  void setDressColor(Color color) {
    this.dressColor = color;
    notifyListeners();
  }

  Future<void> updateTeam(Team team) async {
    UIHelper.showProgressDialog;
    if (image != null) {
      var _imageLink = await _uploadImage(team.manager, team.name);
      if (_imageLink != null) {
        // upload image success and update team info
        team.logo = _imageLink;
      }else{
        UIHelper.hideProgressDialog;
      }
    }
    team.dress = getColorValue(dressColor.toString());
    var resp = await _api.updateTeam(team);
    UIHelper.hideProgressDialog;
    if (resp.isSuccess) {
      _teamServices.setTeam(team);
      NavigationService.instance().goBack();
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }

  Future<String> _uploadImage(int managerId, String teamName) async {
    if (image == null) return null;
    var name = '$managerId-${teamName.trim().replaceAll(" ", "-")}';
    return FirebaseServices().uploadImage(image, 'team', name);
  }
}
