


import 'package:flutter_escaperank_web/models/bookings_layer/calendar_data.dart';

class CalendarResponse{
  final String? status;
  final String? code;
  final CalendarData data;

  CalendarResponse({
    required this.data,
    this.status,
    this.code
  });

  factory CalendarResponse.fromJson(Map<String, dynamic> json){
    CalendarData data = CalendarData.fromJson(json);
    // TODO: are STATUS and CODE necessary?

    return CalendarResponse(data: data);
  }
}