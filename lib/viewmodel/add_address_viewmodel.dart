import 'package:flutter/material.dart';
import 'package:myfootball/model/district.dart';
import 'package:myfootball/model/group_matching_info.dart';
import 'package:myfootball/model/province.dart';
import 'package:myfootball/model/ward.dart';
import 'package:myfootball/service/sqlite_services.dart';
import 'package:myfootball/utils/constants.dart';
import 'package:myfootball/viewmodel/base_viewmodel.dart';

class AddAddressViewModel extends BaseViewModel {
  Province province;
  District district;
  List<Ward> selectedWards = [];
  int step = Constants.SELECT_PROVINCE;
  List<District> districts = [];
  List<Ward> wards = [];
  List<Province> provinces = [];

  SQLiteServices _sqLiteServices;

  AddAddressViewModel({@required SQLiteServices sqLiteServices})
      : _sqLiteServices = sqLiteServices;

  Future<List<Province>> getAllProvince() async {
    setBusy(true);
    var resp = await _sqLiteServices.getProvinces();
    provinces = resp;
    setBusy(false);
    return resp;
  }

  Future<List<District>> getDistrictByProvinceId() async {
    setBusy(true);
    var resp = await _sqLiteServices.getDistrictsByProvince(province.id);
    districts = resp;
    setBusy(false);
    return resp;
  }

  Future<List<Ward>> getWardByDistrict() async {
    setBusy(true);
    var resp = await _sqLiteServices.getWardsByDistrict(district.id);
    wards = resp;
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
    this.selectedWards.add(ward);
    notifyListeners();
  }

  removeWard(Ward ward) {
    int index = this.selectedWards.indexWhere((item) => item.id == ward.id);
    if (index != -1) {
      this.selectedWards.removeAt(index);
      notifyListeners();
    }
  }

  selectAllWards() {
    this.selectedWards.clear();
    this.selectedWards.addAll(wards);
    notifyListeners();
  }

  removeAllWards() {
    this.selectedWards.clear();
    notifyListeners();
  }

  List<AddressInfo> getAddressInfo() {
    List<AddressInfo> addressInfos = [];
    this.selectedWards.forEach((ward) => addressInfos.add(AddressInfo(
        provinceName: this.province.name,
        provinceId: this.province.id,
        districtName: this.district.name,
        districtId: this.district.id,
        wardName: ward.name,
        wardId: ward.id)));
    return addressInfos;
  }
}
