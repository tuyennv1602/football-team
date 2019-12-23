import 'package:flutter/cupertino.dart';
import 'package:myfootball/model/group_matching_info.dart';
import 'package:myfootball/model/response/create_matching_resp.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/service/team_services.dart';
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

  addAddressInfos(List<AddressInfo> addressInfo) {
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

  Future<CreateMatchingResponse> saveMatchingInfo(int teamId) async {
    GroupMatchingInfo _groupMatchingInfo = GroupMatchingInfo(
        groupId: teamId, timeInfo: timeInfos, addressInfo: addressInfos);
    var resp = await _api.createMatchingInfo(_groupMatchingInfo);
    if (resp.isSuccess) {
      _teamServices.updateMatchingInfo(resp.groupMatchingInfos);
    }
    return resp;
  }
}
