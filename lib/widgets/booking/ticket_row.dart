import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_escaperank_web/models/bookings_layer/tickets/ticket_info.dart';
import 'package:flutter_escaperank_web/utils/app_colors.dart';
import 'package:flutter_escaperank_web/utils/app_text_styles.dart';
import 'package:flutter_escaperank_web/widgets/text/standard_text.dart';

class TicketOptionData{
  final String ticket_name;
  final TicketInfoOption ticket_info;

  // Constructor
  TicketOptionData(this.ticket_name, this.ticket_info);
}

class TicketOption extends StatefulWidget {
  TicketOptionData ticket;

  bool Function(bool) onPressed;

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
        onTap: (){
          print("Ticket '" + widget.ticket.ticket_name + "' clicked");
          setState((){
            bool new_selected = widget.onPressed(!selected);
            selected = new_selected;
          });

        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Container(
            decoration: BoxDecoration(
                color: selected ? AppColors.yellowPrimary : AppColors.blackBackGround,
                borderRadius: const BorderRadius.all(Radius.circular(6)),
                border: Border.all(color: selected ? AppColors.yellowPrimary : AppColors.greyDark)
            ),
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: StandardText(
                  colorText: AppTextStyles.bookingTicket.color!,
                  text: widget.ticket.ticket_name,
                  fontSize: AppTextStyles.bookingTicket.fontSize!,
                  fontFamily: AppTextStyles.bookingTicket.fontFamily!,
                  lineHeight: 1,
                  align: TextAlign.center,
                )
              // Text(widget.ticket.ticket_name),
            ),
          ),
        ),
      ),
    );
  }
}