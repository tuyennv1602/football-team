import 'package:flutter/cupertino.dart';
import 'package:myfootball/model/notification.dart' as noti;
import 'package:myfootball/model/response/notification_resp.dart';
import 'package:myfootball/service/api.dart';
import 'package:myfootball/viewmodel/base_viewmodel.dart';

class NotificationViewModel extends BaseViewModel {
  Api _api;
  List<noti.Notification> notifications = [];

  NotificationViewModel({@required Api api}) : _api = api;

  Future<NotificationResponse> getNotifications(bool isRefresh) async {
    setBusy(!isRefresh);
    var resp = await _api.getUserNotification();
    if (resp.isSuccess) {
      notifications = resp.notifications;
    }
    setBusy(false);
    return resp;
  }
}
