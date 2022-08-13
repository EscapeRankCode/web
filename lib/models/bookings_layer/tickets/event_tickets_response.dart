

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
    print("Json response (EventTicketsResponse): " + json.toString());
    EventTicketsData data = EventTicketsData.fromJson(json); // TODO: ENTRAR AQUI PARA VER DONDE NO SE ESTÁN CAPTANDO
    // TODO: are STATUS and CODE necessary?

    return EventTicketsResponse(data: data);
  }

  String toJsonString(){
    String data_string =
        "\n" + data.event_id +
        "\n" + "Groups length: " + data.tickets_groups.length.toString(); // TODO: IS ZERO
    return data_string;
  }
}