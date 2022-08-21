

import 'package:equatable/equatable.dart';
import 'package:flutter_escaperank_web/models/bookings_layer/booking/booking_first_step_response.dart';
import 'package:flutter_escaperank_web/models/bookings_layer/booking/booking_second_step_response.dart';
import 'package:flutter_escaperank_web/models/bookings_layer/calendar/calendar_response.dart';
import 'package:flutter_escaperank_web/models/bookings_layer/form/event_form_response.dart';
import 'package:flutter_escaperank_web/models/bookings_layer/tickets/event_tickets_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CalendarState extends Equatable {

  @override
  List<Object> get props => [];
}

// SLOTS
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

// TICKETS
class CalendarEventTicketsLoading extends CalendarState{}

class CalendarEventTicketsLoadedSuccess extends CalendarState{
  final EventTicketsResponse eventTickets;

  CalendarEventTicketsLoadedSuccess({required this.eventTickets});
}

class CalendarEventTicketsLoadedFailure extends CalendarState{
  final String error;
  CalendarEventTicketsLoadedFailure({required this.error});
}


// FORMS
class CalendarEventFormLoading extends CalendarState{}

class CalendarEventFormLoadedSuccess extends CalendarState{
  final EventFormResponse eventForm;

  CalendarEventFormLoadedSuccess({required this.eventForm});
}

class CalendarEventFormLoadedFailure extends CalendarState{
  final String error;
  CalendarEventFormLoadedFailure({required this.error});
}

// BOOKING STEP 1
class CalendarBookingFirstStepLoading extends CalendarState{}

class CalendarBookingFirstStepLoadedSuccess extends CalendarState{
  final BookingFirstStepResponse bookingFirstStepResponse;

  CalendarBookingFirstStepLoadedSuccess({required this.bookingFirstStepResponse});
}

class CalendarBookingFirstStepLoadedFailure extends CalendarState{
  final String error;
  CalendarBookingFirstStepLoadedFailure({required this.error});
}

// BOOKING STEP 2
class CalendarBookingSecondStepLoading extends CalendarState{}

class CalendarBookingSecondStepLoadedSuccess extends CalendarState{
  final BookingSecondStepResponse bookingSecondStepResponse;

  CalendarBookingSecondStepLoadedSuccess({required this.bookingSecondStepResponse});
}

class CalendarBookingSecondStepLoadedFailure extends CalendarState{
  final String error;
  CalendarBookingSecondStepLoadedFailure({required this.error});
}

