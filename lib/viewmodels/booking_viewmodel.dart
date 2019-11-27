import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:myfootball/models/field.dart';
import 'package:myfootball/models/responses/base_response.dart';
import 'package:myfootball/models/responses/ground_resp.dart';
import 'package:myfootball/services/api.dart';
import 'package:myfootball/services/navigation_services.dart';
import 'package:myfootball/utils/date_util.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodels/base_viewmodel.dart';

class BookingViewModel extends BaseViewModel {
  Api _api;
  DateTime currentDate = DateTime.now();
  List<Field> fields = [];

  BookingViewModel({@required Api api}) : _api = api;

  setDate(int groundId, DateTime dateTime) {
    this.currentDate = dateTime;
    getFreeTimeSlot(groundId);
  }

  Future<GroundResponse> getFreeTimeSlot(int groundId) async {
    setBusy(true);
    var resp = await _api.getFreeTimeSlots(
        groundId, DateFormat('dd/MM/yyyy').format(currentDate));
    if (resp.isSuccess) {
      this.fields = resp.ground.fields;
      this.fields.forEach((field) => field.timeSlots = field.timeSlots
          .where((timeSlot) =>
              DateUtil.isAbleBooking(timeSlot.startTime, currentDate))
          .toList());
    }
    setBusy(false);
    return resp;
  }

  Future<BaseResponse> booking(int teamId, int timeSlotId) async {
    UIHelper.showProgressDialog;
    var resp = await _api.booking(
        teamId, timeSlotId, DateUtil.getDateTimeStamp(currentDate));
    UIHelper.hideProgressDialog;
    if (resp.isSuccess) {
      UIHelper.showSimpleDialog(
          'Đặt sân thành công. Bạn có thể lên lịch cho đội bóng trong mục quản trị đội bóng',
          isSuccess: true,
          onConfirmed: () => NavigationService.instance.goBack());
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
    return resp;
  }
}
