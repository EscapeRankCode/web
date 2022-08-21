import 'dart:convert';

import 'package:flutter_escaperank_web/models/bookings_layer/booking/booking_first_step_response.dart';
import 'package:flutter_escaperank_web/models/bookings_layer/form/event_form_response.dart';
import 'package:flutter_escaperank_web/models/bookings_layer/form/field.dart';
import 'package:flutter_escaperank_web/models/bookings_layer/tickets/event_tickets_response.dart';
import 'package:flutter_escaperank_web/models/bookings_layer/tickets/tickets_group.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_escaperank_web/api_endpoints.dart';
import 'package:flutter_escaperank_web/configuration.dart';
import 'package:flutter_escaperank_web/models/bookings_layer/calendar/calendar_response.dart';

class CalendarService{

  static const BEARER =  'Bearer xosel0l0'; // TODO: REMOVE

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


  /// Makes a call to the back end to get the form fields of an event
  /// Paramenters:
  ///   [booking_system_id] id of the BS
  ///   [bs_config] id of the BS Config
  ///   [event_date] date in format dd/mm/yyyy
  ///   [event_time] time in format hh:mm
  ///   [event_id] id of the event
  ///   [event_tickets] all groups of the tickets that have been selected
  ///
  Future<EventFormResponse?> getEventForm(int booking_system_id, int bs_config, String event_date, String event_time, String event_id, List<TicketsGroup> event_tickets) async {

    var headers = {
      'ApiKey': API.apiKey,
      'accept': 'application/json',
      'Authorization': CalendarService.BEARER, // TODO: REMOVE THE BEARER
    };

    String url = 'http://' + Config.BASE_URL + BookingsLayerApi.getEventForm; // +

    print("FORM URL");
    print(url);

    var request = http.Request('POST', Uri.parse(url));


    request.headers.addAll(headers);

    var request_body = json.encode({
      "booking_system_id": booking_system_id,
      "bs_config": bs_config,
      "event_date": event_date,
      "event_time": event_time,
      "event_id": event_id,
      "event_tickets": jsonEncode(event_tickets)
    });

    request.body = request_body;

    // print("FORM BODY: " + request_body);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print("--- Response is status 200");
      String res = await response.stream.bytesToString();
      print("response is : " + res);
      Map<String, dynamic> json_map = json.decode(res);
      print("FORM BODY: " + json_map.toString());
      return EventFormResponse.fromJson(json_map);
    }
    else {
      print("--- Response is not status 200");
      return null;
    }

  }

  // booking_first_step
  /// Makes a call to the back end to pre book the slot
  /// Paramenters:
  ///   [booking_system_id] id of the BS
  ///   [bs_config] id of the BS Config
  ///   [event_date] date in format dd/mm/yyyy
  ///   [event_time] time in format hh:mm
  ///   [event_id] id of the event
  ///   [event_tickets] all groups of the tickets that have been selected
  ///   [event_fields] all fields and its user input inside
  ///
  Future<BookingFirstStepResponse?> booking_first_step(int booking_system_id, int bs_config, String event_date, String event_time, String event_id, List<TicketsGroup> event_tickets, List<Field> event_fields) async {

    var headers = {
      'ApiKey': API.apiKey,
      'accept': 'application/json',
      'Authorization': CalendarService.BEARER, // TODO: REMOVE THE BEARER
    };

    String url = 'http://' + Config.BASE_URL + BookingsLayerApi.booking_first_step;

    var request = http.Request('POST', Uri.parse(url));


    request.headers.addAll(headers);

    var request_body = json.encode({
      "booking_system_id": booking_system_id,
      "bs_config": bs_config,
      "event_date": event_date,
      "event_time": event_time,
      "event_id": event_id,
      "event_tickets": jsonEncode(event_tickets),
      "event_fields": jsonEncode(event_fields)
    });

    request.body = request_body;

    print("BOOKING STEP 1 BODY: " + request_body);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print("--- Response is status 200");
      String res = await response.stream.bytesToString();
      print("response is : " + res);
      // Map<String, dynamic> json_map = json.decode(res);
      dynamic json_map = json.decode(res);
      // print("BOOK FIRST STEP RESULT BODY: " + json_map.toString());
      return BookingFirstStepResponse.fromJson(json_map);
    }
    else {
      print("--- Response is not status 200");
      print(response);
      return null;
    }

  }

}