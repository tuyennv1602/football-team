import 'package:flutter/material.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/viewmodel/base_viewmodel.dart';

class UpdateScheduleViewModel extends BaseViewModel {
  Api _api;

  UpdateScheduleViewModel({@required Api api}) : _api = api;
}
