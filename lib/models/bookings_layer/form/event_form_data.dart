
import 'dart:convert';

import 'package:flutter_escaperank_web/models/bookings_layer/form/field.dart';

class EventFormData{
  final String event_id;
  final List<Field> fields;

  EventFormData({required this.event_id, required this.fields});

  factory EventFormData.fromJson(Map<String, dynamic> json){
    print("Json response (EventFormData): " + json.toString());

    List<Field> fields = [];
    if(json["fields"] != null) {
      var fieldsFromJson = json["fields"] as List;
      print("Json response (EventFormData[fields]): " + json["fields"].toString());
      fields = fieldsFromJson.map((i) => Field.fromJson(i)).toList();
    }

    return EventFormData(
        event_id: json["event_id"],
        fields: fields
    );
  }

  Map toJson() => {
    'event_id': event_id,
    'fields': jsonEncode(fields)
  };

}