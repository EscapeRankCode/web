import 'dart:convert';

import 'package:flutter_escaperank_web/models/bookings_layer/tickets/ticket.dart';

class TicketsSelection{
  int counter_selected_units;
  int check_selected_units;
  int option_selected_units;
  List<Ticket> selected_tickets;

  TicketsSelection(
    {
      required this.counter_selected_units,
      required this.check_selected_units,
      required this.option_selected_units,
      required this.selected_tickets
    }
  );

  factory TicketsSelection.fromJson(Map<String, dynamic> json){
    print("Json in SELECTED TICKETS: " + json.toString());
    List<Ticket> ticketsList = [];

    if (json["selected_tickets"] != null){
      var ticketsFromJson = json["selected_tickets"] as List;
      ticketsList = ticketsFromJson.map((i) => Ticket.fromJson(i)).toList();
    }

    int counter = 0;
    int check = 0;
    int option = 0;
    if (json["counter_selected_units"] != null){
      counter = json["counter_selected_units"];
    }
    if (json["check_selected_units"] != null){
      check = json["check_selected_units"];
    }
    if (json["option_selected_units"] != null){
      option = json["option_selected_units"];
    }

    return TicketsSelection(
        counter_selected_units: counter,
        check_selected_units: check,
        option_selected_units: option,
        selected_tickets: ticketsList
    );
  }


  Map toJson() => {
    'counter_selected_units': counter_selected_units,
    'check_selected_units': check_selected_units,
    'option_selected_units': option_selected_units,
    'selected_tickets': jsonEncode(selected_tickets)
  };

}