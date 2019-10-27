import 'package:flutter/material.dart';
import 'package:myfootball/models/ground.dart';
import 'package:myfootball/models/responses/ground_resp.dart';
import 'package:myfootball/services/api.dart';
import 'package:myfootball/viewmodels/base_viewmodel.dart';

class GroundDetailViewModel extends BaseViewModel {
  Api _api;
  Ground ground;

  GroundDetailViewModel({@required Api api}) : _api = api;

  Future<GroundResponse> getGroundDetail(int groundId) async {
    setBusy(true);
    var resp = await _api.getGroundDetail(groundId);
    if (resp.isSuccess) {
      this.ground = resp.ground;
    }
    setBusy(false);
    return resp;
  }
}
