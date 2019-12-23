import 'package:flutter/cupertino.dart';
import 'package:myfootball/model/field.dart';
import 'package:myfootball/model/response/base_response.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/utils/date_util.dart';
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

  Future<BaseResponse> booking(int teamId, int timeSlotId) async {
    var resp = await _api.requestFixedBooking(teamId, timeSlotId, dayOfWeek);
    return resp;
  }

  String get getDayOfWeek => DateUtil.getDayOfWeek(dayOfWeek);
}
