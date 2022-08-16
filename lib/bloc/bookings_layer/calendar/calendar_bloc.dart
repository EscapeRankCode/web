

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_escaperank_web/bloc/bookings_layer/calendar/calendar_event.dart';
import 'package:flutter_escaperank_web/bloc/bookings_layer/calendar/calendar_state.dart';
import 'package:flutter_escaperank_web/services/calendar_service.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState>{
  final CalendarService _calendarService;

  CalendarBloc(CalendarService calendarService)
      : assert(calendarService != null),
        _calendarService = calendarService,
  super(CalendarInitial());

  @override
  Stream<CalendarState> mapEventToState(CalendarEvent event) async*{

    if (event is GetCalendar){
      yield* _mapGetCalendarToState(event);
    }
    if (event is GetTickets){
      yield* _mapGetTicketsToState(event);
    }

    yield CalendarLoadedFailure(error: "error_get_calendar");
  }
  
  Stream<CalendarState> _mapGetCalendarToState(GetCalendar event) async*{
    yield CalendarLoading();
    
    try{
      var calendar = await _calendarService.getCalendar(event.escape_id, event.start_date, event.end_date);

      if (calendar != null){
        yield CalendarLoadedSuccess(calendarAvailability: calendar);

      }else{
        yield CalendarLoadedFailure(error: "error_get_calendar");
      }

    } catch(err){
      yield CalendarLoadedFailure(error: "error_get_calendar");
    }
    
  }

  Stream<CalendarState> _mapGetTicketsToState(GetTickets event) async*{

    yield CalendarEventTicketsLoading();

    try{

      var event_tickets = await _calendarService.getEventTickets(event.event_date, event.event_time, event.booking_system_id, event.bs_config, event.event_id);

      if (event_tickets != null){
        yield CalendarEventTicketsLoadedSuccess(eventTickets: event_tickets);

      }else{
        yield CalendarEventTicketsLoadedFailure(error: "error_get_tickets");
      }

    }catch(err){
      yield CalendarEventTicketsLoadedFailure(error: "error_get_tickets");
    }

  }

  Stream<CalendarState> _mapGetFormToState(GetForm event) async*{

    yield CalendarEventFormLoading();

    try{

      var eventForm = await _calendarService.getEventForm(event.booking_system_id, event.bs_config, event.event_date, event.event_time, event.event_id, event.event_tickets);

      if (eventForm != null){
        yield CalendarEventFormLoadedSuccess(eventForm: eventForm);

      }else{
        yield CalendarEventFormLoadedFailure(error: "error_get_form");
      }

    }catch(err){
      yield CalendarEventFormLoadedFailure(error: "error_get_form");
    }

  }

}