import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:myfootball/models/field.dart';
import 'package:myfootball/models/responses/base_response.dart';
import 'package:myfootball/models/responses/ground_resp.dart';
import 'package:myfootball/services/api.dart';
import 'package:myfootball/utils/date_util.dart';
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
        groundId, DateUtil().formatDate(currentDate, DateFormat('dd/MM/yyyy')));
    if (resp.isSuccess) {
      this.fields = resp.ground.fields;
    }
    setBusy(false);
    return resp;
  }

  Future<BaseResponse> booking(int groundId, int timeSlotId) async {
    var resp = await _api.bookingTimeSlot(
        groundId, timeSlotId, DateUtil().getDateTimeStamp(currentDate));
    return resp;
  }
}
