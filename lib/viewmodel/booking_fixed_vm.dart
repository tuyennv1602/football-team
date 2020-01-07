import 'package:flutter/cupertino.dart';
import 'package:myfootball/model/field.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/router/navigation.dart';
import 'package:myfootball/view/ui_helper.dart';
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
    var resp = await _api.getFreeFixedTimeSlot(groundId, dayOfWeek);
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
          onConfirmed: () => Navigation.instance.goBack());
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }
}
