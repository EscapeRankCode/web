import 'package:flutter/material.dart';
import 'package:flutter_escaperank_web/models/bookings_layer/calendar_simple_event.dart';
import 'package:flutter_escaperank_web/utils/app_colors.dart';
import 'package:flutter_escaperank_web/utils/bookings_layer_utils.dart';
import 'package:flutter_escaperank_web/widgets/text/standard_text.dart';

class SlotTime{
  bool selected;
  final CalendarSimpleEvent event;

  // Constructor
  SlotTime(this.selected, this.event);
}

class SlotTimeRow extends StatefulWidget {
  SlotTime slot;

  void Function(bool) onPressed;

  SlotTimeRow(
    {Key? key,
      required this.onPressed,
      required this.slot
    }
  ) : super(key: key);

  @override
  _SlotTimeRowState createState() => _SlotTimeRowState();
}

class _SlotTimeRowState extends State<SlotTimeRow> {
  Color color = AppColors.greyDarkText;
  bool enabled = true;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    void initStatus(){
      if(widget.slot.event.availability == BookingsLayerUtils.EVENT_AVAILABILITY_FREE){
        color = AppColors.whiteText;
        enabled = true;
      }else if(widget.slot.event.availability == BookingsLayerUtils.EVENT_AVAILABILITY_CLOSED){
        color = AppColors.primaryRed;
        enabled = false;
      }else if(widget.slot.event.availability == BookingsLayerUtils.EVENT_AVAILABILITY_CONSULT){
        color = AppColors.pinkPrimary;
        enabled = true;
      }else{
        color = AppColors.greyDarkText;
        enabled = false;
      }
    }
    initStatus();
    return GestureDetector(
      onTap: () {
        if(enabled) {
          widget.onPressed(!widget.slot.selected);
        }
      },
      child: Container(
          decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                  color: widget.slot.selected
                      ? widget.slot.event.availability == BookingsLayerUtils.EVENT_AVAILABILITY_FREE ? AppColors.yellowPrimary : color
                      : color),
              borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child:

          StandardText(
              fontSize: 13,
              text: widget.slot.event.time,
              fontFamily: "Kanit_Regular",
              colorText: widget.slot.selected
                  ? AppColors.yellowPrimary
                  : color,
              align: TextAlign.center, lineHeight: 1,)),
    );
  }
}