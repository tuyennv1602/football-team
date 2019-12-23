import 'package:flutter/material.dart';
import 'package:myfootball/model/fixed_time.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/viewmodel/base_viewmodel.dart';

class FixedTimeViewModel extends BaseViewModel {
  Api _api;

  List<FixedTime> times = [];

  FixedTimeViewModel({@required Api api}) : _api = api;

  Future<void> getAllRequests(int teamId) async {
    setBusy(true);
    var resp = await _api.getFixedTimes(teamId);
    if (resp.isSuccess) {
      this.times = resp.requests;
    }
    setBusy(false);
  }
}