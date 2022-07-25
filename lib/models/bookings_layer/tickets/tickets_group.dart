import 'package:flutter_escaperank_web/models/bookings_layer/tickets/ticket.dart';
import 'package:flutter_escaperank_web/models/bookings_layer/tickets/total_rules.dart';

class TicketsGroup{
  final List<Ticket> tickets;
  final TotalRules total_rules;

  TicketsGroup({required this.tickets, required this.total_rules});

  factory TicketsGroup.fromJson(Map<String, dynamic> json){

    List<Ticket> ticketsList = [];
    if(json["tickets"] != null) {
      var ticketsFromJson = json["tickets"] as List;
      ticketsList = ticketsFromJson.map((i) => Ticket.fromJson(i)).toList();
    }

    TotalRules totalRulesFromJson = TotalRules.fromJson(json["total_rules"]);

    return TicketsGroup(
      tickets: ticketsList,
      total_rules: totalRulesFromJson
    );

  }
}