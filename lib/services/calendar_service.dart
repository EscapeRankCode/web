import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_escaperank_web/api_endpoints.dart';
import 'package:flutter_escaperank_web/configuration.dart';
import 'package:flutter_escaperank_web/models/bookings_layer/calendar_response.dart';

class CalendarService{

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
    Uri uri = Uri.https(Config.BASE_URL, BookingsLayerApi.getCalendarAvailability);
    var jsonData = {
      "escape_id": escape_id,
      "start_date": start_date,
      "end_date": end_date
    };
    final response = await http.post(
      uri,
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: json.encode(jsonData)
    );

    if (response.statusCode == Responses.RESPONSE_OK){
      dynamic body = json.decode(response.body);
      return CalendarResponse.fromJson(body);
    }

    return null;
  }

}