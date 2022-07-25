import 'package:flutter_escaperank_web/models/bookings_layer/tickets/ticket_info.dart';

class Ticket{
  static const COUNTER = 1;
  static const CHECK = 2;
  static const OPTION = 3;

  final String ticket_name;
  final int ticket_type;
  final TicketInfo? ticket_info;

  Ticket({required this.ticket_name, required this.ticket_type, required this.ticket_info});

  factory Ticket.fromJson(Map<String, dynamic> json){
    TicketInfo? jsonTicketInfo;

    switch (json["ticket_type"]){
      case COUNTER:
        jsonTicketInfo = TicketInfoCounter.fromJson(json["ticket_info"]);
        break;
      case CHECK:
        jsonTicketInfo = TicketInfoCheck.fromJson(json["ticket_info"]);
        break;
      case OPTION:
        jsonTicketInfo = TicketInfoOption.fromJson(json["ticket_info"]);
        break;
    }

    return Ticket(
        ticket_name: json["ticket_name"],
        ticket_type: json["ticket_type"],
        ticket_info: jsonTicketInfo
    );

  }

}