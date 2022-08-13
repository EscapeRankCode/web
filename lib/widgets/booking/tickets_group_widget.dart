import 'package:flutter/material.dart';
import 'package:flutter_escaperank_web/models/bookings_layer/tickets/ticket.dart';
import 'package:flutter_escaperank_web/models/bookings_layer/tickets/ticket_info.dart';
import 'package:flutter_escaperank_web/models/bookings_layer/tickets/tickets_group.dart';
import 'package:flutter_escaperank_web/utils/bookings_layer_utils.dart';
import 'package:flutter_escaperank_web/widgets/booking/ticket_row.dart';

class TicketsGroupWidget extends StatelessWidget{

  final TicketsGroup ticketsGroup;

  TicketsGroupWidget(this.ticketsGroup);

  // TODO: CREATE the TICKETS GROUP WIDGET, that contains a list of tickets group
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,

      child: SingleChildScrollView(
        child: ListView.builder(
          itemCount: ticketsGroup.tickets.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {

            Ticket ticket = ticketsGroup.tickets[index];

            switch (ticket.ticket_type){
              case Ticket.CHECK: {
                return Text("Ticket check " + index.toString());
              }break;

              case Ticket.COUNTER: {
                return Text("Ticket counter " + index.toString());
              }break;

              case Ticket.OPTION: {
                TicketInfoOption ticketInfoOption = ticket.ticket_info as TicketInfoOption;

                return TicketOption(

                  onPressed: (pressed){
                    int new_option_units = 0;

                    if (pressed){
                      new_option_units = ticketsGroup.tickets_selection.option_selected_units + ticketInfoOption.single_unit_value;
                    }else{
                      new_option_units = ticketsGroup.tickets_selection.option_selected_units - ticketInfoOption.single_unit_value;
                    }

                    print("Max Units = " + ticketsGroup.total_rules.option_max_units.toString());
                    print("Min Units = " + ticketsGroup.total_rules.option_min_units.toString());
                    print("New Option Units = " + new_option_units.toString());

                    if (new_option_units > ticketsGroup.total_rules.option_max_units){
                      // TODO: SHOW ERROR
                      print("Error in new option units");
                      return !pressed;
                    }
                    else{
                      ticketsGroup.tickets_selection.option_selected_units = new_option_units;
                      print("All OK new option units");
                      return pressed;
                    }

                  },
                  ticket: TicketOptionData(
                      ticket.ticket_name,
                      ticketInfoOption
                  ),
                );
              }break;
            }

            return Text("Unknown ticket type");
          },
        ),
      ),
    );

  }

}