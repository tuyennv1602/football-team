import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:myfootball/model/field.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/router/navigation.dart';
import 'package:myfootball/utils/date_util.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodel/base_viewmodel.dart';

class BookingViewModel extends BaseViewModel {
  Api _api;
  DateTime currentDate = DateTime.now();
  List<Field> fields = [];

  BookingViewModel({@required Api api}) : _api = api;

  setDate(int groundId, DateTime dateTime) {
    this.currentDate = dateTime;
    getFreeTimeSlot(groundId);
  }

  Future<void> getFreeTimeSlot(int groundId) async {
    setBusy(true);
    var resp = await _api.getFreeTimeSlot(
      groundId,
      DateFormat('dd/MM/yyyy').format(currentDate),
    );
    if (resp.isSuccess) {
      this.fields = resp.ground.fields;
      this.fields.forEach((field) => field.timeSlots = field.timeSlots
          .where((timeSlot) =>
              DateUtil.isAbleBooking(timeSlot.startTime, currentDate))
          .toList());
    }
    setBusy(false);
  }

  Future<void> booking(int teamId, int timeSlotId) async {
    UIHelper.showProgressDialog;
    var resp = await _api.booking(
        teamId, timeSlotId, DateUtil.getDateTimeStamp(currentDate));
    UIHelper.hideProgressDialog;
    if (resp.isSuccess) {
      UIHelper.showSimpleDialog('Đặt sân thành công',
          isSuccess: true,
          onConfirmed: () => Navigation.instance.goBack());
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }
}
