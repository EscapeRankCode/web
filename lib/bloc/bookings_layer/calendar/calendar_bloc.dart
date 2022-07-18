

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

    yield CalendarLoadedFailure(error: "error_get_calendar");
  }
  
  Stream<CalendarState> _mapGetCalendarToState(GetCalendar event) async*{
    yield CalendarLoading();
    
    try{
      var calendar = await _calendarService.getCalendar(event.escape_id, event.start_date, event.end_date);

      print("CALENDAR FROM JSON IS:");
      print(calendar);


      if (calendar != null){
        print("Calendar is not null");
        yield CalendarLoadedSuccess(calendarAvailability: calendar);

      }else{
        print("Calendar is null");
        yield CalendarLoadedFailure(error: "error_get_calendar");
      }

    } catch(err){
      print("Exception!");
      yield CalendarLoadedFailure(error: "error_get_calendar");
    }
    
  }
}