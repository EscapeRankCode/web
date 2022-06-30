
import 'package:flutter_escaperank_web/models/notification.dart';

class NotificationsList {
  final List<NotificationApp> notifications;

  NotificationsList({required this.notifications});

  factory NotificationsList.fromJson(List<dynamic> json) {
    List<NotificationApp> notificationList = json.map((i) => NotificationApp.fromJson(i)).toList();
    return NotificationsList(notifications: notificationList);
  }
}

