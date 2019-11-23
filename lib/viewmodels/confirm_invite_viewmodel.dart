import 'package:flutter/material.dart';
import 'package:myfootball/models/matching_time_slot.dart';
import 'package:myfootball/models/responses/base_response.dart';
import 'package:myfootball/services/api.dart';
import 'package:myfootball/services/navigation_services.dart';
import 'package:myfootball/utils/object_utils.dart';
import 'package:myfootball/utils/ui_helper.dart';
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

  Future<void> acceptInviteRequest(int inviteId) async {
    UIHelper.showProgressDialog;
    var resp = await _api.acceptInviteRequest(
        inviteId, selectedTimeSlot.timeSlotId, selectedTimeSlot.playDate);
    UIHelper.hideProgressDialog;
    if (resp.isSuccess) {
      UIHelper.showSimpleDialog('Thành công. Vui lòng kiểm tra lịch thi đấu',
          onConfirmed: () => NavigationService.instance().goBack());
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }

  Future<void> rejectInviteRequest(int inviteId) async {
    UIHelper.showProgressDialog;
    var resp = await _api.rejectInviteRequest(inviteId);
    UIHelper.hideProgressDialog;
    if (resp.isSuccess) {
      UIHelper.showSimpleDialog('Đã huỷ lời mời',
          onConfirmed: () => NavigationService.instance().goBack());
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }

  Future<void> cancelInviteRequest(int inviteId) async {
    UIHelper.showProgressDialog;
    var resp = await _api.cancelInviteRequest(inviteId);
    UIHelper.hideProgressDialog;
    if (resp.isSuccess) {
      UIHelper.showSimpleDialog('Đã huỷ lời mời',
          onConfirmed: () => NavigationService.instance().goBack());
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }
}
