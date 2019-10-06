import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myfootball/models/district.dart';
import 'package:myfootball/models/group_matching_info.dart';
import 'package:myfootball/models/province.dart';
import 'package:myfootball/models/responses/district_resp.dart';
import 'package:myfootball/models/responses/province_resp.dart';
import 'package:myfootball/models/responses/ward_resp.dart';
import 'package:myfootball/models/ward.dart';
import 'package:myfootball/services/api.dart';
import 'package:myfootball/utils/constants.dart';
import 'package:myfootball/viewmodels/base_view_model.dart';
import 'package:flutter/services.dart' show rootBundle;

class AddAddressViewModel extends BaseViewModel {
  Province province;
  District district;
  Ward ward;
  int step = Constants.SELECT_PROVINCE;
  List<District> districts = [];
  List<Ward> wards = [];
  List<Province> provinces = [];

  Api _api;

  AddAddressViewModel({@required Api api}) : _api = api;

  Future<ProvinceResponse> getAllProvince() async {
    setBusy(true);
    String data = await rootBundle.loadString('assets/data/provinces.json');
    var resp = ProvinceResponse.success(jsonDecode(data));
    if (resp.isSuccess) {
      provinces = resp.provinces;
    }
    setBusy(false);
    return resp;
  }

  Future<DistrictResponse> getDistrictByProvinceId() async {
    setBusy(true);
    var resp = await _api.getDistrictByProvince(province.id);
    if (resp.isSuccess) {
      this.districts = resp.districts;
    }
    setBusy(false);
    return resp;
  }

  Future<WardResponse> getWardByDistrict() async {
    setBusy(true);
    var resp = await _api.getWardByDistrict(district.id);
    if (resp.isSuccess) {
      this.wards = resp.wards;
    }
    setBusy(false);
    return resp;
  }

  setProvince(Province province) {
    this.province = province;
    step = Constants.SELECT_DISTRICT;
    getDistrictByProvinceId();
    notifyListeners();
  }

  setDistrict(District district) {
    this.district = district;
    step = Constants.SELECT_WARD;
    getWardByDistrict();
    notifyListeners();
  }

  setWard(Ward ward) {
    this.ward = ward;
    notifyListeners();
  }

  AddressInfo getAddressInfo() {
    return AddressInfo(
        provinceName: this.province.name,
        provinceId: this.province.id,
        districtName: this.district.name,
        districtId: this.district.id,
        wardName: this.ward.name,
        wardId: this.ward.id);
  }
}
