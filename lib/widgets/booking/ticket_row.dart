import 'package:flutter/material.dart';
import 'package:flutter_escaperank_web/models/bookings_layer/tickets/ticket_info.dart';
import 'package:flutter_escaperank_web/utils/app_colors.dart';
import 'package:flutter_escaperank_web/utils/app_text_styles.dart';
import 'package:flutter_escaperank_web/widgets/text/standard_text.dart';


// ------------------ TICKET OPTION ----------------------
class TicketOptionData{
  final String ticket_name;
  final TicketInfoOption ticket_info;
  // Constructor
  TicketOptionData(this.ticket_name, this.ticket_info);
}

class TicketOption extends StatefulWidget {
  TicketOptionData ticket;
  bool Function(bool) onPressed;
  // Constructor
  TicketOption({
    Key? key,
    required this.onPressed,
    required this.ticket
  }) : super(key: key);

  @override
  _TicketOptionState createState() => _TicketOptionState();
}

class _TicketOptionState extends State<TicketOption> {
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
        )
      ),
    );
  }
}


// ------------------ TICKET CHECK ----------------------
class TicketCheckData{
  final String ticket_name;
  final TicketInfoCheck ticket_info;
  // Constructor
  TicketCheckData(this.ticket_name, this.ticket_info);
}

class TicketCheck extends StatefulWidget{
  TicketCheckData ticket;
  bool Function(bool) onPressed;
  // Constructor
  TicketCheck({
    Key? key,
    required this.onPressed,
    required this.ticket
  }) : super(key: key);

  @override
  _TicketCheckState createState() => _TicketCheckState();
}

class _TicketCheckState extends State<TicketCheck>{
  bool enabled = true;
  bool selected = false;

  @override
  void initState() {
    super.initState();
    selected = widget.ticket.ticket_info.default_value;
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: StandardText(
        colorText: AppTextStyles.bookingTicket.color!,
        text: widget.ticket.ticket_name,
        fontSize: AppTextStyles.bookingTicket.fontSize!,
        fontFamily: AppTextStyles.bookingTicket.fontFamily!,
        lineHeight: 1,
        align: TextAlign.center,
      ),
      tileColor: AppColors.blackBackGround,
      selectedTileColor: AppColors.yellowPrimary,
      checkColor: AppColors.yellowPrimary,
      activeColor: AppColors.white,
      selected: selected,
      value: selected,
      onChanged: (pressed){
        setState((){
          bool new_selected = widget.onPressed(pressed!);
          selected = new_selected;
        });
      }
    );
  }

}


// ------------------ TICKET COUNTER ----------------------
class TicketCounterData{
  final String ticket_name;
  final TicketInfoCounter ticket_info;
  // Constructor
  TicketCounterData(this.ticket_name, this.ticket_info);
}

class TicketCounter extends StatefulWidget {
  TicketCounterData ticket;
  int Function(int, int) onPressed; // previous new
  // Constructor
  TicketCounter({
    Key? key,
    required this.onPressed,
    required this.ticket
  }) : super(key: key);

  @override
  _TicketCounterState createState() => _TicketCounterState();

}

class _TicketCounterState extends State<TicketCounter>{
  bool enabled = true;
  int selected = 0;

  @override
  void initState() {
    super.initState();
    selected = widget.ticket.ticket_info.default_value;
  }

  @override
  Widget build(BuildContext context) {
    List<int> items = [];
    for (int i = widget.ticket.ticket_info.min_option; i <= widget.ticket.ticket_info.max_option; i++){
      items.add(i);
    }
    return Row(
      children: [
        StandardText(
          colorText: AppTextStyles.bookingTicket.color!,
          text: widget.ticket.ticket_name,
          fontSize: AppTextStyles.bookingTicket.fontSize!,
          fontFamily: AppTextStyles.bookingTicket.fontFamily!,
          lineHeight: 1,
          align: TextAlign.start,
        ),
        DropdownButton(
          items: items.map((int item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item.toString()),
            );
          }).toList(),

          onChanged: (int? new_value){
            int processed_value = widget.onPressed(selected, new_value!);
            setState(() {
              selected = processed_value;
            });
          },

          value: selected,

        )
      ],
    );
  }


}