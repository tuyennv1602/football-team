import 'package:flutter/material.dart';
import 'package:myfootball/model/invite_request.dart';
import 'package:myfootball/model/matching_time_slot.dart';
import 'package:myfootball/model/response/base_response.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/viewmodel/base_viewmodel.dart';

class InviteTeamViewModel extends BaseViewModel {
  Api _api;
  List<MatchingTimeSlot> selectedTimeSlots = [];

  InviteTeamViewModel({@required Api api}) : _api = api;

  addTimeSlots(MatchingTimeSlot timeSlot) {
    this.selectedTimeSlots.add(timeSlot);
    notifyListeners();
  }

  removeTimeSlot(MatchingTimeSlot timeSlot) {
    int index = this
        .selectedTimeSlots
        .indexWhere((item) => item.timeSlotId == timeSlot.timeSlotId);
    if (index != -1) {
      this.selectedTimeSlots.removeAt(index);
      notifyListeners();
    }
  }

  Future<BaseResponse> sendInvite(InviteRequest inviteRequest) async {
    var resp = await _api.sendInvite(inviteRequest);
    return resp;
  }
}