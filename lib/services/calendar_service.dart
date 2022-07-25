import 'dart:convert';

import 'package:flutter_escaperank_web/models/bookings_layer/tickets/event_tickets_response.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_escaperank_web/api_endpoints.dart';
import 'package:flutter_escaperank_web/configuration.dart';
import 'package:flutter_escaperank_web/models/bookings_layer/calendar/calendar_response.dart';

class CalendarService{

  static const BEARER =  'Bearer xosel0l0';

  /// Makes a call to the back end, that will make a call to the bookings layer
  /// in order to get the events (available or not) from a start date to an end
  /// dat, of the specified escape.
  ///
  /// Parameters:
  ///   [escape_id] : escape identifier (String)
  ///   [start_date] : start date (String) in format dd/mm/YYYY
  ///   [end_date] : start date (String) in format dd/mm/YYYY
  ///
  /// Return: [CalendarResponse] if ok, [Null] if request fails
  ///
  Future<CalendarResponse?> getCalendar(int escape_id, String start_date, String end_date) async {
    var headers = {
      'ApiKey': API.apiKey,
      'accept': 'application/json',
      'Authorization': CalendarService.BEARER, // TODO: REMOVE THE BEARER
    };

    String url = 'http://' + Config.BASE_URL + BookingsLayerApi.getCalendarAvailability +
        '?escape_id=' + escape_id.toString() +
        '&start_date=' + start_date +
        '&end_date=' + end_date;

    print("\nURL is: " + url);


    var request = http.Request('GET', Uri.parse(url));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print("--- Response is status 200");
      String res = await response.stream.bytesToString();
      dynamic body = json.decode(res);
      return CalendarResponse.fromJson(body);
    }
    else {
      print("--- Response is not status 200");
      return null;
    }

    /*
    var jsonData = {
      "escape_id": escape_id,
      "start_date": start_date,
      "end_date": end_date
    };
    Uri uri = Uri.https(Config.BASE_URL, BookingsLayerApi.getCalendarAvailability, jsonData);

    final response = await http.get(
      uri,
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json',
        'ApiKey': API.apiKey,
        'Authorization': 'Bearer xosel0l0' // TODO: REMOVE THE BEARER
      }
    );

    if (response.statusCode == Responses.RESPONSE_OK){
      dynamic body = json.decode(response.body);
      return CalendarResponse.fromJson(body);
    }

    return null;
     */
  }


  /// Makes a call to the back end, that will make a call to the bookings layer
  /// in order to get the tickets from an event.
  ///
  /// Paramenters:
  ///   [event_date] : date in format string DD/MM/YYYY
  ///   [event_time] : time in format string HH:MM
  ///   [booking_system_id] : int that refers to the booking system
  ///   [bs_config] : int that refers to the booking system configuration
  ///   [event_id] : String that refers to the event / slot
  ///
  /// Return: [EventTicketsResponse] if ok, [Null] if request fails
  ///
  Future<EventTicketsResponse?> getEventTickets(String event_date, String event_time, int booking_system_id, int bs_config, String event_id) async {
    var headers = {
      'ApiKey': API.apiKey,
      'accept': 'application/json',
      'Authorization': CalendarService.BEARER, // TODO: REMOVE THE BEARER
    };

    String url = 'http://' + Config.BASE_URL + BookingsLayerApi.getEventTickets +
        '?event_date=' + event_date +
        '&event_time=' + event_time +
        '&booking_system_id=' + booking_system_id.toString() +
        '&bs_config=' + bs_config.toString() +
        '&event_id=' + event_id;

    print("\nURL is: " + url);


    var request = http.Request('GET', Uri.parse(url));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print("--- Response is status 200");
      String res = await response.stream.bytesToString();
      dynamic body = json.decode(res);
      return EventTicketsResponse.fromJson(body);
    }
    else {
      print("--- Response is not status 200");
      return null;
    }
  }
}