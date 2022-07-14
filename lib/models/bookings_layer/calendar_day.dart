

import 'package:flutter_escaperank_web/models/bookings_layer/calendar_simple_event.dart';

class CalendarDay{
  final int year;
  final int month;
  final int day;
  final int day_availability;
  final List<CalendarSimpleEvent> events;

  CalendarDay({
    required this.year,
    required this.month,
    required this.day,
    required this.day_availability,
    required this.events
  });

  factory CalendarDay.fromJson(Map<String, dynamic> json){
    List<CalendarSimpleEvent> events = [];

    if (json["events"] != null){
      var eventsJsonList = json["events"] as List;
      events = eventsJsonList.map((i) => CalendarSimpleEvent.fromJson(i)).toList();
    }

    return CalendarDay(year: json["year"], month: json["month"], day: json["day"], day_availability: json["day_availability"], events: events);
  }

}