import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myfootball/models/ground.dart';
import 'package:myfootball/models/responses/list_ground_resp.dart';
import 'package:myfootball/services/api.dart';
import 'package:myfootball/services/location_services.dart';
import 'package:myfootball/viewmodels/base_viewmodel.dart';

class SearchGroundViewModel extends BaseViewModel {
  Api _api;
  LatLng myPosition = LatLng(21.026099, 105.833273);
  List<Ground> grounds = [];
  Ground currentGround;

  SearchGroundViewModel({@required Api api}) : _api = api;

  Future<Position> getMyLocation() async {
    setBusy(true);
    var position = await LocationServices().getCurrentLocation();
    this.myPosition = LatLng(position.latitude, position.longitude);
    setBusy(false);
    return position;
  }

  Future<ListGroundResponse> getGroundsByLocation() async {
    setBusy(true);
    var resp = await _api.getGroundByLocation(
        myPosition.latitude, myPosition.longitude);
    if (resp.isSuccess) {
      this.grounds = resp.grounds;
      this.currentGround = this.grounds[0];
    }
    setBusy(false);
    return resp;
  }

  LatLngBounds getBounds() {
    if(grounds.length == 0) return null;
    var lngs = grounds.map<double>((g) => g.lat).toList();
    var lats = grounds.map<double>((g) => g.lng).toList();

    double topMost = lngs.reduce(max);
    double leftMost = lats.reduce(min);
    double rightMost = lats.reduce(max);
    double bottomMost = lngs.reduce(min);

    LatLngBounds bounds = LatLngBounds(
      northeast: LatLng(rightMost, topMost),
      southwest: LatLng(leftMost, bottomMost),
    );

    return bounds;
  }

  changeCurrentGround(Ground ground) {
    this.currentGround = ground;
    notifyListeners();
  }
}
