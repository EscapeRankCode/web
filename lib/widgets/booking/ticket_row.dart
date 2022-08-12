import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_escaperank_web/models/bookings_layer/tickets/ticket_info.dart';
import 'package:flutter_escaperank_web/utils/app_colors.dart';

class TicketOptionData{
  final String ticket_name;
  final TicketInfoOption ticket_info;

  // Constructor
  TicketOptionData(this.ticket_name, this.ticket_info);
}

class TicketOption extends StatefulWidget {
  TicketOptionData ticket;

  void Function(bool) onPressed;

  TicketOption(
      {Key? key,
        required this.onPressed,
        required this.ticket
      }
      ) : super(key: key);

  @override
  _TicketOptionState createState() => _TicketOptionState();
}

class _TicketOptionState extends State<TicketOption> {
  Color color = AppColors.greyDarkText;
  bool enabled = true;
  bool selected = false;

  @override
  void initState() {
    super.initState();
    selected = widget.ticket.ticket_info.default_value;
  }


  @override
  Widget build(BuildContext context) {

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        child: Text(widget.ticket.ticket_name),
        onTap: (){
          print("Ticket '" + widget.ticket.ticket_name + "' clicked");
          selected = !selected;
        },
      )// Text("WIDGET COMO EL RADIO LIST TILE, PERO PROPIO :/")
      /*
      ListTile(
        title: StandardText(
          text: widget.ticket.ticket_name,
          colorText: AppTextStyles.bookingTicket.color!,
          fontSize: AppTextStyles.bookingTicket.fontSize!,
          fontFamily: AppTextStyles.bookingTicket.fontFamily!,
          lineHeight: 1,
          align: TextAlign.start,
        ),
        onTap: (){
          selected = !selected;
          widget.onPressed(selected);
        },
      )
       */
    );
  }
}