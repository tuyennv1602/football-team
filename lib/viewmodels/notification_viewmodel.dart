import 'package:flutter/cupertino.dart';
import 'package:myfootball/models/notification.dart' as noti;
import 'package:myfootball/models/responses/notification_resp.dart';
import 'package:myfootball/services/api.dart';
import 'package:myfootball/viewmodels/base_viewmodel.dart';

class NotificationViewModel extends BaseViewModel {
  Api _api;
  List<noti.Notification> notifications = [];

  NotificationViewModel({@required Api api}) : _api = api;

  Future<NotificationResponse> getNotifications() async {
    setBusy(true);
    var resp = await _api.getNotifications();
    if (resp.isSuccess) {
      notifications = resp.notifications;
    }
    setBusy(false);
    return resp;
  }
}
