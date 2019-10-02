import 'package:myfootball/models/notification.dart';
import 'package:myfootball/models/responses/base_response.dart';

class NotificationResponse extends BaseResponse {
  List<Notification> notifications;

  NotificationResponse.success(Map<String, dynamic> json)
      : super.success(json) {
    if (json['object'] != null) {
      notifications = new List<Notification>();
      json['object'].forEach((v) {
        var notification = new Notification.fromJson(v);
        notifications.add(notification);
      });
    }
  }

  NotificationResponse.error(String message) : super.error(message);
}
