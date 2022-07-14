

import 'package:flutter_escaperank_web/models/bookings_layer/calendar_day.dart';

class CalendarGeneral{
  final String timezone;
  final List<CalendarDay> days;

  CalendarGeneral({required this.timezone, required this.days});
  
  factory CalendarGeneral.fromJson(Map<String, dynamic> json){
    List<CalendarDay> days = [];

    if (json["days"] != null){
      var jsonDaysList = json["days"] as List;
      days = jsonDaysList.map((i) => CalendarDay.fromJson(i)).toList();
    }

    return CalendarGeneral(timezone: json["timezone"], days: days);
  }
}