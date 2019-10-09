import 'package:flutter/cupertino.dart';
import 'package:myfootball/models/group_matching_info.dart';
import 'package:myfootball/models/responses/create_matching_resp.dart';
import 'package:myfootball/services/api.dart';
import 'package:myfootball/services/team_services.dart';
import 'package:myfootball/viewmodels/base_viewmodel.dart';

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

  addAddressInfo(AddressInfo addressInfo) {
    this.addressInfos.add(addressInfo);
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

  addTimeInfo(String start, String end) {
    List<String> _starts = start.split(':');
    List<String> _ends = end.split(':');
    this.timeInfos.add(
          TimeInfo(
              startHour: int.parse(_starts[0]),
              startMinute: int.parse(_starts[1]),
              endHour: int.parse(_ends[0]),
              endMinute: int.parse(_ends[1])),
        );
    notifyListeners();
  }

  removeTimeInfo(int index) {
    this.timeInfos.removeAt(index);
    notifyListeners();
  }

  Future<CreateMatchingResponse> saveMatchingInfo(int groupId) async {
    GroupMatchingInfo _groupMatchingInfo = GroupMatchingInfo(
        groupId: groupId, timeInfo: timeInfos, addressInfo: addressInfos);
    var resp = await _api.createMatchingInfo(_groupMatchingInfo);
    if (resp.isSuccess) {
      _teamServices.updateMatchingInfo(resp.groupMatchingInfos);
    }
    return resp;
  }
}
