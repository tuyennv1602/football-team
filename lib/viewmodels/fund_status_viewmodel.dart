import 'package:flutter/material.dart';
import 'package:myfootball/services/api.dart';
import 'package:myfootball/viewmodels/base_viewmodel.dart';

class FundStatusViewModel extends BaseViewModel {
  Api _api;

  FundStatusViewModel({@required Api api}) : _api = api;


}
