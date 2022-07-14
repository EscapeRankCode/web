

import 'package:equatable/equatable.dart';

abstract class CalendarEvent extends Equatable{
  @override
  List<Object> get props => [];
}

// Similar to GetProductEvents in app version
class GetCalendar extends CalendarEvent{
  String? token;
  final int escape_id;
  final String start_date;
  final String end_date;

  GetCalendar({this.token, required this.escape_id, required this.start_date, required this.end_date});
}