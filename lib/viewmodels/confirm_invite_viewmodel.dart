import 'package:flutter/material.dart';
import 'package:myfootball/models/matching_time_slot.dart';
import 'package:myfootball/models/responses/base_response.dart';
import 'package:myfootball/services/api.dart';
import 'package:myfootball/utils/object_utils.dart';
import 'package:myfootball/viewmodels/base_viewmodel.dart';

class ConfirmInviteViewModel extends BaseViewModel {
  Api _api;
  MatchingTimeSlot selectedTimeSlot;
  Map<int, List<MatchingTimeSlot>> mappedTimeSlots;

  ConfirmInviteViewModel({@required Api api}) : _api = api;

  setTimeSlot(List<MatchingTimeSlot> timeSlots) {
    this.mappedTimeSlots = ObjectUtil.mapMatchingTimeSlotByDayOfWeek(timeSlots);
    notifyListeners();
  }

  setSelectedTimeSlot(MatchingTimeSlot timeSlot) {
    this.selectedTimeSlot = timeSlot;
    notifyListeners();
  }

  Future<BaseResponse> acceptInviteRequest(int inviteId) async {
    var resp = await _api.acceptInviteRequest(
        inviteId, selectedTimeSlot.timeSlotId, selectedTimeSlot.playDate);
    return resp;
  }

  Future<BaseResponse> rejectInviteRequest(int inviteId) async {
    var resp = await _api.rejectInviteRequest(inviteId);
    return resp;
  }

  Future<BaseResponse> cancelInviteRequest(int inviteId) async {
    var resp = await _api.cancelInviteRequest(inviteId);
    return resp;
  }
}
