import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:myfootball/model/response/base_response.dart';
import 'package:myfootball/model/team.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/service/firebase_services.dart';
import 'package:myfootball/service/team_services.dart';
import 'package:myfootball/viewmodel/base_viewmodel.dart';

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

  Future<BaseResponse> updateTeam(Team team) async {
    if (image != null) {
      var _imageLink = await FirebaseServices.instance
          .uploadImage(image, 'team', 'id_${team.id}');
      if (_imageLink != null) {
        team.logo = _imageLink;
      }
    }
    team.dress = getColorValue(dressColor.toString());
    var resp = await _api.updateTeam(team);
    if (resp.isSuccess) {
      _teamServices.setTeam(team);
    }
    return resp;
  }
}
