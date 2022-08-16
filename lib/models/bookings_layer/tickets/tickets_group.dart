import 'dart:convert';

import 'package:flutter_escaperank_web/models/bookings_layer/tickets/ticket.dart';
import 'package:flutter_escaperank_web/models/bookings_layer/tickets/tickets_selection.dart';
import 'package:flutter_escaperank_web/models/bookings_layer/tickets/total_rules.dart';

class TicketsGroup{
  final List<Ticket> tickets;
  final TotalRules total_rules;
  TicketsSelection tickets_selection;

  TicketsGroup({required this.tickets, required this.total_rules, required this.tickets_selection});

  factory TicketsGroup.fromJson(Map<String, dynamic> json){
    print("Json response (TicketsGroup): " + json.toString());

    List<Ticket> ticketsList = [];
    if(json["tickets"] != null) {
      var ticketsFromJson = json["tickets"] as List;
      ticketsList = ticketsFromJson.map((i) => Ticket.fromJson(i)).toList();
    }

    TotalRules totalRulesFromJson = TotalRules.fromJson(json["total_rules"]);

    return TicketsGroup(
      tickets: ticketsList,
      total_rules: totalRulesFromJson,
      tickets_selection: TicketsSelection()
    );

  }

  Map toJson() => {
    'tickets': jsonEncode(tickets),
    'total_rules': jsonEncode(total_rules),
    'tickets_selection': jsonEncode(tickets_selection)
  };

}