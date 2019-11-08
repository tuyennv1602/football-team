import 'package:flutter/material.dart';
import 'package:myfootball/services/api.dart';
import 'package:myfootball/viewmodels/base_viewmodel.dart';

class UpdateScheduleViewModel extends BaseViewModel {
  Api _api;

  UpdateScheduleViewModel({@required Api api}) : _api = api;
}
