import 'package:flutter/material.dart';
import 'package:myfootball/model/member.dart';
import 'package:myfootball/model/team.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/service/team_services.dart';
import 'package:myfootball/view/ui_helper.dart';
import 'package:myfootball/viewmodel/base_viewmodel.dart';

class MemberViewModel extends BaseViewModel {
  Api _api;
  Team team;
  TeamServices _teamServices;

  MemberViewModel(
      {@required Api api,
      @required this.team,
      @required TeamServices teamServices})
      : _api = api,
        _teamServices = teamServices;


}
