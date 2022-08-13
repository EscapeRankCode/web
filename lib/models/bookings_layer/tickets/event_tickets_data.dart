import 'package:flutter_escaperank_web/models/bookings_layer/tickets/tickets_group.dart';

class EventTicketsData{
  final String event_id;
  final List<TicketsGroup> tickets_groups;

  EventTicketsData({required this.event_id, required this.tickets_groups});

  factory EventTicketsData.fromJson(Map<String, dynamic> json){
    print("Json response (EventTicketsData): " + json.toString());

    List<TicketsGroup> groups = [];
    if(json["tickets_groups"] != null) {
      var groupsFromJson = json["tickets_groups"] as List;
      print("Json response (EventTicketsData[tickets_groups]): " + json["tickets_groups"].toString());
      groups = groupsFromJson.map((i) => TicketsGroup.fromJson(i)).toList();
    }

    return EventTicketsData(
        event_id: json["event_id"],
        tickets_groups: groups
    );
  }

}