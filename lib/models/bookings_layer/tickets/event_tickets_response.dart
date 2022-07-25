

import 'event_tickets_data.dart';

class EventTicketsResponse{
  final String? status;
  final String? code;
  final EventTicketsData data;

  EventTicketsResponse({
    required this.data,
    this.status,
    this.code
  });

  factory EventTicketsResponse.fromJson(Map<String, dynamic> json){
    EventTicketsData data = EventTicketsData.fromJson(json);
    // TODO: are STATUS and CODE necessary?

    return EventTicketsResponse(data: data);
  }
}