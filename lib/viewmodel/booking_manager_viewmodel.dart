import 'package:flutter/material.dart';
import 'package:myfootball/model/ground.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/viewmodel/base_viewmodel.dart';

class BookingManagerViewModel extends BaseViewModel {
  Api _api;
  List<Ground> grounds = [];

  BookingManagerViewModel({@required Api api}) : _api = api;

  Future<void> getSuggestGrounds() async {
    setBusy(true);
    var resp = await _api.getGroundByLocation(20.986499, 105.82567399999999);
    if(resp.isSuccess){
      this.grounds = resp.grounds;
    }
    setBusy(false);
  }
}
