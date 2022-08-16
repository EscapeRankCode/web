
import 'dart:convert';

import 'package:flutter_escaperank_web/models/bookings_layer/form/event_form_data.dart';

class EventFormResponse{
  final String? status;
  final String? code;
  final EventFormData data;

  EventFormResponse({
    required this.data,
    this.status,
    this.code
  });

  factory EventFormResponse.fromJson(Map<String, dynamic> json){
    print("Json response (EventFormResponse): " + json.toString());
    EventFormData data = EventFormData.fromJson(json);

    return EventFormResponse(data: data);
  }

  String toJsonString(){
    String data_string = "Data: " + jsonEncode(data);
    return data_string;
  }
}