import 'package:flutter/material.dart';
import 'package:myfootball/services/api.dart';
import 'package:myfootball/viewmodels/base_viewmodel.dart';

class MatchingInfoViewModel extends BaseViewModel {
  Api _api;

  MatchingInfoViewModel({@required Api api}) : _api = api;
}