import 'package:equatable/equatable.dart';
import 'package:flutter_escaperank_web/models/bookings_layer/form/field.dart';
import 'package:flutter_escaperank_web/models/bookings_layer/tickets/tickets_group.dart';

abstract class CalendarEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class GetCalendar extends CalendarEvent{
  String? token;
  final int escape_id;
  final String start_date;
  final String end_date;

  GetCalendar({this.token, required this.escape_id, required this.start_date, required this.end_date});
}

class GetTickets extends CalendarEvent{
  String? token;
  final String event_date;
  final String event_time;
  final int booking_system_id;
  final int bs_config;
  final String event_id;

  GetTickets({this.token, required this.event_date, required this.event_time, required this.booking_system_id, required this.bs_config, required this.event_id});
}


class GetForm extends CalendarEvent{
  String? token;
  final int booking_system_id;
  final int bs_config;
  final String event_date;
  final String event_time;
  final String event_id;
  final List<TicketsGroup> event_tickets;

  GetForm({this.token, required this.booking_system_id, required this.bs_config, required this.event_date, required this.event_time, required this.event_id, required this.event_tickets});
}

class BookingFirstStep extends CalendarEvent{
  String? token;
  final int booking_system_id;
  final int bs_config;
  final String event_date;
  final String event_time;
  final String event_id;
  final List<TicketsGroup> event_tickets;
  final List<Field> event_fields;

  BookingFirstStep({this.token, required this.booking_system_id, required this.bs_config, required this.event_date, required this.event_time, required this.event_id, required this.event_tickets, required this.event_fields});
}

