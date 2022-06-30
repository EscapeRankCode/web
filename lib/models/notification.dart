import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

import 'notification_data.dart';

class NotificationApp extends Equatable {

  final String id;
  final String type;
  final String notifiableId;
  final NotificationData data;
  final String readAt;
  final String createdAt;

  NotificationApp({required this.id, required this.type, required this.notifiableId,
    required this.data, required this.readAt, required this.createdAt});

  factory NotificationApp.fromJson(Map<String, dynamic> json) {
    NotificationData? data;
    if (json["data"] != null) {
      var dataFromJson = json["data"] as Map<String, dynamic>;
      data = NotificationData.fromJson(dataFromJson);
    }
    return NotificationApp(
      id: json["id"].toString(),
      type: json["type"],
      notifiableId: json["notifiable_id"].toString(),
      data: data!,
      createdAt: json["created_at"],
      readAt: json["read_at"]
    );
  }

  @override
  // TODO: implement props
  List<Object> get props => [id, type, notifiableId, data, readAt, createdAt];

}

