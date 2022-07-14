

import 'package:equatable/equatable.dart';
import 'package:flutter_escaperank_web/models/bookings_layer/calendar_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CalendarState extends Equatable {

  @override
  List<Object> get props => [];
}

class CalendarInitial extends CalendarState{}

class CalendarLoading extends CalendarState{}

class CalendarLoadedSuccess extends CalendarState{
  final CalendarResponse calendarAvailability;

  CalendarLoadedSuccess({required this.calendarAvailability});
}

class CalendarLoadedFailure extends CalendarState{
  final String error;
  CalendarLoadedFailure({required this.error});
}

