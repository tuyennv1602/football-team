import 'package:flutter/material.dart';
import 'package:myfootball/models/invite_request.dart';
import 'package:myfootball/models/matching_time_slot.dart';
import 'package:myfootball/models/responses/base_response.dart';
import 'package:myfootball/services/api.dart';
import 'package:myfootball/services/navigation_services.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodels/base_viewmodel.dart';

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

  Future<BaseResponse> sendInvite(InviteRequest matchingRequest) async {
    UIHelper.showProgressDialog;
    var resp = await _api.sendInvite(matchingRequest);
    UIHelper.hideProgressDialog;
    if (resp.isSuccess) {
      UIHelper.showSimpleDialog('Đã gửi lời mời',
          onTap: () => NavigationService.instance().goBack());
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
    return resp;
  }
}
