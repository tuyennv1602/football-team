import 'package:flutter/cupertino.dart';
import 'package:myfootball/model/group_matching_info.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/router/navigation.dart';
import 'package:myfootball/service/team_services.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodel/base_viewmodel.dart';

class SetupMatchingInfoViewModel extends BaseViewModel {
  Api _api;
  TeamServices _teamServices;
  List<AddressInfo> addressInfos = [];
  List<TimeInfo> timeInfos = [];

  SetupMatchingInfoViewModel(
      {@required Api api, @required TeamServices teamServices})
      : _api = api,
        _teamServices = teamServices;

  setAddressInfo(List<AddressInfo> addressInfos) {
    if (addressInfos != null) {
      this.addressInfos.addAll(addressInfos);
      notifyListeners();
    }
  }

  addAddressInfos(List<AddressInfo>  addressInfo) {
    this.addressInfos.addAll(addressInfo);
    notifyListeners();
  }

  removeAddressInfo(int index) {
    this.addressInfos.removeAt(index);
    notifyListeners();
  }

  setTimeInfo(List<TimeInfo> timeInfos) {
    if (timeInfos != null) {
      this.timeInfos.addAll(timeInfos);
      notifyListeners();
    }
  }

  addTimeInfo(TimeInfo timeInfo) {
    this.timeInfos.add(timeInfo);
    notifyListeners();
  }

  removeTimeInfo(int index) {
    this.timeInfos.removeAt(index);
    notifyListeners();
  }

  Future<void> saveMatchingInfo(int groupId) async {
    UIHelper.showProgressDialog;
    GroupMatchingInfo _groupMatchingInfo = GroupMatchingInfo(
        groupId: groupId, timeInfo: timeInfos, addressInfo: addressInfos);
    var resp = await _api.createMatchingInfo(_groupMatchingInfo);
    UIHelper.hideProgressDialog;
    if (resp.isSuccess) {
      _teamServices.updateMatchingInfo(resp.groupMatchingInfos);
      UIHelper.showSimpleDialog(
          'Đã cập nhật thông tin ghép đối',
          isSuccess: true,
          onConfirmed: () => Navigation.instance.goBack());
    }else{
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }
}
