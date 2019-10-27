import 'package:flutter/cupertino.dart';
import 'package:myfootball/services/api.dart';
import 'package:myfootball/viewmodels/base_viewmodel.dart';

class TeamFundViewModel extends BaseViewModel {
  Api _api;

  TeamFundViewModel({@required Api api}) : _api = api;


}