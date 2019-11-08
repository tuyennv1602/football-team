import 'package:flutter/material.dart';
import 'package:myfootball/services/api.dart';
import 'package:myfootball/viewmodels/base_viewmodel.dart';

class MatchScheduleViewModel extends BaseViewModel {
  Api _api;

  MatchScheduleViewModel({@required Api api}) : _api = api;
}
