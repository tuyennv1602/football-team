import 'package:flutter/material.dart';
import 'package:myfootball/services/api.dart';
import 'package:myfootball/viewmodels/base_viewmodel.dart';

class FinanceViewModel extends BaseViewModel {
  Api _api;

  FinanceViewModel({@required Api api}) : _api = api;
}