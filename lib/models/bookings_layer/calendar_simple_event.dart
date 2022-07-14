
class CalendarSimpleEvent{
  final String time;
  final String eventId;
  final int availability;


  CalendarSimpleEvent({required this.time, required this.eventId, required this.availability});

  factory CalendarSimpleEvent.fromJson(Map<String, dynamic> json){
    return CalendarSimpleEvent(
      time: json["time"],
      eventId: json["event_id"],
      availability: json["availability"]
    );
  }
}