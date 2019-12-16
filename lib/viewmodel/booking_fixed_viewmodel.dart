import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:myfootball/model/field.dart';
import 'package:myfootball/model/response/base_response.dart';
import 'package:myfootball/model/response/ground_resp.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/service/navigation_services.dart';
import 'package:myfootball/utils/date_util.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodel/base_viewmodel.dart';

class BookingFixedViewModel extends BaseViewModel {
  Api _api;
  int dayOfWeek = 1;
  List<Field> fields = [];

  BookingFixedViewModel({@required Api api}) : _api = api;

  setDayOfWeek(int groundId, int dayOfWeek) {
    this.dayOfWeek = dayOfWeek;
    getFreeFixedTimeSlot(groundId);
  }

  Future<void> getFreeFixedTimeSlot(int groundId) async {
    setBusy(true);
    var resp = await _api.getFreeFixedTimeSlots(groundId, dayOfWeek);
    if (resp.isSuccess) {
      this.fields = resp.ground.fields;
    }
    setBusy(false);
  }

  Future<void> booking(int teamId, int timeSlotId) async {
    UIHelper.showProgressDialog;
    var resp = await _api.requestFixedBooking(teamId, timeSlotId, dayOfWeek);
    UIHelper.hideProgressDialog;
    if (resp.isSuccess) {
      UIHelper.showSimpleDialog(
          'Yêu cầu đã được gửi. Vui lòng chờ quản lý sân xác nhận',
          isSuccess: true,
          onConfirmed: () => NavigationService.instance.goBack());
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }
}
