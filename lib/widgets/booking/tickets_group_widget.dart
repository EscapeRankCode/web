import 'package:flutter/material.dart';
import 'package:flutter_escaperank_web/models/bookings_layer/tickets/tickets_group.dart';

class TicketsGroupWidget extends StatelessWidget{

  final TicketsGroup ticketsGroup;

  TicketsGroupWidget(this.ticketsGroup);

  // TODO: CREATE the TICKETS GROUP WIDGET, that contains a list of tickets group
  @override
  Widget build(BuildContext context) {
    return Container(
      child: List.generate(ticketsGroup.tickets.length, (index){
        switch (ticketsGroup.tickets[index].ticket_type){

        }
      }),
    );
  }

}