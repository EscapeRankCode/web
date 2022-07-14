

import 'package:flutter_escaperank_web/models/bookings_layer/calendar_general.dart';

class CalendarData{
  final String booking_system_id;
  final String bs_config_id;
  final CalendarGeneral calendar;

  CalendarData({required this.booking_system_id, required this.bs_config_id, required this.calendar});

  factory CalendarData.fromJson(Map<String, dynamic> json){
    return CalendarData(
        booking_system_id: json["booking_system_id"],
        bs_config_id: json["bs_config_id"],
        calendar: CalendarGeneral.fromJson(json["calendar"]));
  }

}