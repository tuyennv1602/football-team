import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myfootball/model/ground.dart';
import 'package:myfootball/model/response/list_ground_resp.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/service/location_services.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodel/base_viewmodel.dart';

class SearchGroundViewModel extends BaseViewModel {
  Api _api;
  LatLng myPosition = LatLng(21.026099, 105.833273);
  List<Ground> grounds = [];
  Ground currentGround;
  List<Ground> searchResults = [];
  String key = '';
  bool isSearching = false;


  SearchGroundViewModel({@required Api api}) : _api = api;

  Future<void> getMyLocation() async {
    var position = await LocationServices().getCurrentLocation();
    if (position != null) {
      this.myPosition = LatLng(position.latitude, position.longitude);
      notifyListeners();
    }
  }

  Future<ListGroundResponse> getGroundsByLocation() async {
    UIHelper.showProgressDialog;
    var resp = await _api.getGroundByLocation(
        myPosition.latitude, myPosition.longitude);
    UIHelper.hideProgressDialog;
    if (resp.isSuccess) {
      this.grounds = resp.grounds;
      if (this.grounds.length > 0) {
        this.currentGround = this.grounds[0];
      }
      notifyListeners();
    }
    return resp;
  }

  LatLngBounds getBounds() {
    if (grounds.length == 0) return null;
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

  Future<void> searchGroundByKey(String key) async {
    if (key.isEmpty) {
      this.key = '';
      this.searchResults = [];
      this.isSearching = false;
      notifyListeners();
    } else {
      this.key = key;
      this.isSearching = true;
      notifyListeners();
      var resp = await _api.searchGroundByKey(key);
      this.isSearching = false;
      if (resp.isSuccess) {
        this.searchResults = resp.grounds;
      }
      notifyListeners();
    }
  }
}
