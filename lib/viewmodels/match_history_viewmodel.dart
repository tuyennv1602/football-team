import 'package:flutter/material.dart';
import 'package:myfootball/services/api.dart';
import 'package:myfootball/viewmodels/base_viewmodel.dart';

class MatchHistoryViewModel extends BaseViewModel {
  Api _api;

  MatchHistoryViewModel({@required Api api}) : _api = api;
}