import 'package:checkbox_formfield/checkbox_formfield.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_escaperank_web/bloc/bookings_layer/calendar/calendar_bloc.dart';
import 'package:flutter_escaperank_web/bloc/bookings_layer/calendar/calendar_event.dart';
import 'package:flutter_escaperank_web/bloc/bookings_layer/calendar/calendar_state.dart';
import 'package:flutter_escaperank_web/models/bookings_layer/booking/booking_first_step_data.dart';
import 'package:flutter_escaperank_web/models/bookings_layer/calendar/calendar_day.dart';
import 'package:flutter_escaperank_web/models/bookings_layer/calendar/calendar_general.dart';
import 'package:flutter_escaperank_web/models/bookings_layer/calendar/calendar_simple_event.dart';
import 'package:flutter_escaperank_web/models/bookings_layer/form/event_form_data.dart';
import 'package:flutter_escaperank_web/models/bookings_layer/form/field.dart';
import 'package:flutter_escaperank_web/models/bookings_layer/form/field_option.dart';
import 'package:flutter_escaperank_web/models/bookings_layer/form/user_input.dart';
import 'package:flutter_escaperank_web/models/bookings_layer/tickets/ticket.dart';
import 'package:flutter_escaperank_web/models/bookings_layer/tickets/tickets_group.dart';
import 'package:flutter_escaperank_web/models/bookings_layer/tickets/tickets_selection.dart';
import 'package:flutter_escaperank_web/models/bookings_layer/tickets/total_rules.dart';
import 'package:flutter_escaperank_web/models/escape_room.dart';
import 'package:flutter_escaperank_web/services/calendar_service.dart';
import 'package:flutter_escaperank_web/utils/app_colors.dart';
import 'package:flutter_escaperank_web/utils/app_text_styles.dart';
import 'package:flutter_escaperank_web/widgets/booking/slot_time_row.dart';
import 'package:flutter_escaperank_web/widgets/booking/tickets_group_widget.dart';
import 'package:flutter_escaperank_web/widgets/buttons/standard_button.dart';
import 'package:flutter_escaperank_web/widgets/text/legend_circle.dart';
import 'package:flutter_escaperank_web/widgets/text/standard_text.dart';
import 'package:flutter_escaperank_web/widgets/text/title_circle.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel, WeekdayFormat;
import 'package:url_launcher/url_launcher.dart';

class BookingsWidget extends StatefulWidget{
  final EscapeRoom escapeRoom;

  BookingsWidget({required this.escapeRoom});

  @override
  _BookingsWidgetState createState() => _BookingsWidgetState(this.escapeRoom);
}

class _BookingsWidgetState extends State<BookingsWidget>{
  // Final fields
  final EscapeRoom escapeRoom;
  SharedPreferences? prefs;


  _BookingsWidgetState(this.escapeRoom);


  @override
  Widget build(BuildContext context) {
    getSharedPreferences();
    return Container(
      alignment: Alignment.center,
      child: BlocProvider<CalendarBloc>(
        create: (context) => CalendarBloc(CalendarService()),
        child: CalendarWidget(escapeRoom: escapeRoom),
      ),
    );
  }


  void getSharedPreferences() async{
    prefs = await SharedPreferences.getInstance();
  }
}

class CalendarWidget extends StatefulWidget{
  final EscapeRoom escapeRoom;

  CalendarWidget({required this.escapeRoom}) : super();

  @override
  CalendarWidgetState createState() => CalendarWidgetState();
}

class CalendarWidgetState extends State<CalendarWidget>{

  DateTime now_datetime = DateTime.now();
  DateTime _targetDateTime = DateTime.now();

  String initial_day_month = "";
  String final_day_month = "";

  ScrollController _scrollController = ScrollController();
  DateTime _currentDate = DateTime.now();
  DateTime _currentDate2 = DateTime.now();
  String _currentMonth = DateFormat.MMMM("es_ES").format(DateTime.now()).toUpperCase();

  late SharedPreferences prefs;
  var _calendarBloc;
  double heightCalendar = 340;
  double widthCalendar = 340;

  // PHASE 1: CALENDAR AND EVENTD
  List<CalendarSimpleEvent> slotsEvents = [];
  CalendarGeneral? visibleCalendar;
  late String timezone;
  List<SlotTime> slotsSelected = [];

  // SELECTED EVENT
  SlotTime? selectedSlot;
  CalendarSimpleEvent? selectedEvent; // selected event

  // PHASE 2
  List<TicketsGroup>? eventTicketsGroups; // tickets and selections
  List<Ticket>? eventTickets;
  bool enable_step_phase_3 = false;

  // PHASE 3
  EventFormData? _formData;
  final _formKey = GlobalKey<FormState>();
  Map<String, String> field_options_selected = {}; // where key is field_key
  List<Field> manual_validate_fields = [];
  Map<String, bool> validations = {};

  BookingFirstStepData? bookingFirstStepData;


  int _phase = 1;

  
  @override
  void initState() {
    super.initState();
    // Initial days
    initial_day_month = DateFormat('dd/MM/yyyy').format(DateTime(now_datetime.year, now_datetime.month, 1));
    final_day_month = DateFormat('dd/MM/yyyy').format(DateTime(now_datetime.year, now_datetime.month+1, 0));

    // Load events of the actual month
    loadEvents(
      initial_day_month,
      final_day_month
    );

    slotsSelected = [];

    // Check actual month weeks length
    var month = DateTime(DateTime.now().year, DateTime.now().month, 1);
    setState(() {
      heightCalendar = month.weekday >= 6 ? 340 : 290;
    });

    enable_step_phase_3 = false;

  }

  void loadEvents(String startDate, String endDate) async {
    // prefs = await SharedPreferences.getInstance(); TODO: ONLY SHOW WHEN USER IS LOGGED
    _calendarBloc = BlocProvider.of<CalendarBloc>(context);
    _calendarBloc.add(GetCalendar(
        escape_id: widget.escapeRoom.id,
        start_date: startDate,
        end_date: endDate
    ));
  }

  void _selectTime(SlotTime slot){
    selectedSlot = slot;
    _calendarBloc.add(
      GetTickets(
        event_date: DateFormat('dd/MM/yyyy').format(_currentDate2),
        event_time: selectedSlot!.event.time,
        booking_system_id: widget.escapeRoom.bookingSystemId!,
        bs_config: widget.escapeRoom.bsConfigId!,
        event_id: selectedSlot!.event.eventId
      )
    );
  }

  void _selectTickets(){
    _calendarBloc.add(
      GetForm(
          booking_system_id: widget.escapeRoom.bookingSystemId!,
          bs_config: widget.escapeRoom.bsConfigId!,
          event_date: DateFormat('dd/MM/yyyy').format(_currentDate2),
          event_time: selectedSlot!.event.time,
          event_id: selectedSlot!.event.eventId,
          event_tickets: eventTicketsGroups!
      )
    );
  }

  void _book_first_step(){
    _calendarBloc.add(
        BookingFirstStep(
          booking_system_id: widget.escapeRoom.bookingSystemId!,
          bs_config: widget.escapeRoom.bsConfigId!,
          event_date: DateFormat('dd/MM/yyyy').format(_currentDate2),
          event_time: selectedSlot!.event.time,
          event_id: selectedSlot!.event.eventId,
          event_tickets: eventTicketsGroups!,
          event_fields: _formData!.fields
        )
    );
  }

  @override
  Widget build(BuildContext context) {

    /// Example Calendar Carousel without header and custom prev & next button
    final _calendarCarouselNoHeader = CalendarCarousel<Event>(

      onDayPressed: (date, events) {
        setState(() => _currentDate2 = date);
        print(_currentDate2);
        checkSlots(date);
      },
      weekdayTextStyle: const TextStyle(
        fontSize: 16,
        color: AppColors.yellowPrimary,
        fontFamily: "Kanit_Thin",
      ),
      locale: "es_ES",
      weekDayFormat: WeekdayFormat.narrow,
      showOnlyCurrentMonthDate: false,
      thisMonthDayBorderColor: Colors.grey,
      weekFormat: false,
      firstDayOfWeek: 1,
      height: heightCalendar,
      width: widthCalendar,
      selectedDateTime: _currentDate2,
      targetDateTime: _targetDateTime,
      isScrollable: false,
      customGridViewPhysics: const NeverScrollableScrollPhysics(),
      markedDateCustomShapeBorder: const CircleBorder(side: BorderSide(color: AppColors.yellowPrimary)),
      markedDateCustomTextStyle: const TextStyle(
        fontSize: 16,
        color: AppColors.yellowPrimary,
        fontFamily: "Kanit_Regular",
      ),
      showHeader: false,
      todayTextStyle: const TextStyle(
        color: AppColors.primaryYellow20,
      ),
      todayButtonColor: Colors.transparent,
      selectedDayButtonColor: AppColors.primaryYellow30,
      selectedDayTextStyle: const TextStyle(
        fontSize: 16,
        color: AppColors.yellowPrimary,
        fontFamily: "Kanit_Regular",
      ),
      minSelectedDate: _currentDate.subtract(const Duration(days: 1)),
      maxSelectedDate: _currentDate.add(const Duration(days: 360)),
      daysTextStyle: const TextStyle(
        fontSize: 16,
        color: AppColors.whiteText,
        fontFamily: "Kanit_Regular",
      ),
      weekendTextStyle: const TextStyle(
        fontSize: 16,
        color: AppColors.whiteText,
        fontFamily: "Kanit_Regular",
      ),
      inactiveWeekendTextStyle: const TextStyle(
        fontSize: 16,
        color: AppColors.greyText,
        fontFamily: "Kanit_Regular",
      ),
      inactiveDaysTextStyle: const TextStyle(
        fontSize: 16,
        color: AppColors.greyText,
        fontFamily: "Kanit_Regular",
      ),
      onCalendarChanged: (DateTime date) {
        setState(() {
          _targetDateTime = date;
          _currentMonth = DateFormat.MMMM("es_ES").format(_targetDateTime).toUpperCase();
          // now we load the next month 1st events
          _currentDate2 = DateTime(date.year, date.month, 1);
          DateTime date1 = DateTime(date.year, date.month, 1);
          DateTime date2 = DateTime(date.year, date.month + 1, 0);

          loadEvents(
            DateFormat('dd/MM/yyyy').format(date1),
            DateFormat('dd/MM/yyyy').format(date2)
          );
          // checkSlots(_currentDate2);
        });
      },
    );
    
    final _timesRow = Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StandardText( // FlutterI18n.translate(context, "times_title"),
                fontSize: AppTextStyles.bookingTimesRowTitle.fontSize!,
                text: FlutterI18n.translate(context, "times_title") + DateFormat('dd/MM/yyyy').format(_currentDate2),
                fontFamily: AppTextStyles.bookingTimesRowTitle.fontFamily!,
                colorText: AppTextStyles.bookingTimesRowTitle.color!,
                align: TextAlign.start, lineHeight: 1
            ),
            const SizedBox(height: 8),

            // If there are times now we show times, if not we show a message
            slotsSelected.isEmpty ?
            StandardText(
                fontSize: AppTextStyles.bookingTimesRowEmpty.fontSize!,
                text: FlutterI18n.translate(context, "times_empty"),
                fontFamily: AppTextStyles.bookingTimesRowEmpty.fontFamily!,
                colorText: AppTextStyles.bookingTimesRowEmpty.color!,
                align: TextAlign.start, lineHeight: 1.5
            ) : // Text = NO HAY HORAS
            Wrap( // LISTA DE HORAS
              direction: Axis.horizontal,
              spacing: 10,
              runSpacing: 12,
              alignment: WrapAlignment.start,
              children: List.generate(slotsSelected.length, (index){
                return SlotTimeRow(
                  slot: slotsSelected[index],
                  onPressed: (pressed) {
                    _selectTime(slotsSelected[index]); // Jumps to get tickets (in bloc)
                  },
                );
              }),
            )
          ],
        ),
      ),
    );


    // PHASES WIDGETS
    // PHASE 0 (LOADING CALENDAR)
    var _booking_phase_0 = Text("PHASE 0");
    // PHASE 1 (SELECT DAY AND TIME)
    var _booking_phase_1 = Column(
      children: [
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: AppColors.greyText),
              onPressed: (){
                setState((){
                  var last_day_date = DateTime(_targetDateTime.year, _targetDateTime.month, 0);
                  _targetDateTime = DateTime(_targetDateTime.year, _targetDateTime.month - 1);
                  _currentMonth = DateFormat.MMMM("es_ES").format(_targetDateTime).toUpperCase();
                  String _startDate = "01/" + _targetDateTime.month.toString() + "/" + _targetDateTime.year.toString();
                  String _endDate = last_day_date.day.toString() + "/" + _targetDateTime.month.toString() + "/" + _targetDateTime.year.toString();
                  loadEvents(
                      _startDate,
                      _endDate
                  );
                  var month = DateTime(_targetDateTime.year, _targetDateTime.month, 1);
                  setState(() {
                    heightCalendar = _targetDateTime.weekday >= 6 ? 340 : 290;
                  });
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: StandardText(
                colorText: AppColors.whiteText,
                fontFamily: AppTextStyles.escapeDetailCompanyBrandName.fontFamily!,
                fontSize: 16,
                text: _currentMonth.toUpperCase(),
                align: TextAlign.center,
                lineHeight: 1,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios, color: AppColors.greyText),
              onPressed: (){
                setState((){
                  var last_day_date = DateTime(_targetDateTime.year, _targetDateTime.month + 2, 0);
                  _targetDateTime = DateTime(_targetDateTime.year, _targetDateTime.month + 1);
                  // _currentMonth = DateFormat.MMMM("es_ES").format(_targetDateTime).toUpperCase();
                  String _startDate = "01/" + _targetDateTime.month.toString() + "/" + _targetDateTime.year.toString();
                  String _endDate = last_day_date.day.toString() + "/" + _targetDateTime.month.toString() + "/" + _targetDateTime.year.toString();
                  loadEvents(
                      _startDate,
                      _endDate
                  );
                  var month = DateTime(_targetDateTime.year, _targetDateTime.month, 1);
                  setState(() {
                    heightCalendar = _targetDateTime.weekday >= 6 ? 340 : 290;
                    _currentMonth = DateFormat.MMMM("es_ES").format(_targetDateTime).toUpperCase();
                  });
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        _calendarCarouselNoHeader,
        _timesRow,
      ],
    );
    // PHASE 2 (SELECT TICKET)
    var _booking_phase_2 = Column(
      children: [
        const SizedBox(height: 12),
        eventTicketsGroups == null ?

          StandardText(
            colorText: AppTextStyles.bookingTicket.color!,
            text: "Error, tickets not found!",
            fontSize: AppTextStyles.bookingTicket.fontSize!,
            fontFamily: AppTextStyles.bookingTicket.fontFamily!,
            lineHeight: 1,
            align: TextAlign.start
          ) : // TODO: When error

        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                StandardText(
                  text: FlutterI18n.translate(context, "num_players"),
                  fontFamily: AppTextStyles.bookingTicketsTitle.fontFamily!,
                  fontSize: AppTextStyles.bookingTicketsTitle.fontSize!,
                  colorText: AppTextStyles.bookingTicketsTitle.color!,
                  align: TextAlign.start,
                  lineHeight: 1,
                ),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: eventTicketsGroups!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 12
                        ),
                        child: TicketsGroupWidget(
                            eventTicketsGroups![index], (){
                              print("RUNNING RULES CHECK");
                              // TicketsSelection tickets_selection = TicketsSelection();
                              for (int i = 0; i < eventTicketsGroups!.length; i++){
                                bool selectionOk = check_group_selection(eventTicketsGroups![i]);
                                if(!selectionOk){
                                  super.setState(() {
                                    enable_step_phase_3 = false;
                                  });
                                  print("RULES CHECK - FALSE");
                                  return;
                                }
                              }
                              super.setState((){
                                enable_step_phase_3 = true;
                              });
                              print("RULES CHECK - OK");
                            }
                        ),
                      );
                    }
                )
              ],
            ),
            const SizedBox(height: 12),
            enable_step_phase_3 ?
            StandardButton(
                colorButton: enable_step_phase_3 ? AppColors.yellowPrimary : AppColors.primaryYellow30,
                standardText: StandardText(
                  text: FlutterI18n.translate(context, "next"),
                  fontFamily: "Kanit_Medium",
                  fontSize: 18,
                  colorText: AppColors.white, align: TextAlign.center, lineHeight: 1,
                ),
                onPressed: (){
                  _selectTickets();
                }
            ) :
            StandardDisabledButton(
              colorButton: enable_step_phase_3 ? AppColors.yellowPrimary : AppColors.primaryYellow30,
              standardText: StandardText(
                text: FlutterI18n.translate(context, "next"),
                fontFamily: "Kanit_Medium",
                fontSize: 18,
                colorText: AppColors.white, align: TextAlign.center, lineHeight: 1,
              ),
            )
          ],
        ),
      ],
    );

    var _booking_phase_3 = Column(
      children: [
        const SizedBox(height: 12),

        _formData == null ?

        StandardText(
          colorText: AppTextStyles.bookingTicket.color!,
          text: "Error, form not found!",
          fontSize: AppTextStyles.bookingTicket.fontSize!,
          fontFamily: AppTextStyles.bookingTicket.fontFamily!,
          lineHeight: 1,
          align: TextAlign.start
        ) : // TODO: When error

        Form(
          key: _formKey,
          child: Column(
            children: [
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: _formData!.fields.length,
                  itemBuilder: (context, index) {

                    Field field = _formData!.fields[index];
                    var field_widget;

                    switch (field.field_type){

                      case Field.FIELD_TYPE_CHECK:
                        field_widget = CheckboxListTileFormField(
                          title: Linkify(
                            text: field.field_text,
                            onOpen: (link) async{
                              if (await canLaunch(link.url)){
                                await launch(link.url);
                              }else{
                                throw 'Could not launch $link';
                              }
                            },
                            style: AppTextStyles.bookingFormTextInput_Label,
                            linkStyle: AppTextStyles.bookingFormTextInput_Title,
                          ),
                          validator: (value){
                            if (field.user_input == null){
                              field.user_input = UserInput(
                                user_input_text: field.field_text,
                                user_input_value: field.field_text,
                                user_input_others_map: {
                                  "checked": value
                                }
                              );
                            }else{
                              field.user_input!.user_input_others_map = {
                                "checked": value
                              };
                            }
                            if (field.field_required && !value!){
                              return FlutterI18n.translate(context, "form_error_cehck_not_checked");
                            }
                            return null;
                          },
                          checkColor: AppColors.whiteText,
                          activeColor: AppColors.yellowPrimary,
                        );
                        break;

                      case Field.FIELD_TYPE_TEXT:
                        field_widget = TextFormField(
                          // Decoration
                          decoration: InputDecoration(
                            labelText: field.field_required ? field.field_text + " *" : field.field_text,
                            labelStyle: AppTextStyles.bookingFormTextInput_Title,
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: AppColors.whiteText),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: AppColors.yellowPrimary),
                            ),
                          ),
                          cursorColor: AppColors.yellowPrimary,
                          style: AppTextStyles.bookingFormTextInput_Label,
                          // Validator
                          validator: (value) {
                            if (field.user_input == null){
                              field.user_input = UserInput(
                                  user_input_text: field.field_text,
                                  user_input_value: value!,
                                  user_input_others_map: {}
                              );
                            }else{
                              field.user_input!.user_input_value = value!;
                            }
                            if ((value == null || value.isEmpty) && field.field_required) {
                              return FlutterI18n.translate(context, "form_error_empty_text");
                            }
                            return null;
                          },


                        );
                        break;

                      case Field.FIELD_TYPE_NUMBER:
                        field_widget = TextFormField(
                          // Decoration
                          decoration: InputDecoration(
                            labelText: field.field_required ? field.field_text + " *" : field.field_text,
                            labelStyle: AppTextStyles.bookingFormTextInput_Title,
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: AppColors.whiteText),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: AppColors.yellowPrimary),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          cursorColor: AppColors.yellowPrimary,
                          style: AppTextStyles.bookingFormTextInput_Label,
                          // Validator
                          validator: (value) {
                            if (field.user_input == null){
                              field.user_input = UserInput(
                                  user_input_text: field.field_text,
                                  user_input_value: value!,
                                  user_input_others_map: {}
                              );
                            }else{
                              field.user_input!.user_input_value = value!;
                            }
                            if ((value == null || value.isEmpty) && field.field_required) {
                              return FlutterI18n.translate(context, "form_error_empty_text");
                            }
                            return null;
                          },


                        );
                        break;

                      case Field.FIELD_TYPE_SELECT:
                        if(!manual_validate_fields.contains(field)){
                          manual_validate_fields.add(field); // add this field to manual validate
                          validations[field.field_key] = true;
                        }

                        field_widget = Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DropdownButton(
                              value: field_options_selected[field.field_key] == null ? null : field_options_selected[field.field_key]!,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              dropdownColor: AppColors.yellowPrimary,

                              hint: StandardText(
                                text: FlutterI18n.translate(context, "form_hint_select_option"),
                                colorText: AppTextStyles.bookingFormTextInput_Hint.color!,
                                fontSize: AppTextStyles.bookingFormTextInput_Hint.fontSize!,
                                fontFamily: AppTextStyles.bookingFormTextInput_Hint.fontFamily!,
                                lineHeight: 1,
                                align: TextAlign.start,
                              ),

                              items: field.field_options!.map((FieldOption option){
                                return DropdownMenuItem(
                                  value: option.option_text,
                                  child: StandardText(
                                    text: option.option_text,
                                    colorText: AppTextStyles.bookingFormTextInput_Label.color!,
                                    fontSize: AppTextStyles.bookingFormTextInput_Label.fontSize!,
                                    fontFamily: AppTextStyles.bookingFormTextInput_Label.fontFamily!,
                                    lineHeight: 1,
                                    align: TextAlign.start,
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue){

                                List<FieldOption> options = field.field_options!;
                                FieldOption? option_selected = null;
                                for (int i = 0; i < options.length; i++){
                                  if (options[i].option_text == newValue){
                                    option_selected = options[i];
                                    break;
                                  }
                                }
                                if (field.user_input == null){
                                  field.user_input = UserInput(
                                      user_input_text: field.field_text,
                                      user_input_value: field.field_text,
                                      user_input_others_map: option_selected == null ?
                                      {
                                        "option_selected_text": null,
                                        "option_selected_value": null
                                      } :
                                      {
                                        "option_selected_text": option_selected.option_text,
                                        "option_selected_value": option_selected.option_value
                                      }
                                  );
                                }else{
                                  field.user_input!.user_input_others_map = option_selected == null ?
                                  {
                                    "option_selected_text": null,
                                    "option_selected_value": null
                                  } :
                                  {
                                    "option_selected_text": option_selected.option_text,
                                    "option_selected_value": option_selected.option_value
                                  };
                                }

                                setState((){
                                  if (field_options_selected[field.field_key] == null){
                                    field_options_selected[field.field_key] = newValue!;
                                  }else{
                                    field_options_selected.update(field.field_key, (value) => newValue!);
                                  }
                                  // _selectedOption = newValue;
                                });
                              }
                            ),

                            // Error message if validation is wrong
                            validations[field.field_key] == false ?
                              StandardText(
                                colorText: AppTextStyles.bookingFormOptionErrorMsg.color!,
                                text: FlutterI18n.translate(context, "form_hint_select_option"),
                                fontSize: AppTextStyles.bookingFormOptionErrorMsg.fontSize!,
                                fontFamily: AppTextStyles.bookingFormOptionErrorMsg.fontFamily!,
                                lineHeight: 1,
                                align: TextAlign.start
                              ) :
                              SizedBox.shrink(),

                          ],
                        );
                        break;

                      case Field.FIELD_TYPE_DATE:
                        field_widget = DateTimeField(
                          format: DateFormat('dd/MM/yyyy'),
                          onShowPicker: (context, currentValue) async {
                            return showDatePicker(
                              context: context,
                              initialDate: currentValue ?? DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: const ColorScheme.light(
                                      primary: AppColors.blackBackGround,
                                      onPrimary: AppColors.yellowPrimary,
                                      onSurface: AppColors.yellowPrimary,
                                    ),
                                    textButtonTheme: TextButtonThemeData(
                                      style: TextButton.styleFrom(
                                        primary: AppColors.yellowPrimary,
                                      ),

                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                          },
                          validator: (date) {
                            final DateFormat formatter = DateFormat('dd/MM/yyyy');
                            if (field.user_input == null){
                              field.user_input = UserInput(
                                  user_input_text: field.field_text,
                                  user_input_value: formatter.format(date!),
                                  user_input_others_map: {}
                              );
                            }else{
                              field.user_input!.user_input_value = formatter.format(date!);
                            }
                            if (date == null && field.field_required) {
                              return FlutterI18n.translate(context, "form_error_empty_date");
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: field.field_required ? field.field_text + " *" : field.field_text,
                            labelStyle: AppTextStyles.bookingFormTextInput_Title,
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: AppColors.whiteText),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: AppColors.yellowPrimary),
                            ),
                          ),
                          style: AppTextStyles.bookingFormTextInput_Label,
                        );
                        break;

                      default:
                        field_widget = Text(field.field_text);
                        break;
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 12
                      ),
                      child: field_widget,
                    );
                  }
              ),

              const SizedBox(height: 20),

              true ? // enable_step_phase_4 ?
              StandardButton(
                  colorButton: enable_step_phase_3 ? AppColors.yellowPrimary : AppColors.primaryYellow30,
                  standardText: StandardText(
                    text: FlutterI18n.translate(context, "next"),
                    fontFamily: "Kanit_Medium",
                    fontSize: 18,
                    colorText: AppColors.white, align: TextAlign.center, lineHeight: 1,
                  ),
                  onPressed: (){
                    bool all_validations = true;
                    // Manual validations
                    for (int i = 0; i < manual_validate_fields.length; i++){
                      // Check every field that has to be validated manually
                      Field field = manual_validate_fields[i];
                      if (field.field_required){
                        setState((){
                          // there is no option selected (ERROR)
                          if (field_options_selected[field.field_key] == null){
                            all_validations &= false; // not all validations are ok
                            validations.update(field.field_key, (value) => false);
                            print("Validation <" + field.field_key + "> failed.");
                            /* if (validations[field.field_key] == null){
                                validations[field.field_key] = false;
                              }else{
                                validations.update(field.field_key, (value) => false);
                              } */
                          }
                          // option is selected (OK)
                          else{
                            validations.update(field.field_key, (value) => true);
                            /* if (validations[field.field_key] == null){
                                validations[field.field_key] = true;
                              }else{
                                validations.update(field.field_key, (value) => true);
                              } */
                          }
                        });
                      }
                    }

                    // From auto validation
                    if (_formKey.currentState!.validate()){

                      // All validations ok?
                      if (all_validations){
                        print("Form data is OK, sending data to pre-book");
                        // NEXT PHASE
                        _book_first_step(); // SEND THE DATA TO MAKE THE BOOKING
                        setState((){
                          _phase = 4;
                        });

                      }
                      else{
                        print("Form data is not OK");

                      }

                    }else{
                      print("Form data is not OK");
                    }
                  }
              ) :
              StandardDisabledButton(
                colorButton: enable_step_phase_3 ? AppColors.yellowPrimary : AppColors.primaryYellow30,
                standardText: StandardText(
                  text: FlutterI18n.translate(context, "next"),
                  fontFamily: "Kanit_Medium",
                  fontSize: 18,
                  colorText: AppColors.white, align: TextAlign.center, lineHeight: 1,
                ),
              )

            ],
          ),
        )
      ],
    );


    return BlocListener<CalendarBloc, CalendarState>(listener: (context, state) {

      // PHASE 1 -------
      if (state is CalendarLoading){
        print("Calendar Loading state");
        setState((){
          _phase = 0; // Calendar is loading TODO: LOADING WIDGET
        });
      }

      if (state is CalendarLoadedSuccess) {
        // timezone = state.calendarAvailability.data.calendar.timezone;
        var days = state.calendarAvailability.data.calendar.days;
        slotsEvents.clear();
        slotsSelected.clear();
        visibleCalendar = state.calendarAvailability.data.calendar;

        // slotsEvents = state.calendarAvailability.data.calendar.days[0].events; // TODO: #Invented
        print("Calendar Loaded Success state");

        setState((){
          _phase = 1; // Calendar has been loaded
          checkSlots(_currentDate2);
        });
      }

      if (state is CalendarLoadedFailure) {
        setState((){
          // _phase = 0; // Calendar error: TODO: how do we know what to show
        });
        print("Calendar Loading Failure state");
      }

      // PHASE 2 -------
      if (state is CalendarEventTicketsLoading){
        print("Event Tickets Loading state");
        setState((){
          // _phase = 0; // Event Tickets are loading TODO: LOADING WIDGET
        });
      }

      if (state is CalendarEventTicketsLoadedSuccess){
        print("Event Tickets Loaded Successfully");
        setState((){
          _phase = 2;
          print(state.eventTickets.toJsonString());
          eventTicketsGroups = state.eventTickets.data.tickets_groups;
          if (eventTicketsGroups == null){
            print("Groups is null");
          }
          print("Groups is not null");
          print("Groups length: " + eventTicketsGroups!.length.toString());
          for (int i = 0; i < eventTicketsGroups!.length; i++){
            print("Groups " + i.toString());
            for (int j = 0; j < eventTicketsGroups![i].tickets.length; j++){
              print("Ticket name: " + eventTicketsGroups![i].tickets[j].ticket_name);
            }
          }
        });
      }

      if (state is CalendarEventTicketsLoadedFailure){
        print("event Tickets Loaded Failure");
      }

      // PHASE 3 -------
      if (state is CalendarEventFormLoading){
        print("Event Form Loading");
      }

      if (state is CalendarEventFormLoadedSuccess){
        setState((){
          _phase = 3;
          // print(state.eventForm.toJsonString());
          _formData = state.eventForm.data;
          // eventTicketsGroups = state.eventTickets.data.tickets_groups;
          if (_formData == null){
            print("Form is null");
          }
          print("Form is not null");
          print("Form Fields length: " + _formData!.fields.length.toString());
          for (int i = 0; i < _formData!.fields.length; i++){
            print("Field " + i.toString());
            print("Field name: " + _formData!.fields[i].field_text);
          }
        });
      }

      if (state is CalendarEventFormLoadedFailure){
        print("Event Form Loaded Failure");
      }

      // PHASE 4 ------

    } , child: BlocBuilder<CalendarBloc, CalendarState>(builder: (context, state) {
      return SizedBox(
        width: 400,
        child: Container(
          decoration: BoxDecoration(
              color: AppColors.blackBackGround,
              borderRadius: const BorderRadius.all(Radius.circular(30)), // .only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              border: Border.all(color: AppColors.yellowPrimary)

          ),
          /*
          child: Column(
            children: [
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: AppColors.greyText),
                    onPressed: (){
                      setState((){
                        var last_day_date = DateTime(_targetDateTime.year, _targetDateTime.month, 0);
                        _targetDateTime = DateTime(_targetDateTime.year, _targetDateTime.month - 1);
                        _currentMonth = DateFormat.MMMM("es_ES").format(_targetDateTime).toUpperCase();
                        String _startDate = "01/" + _targetDateTime.month.toString() + "/" + _targetDateTime.year.toString();
                        String _endDate = last_day_date.day.toString() + "/" + _targetDateTime.month.toString() + "/" + _targetDateTime.year.toString();
                        loadEvents(
                            _startDate,
                            _endDate
                        );
                        var month = DateTime(_targetDateTime.year, _targetDateTime.month, 1);
                        setState(() {
                          heightCalendar = _targetDateTime.weekday >= 6 ? 340 : 290;
                        });
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: StandardText(
                      colorText: AppColors.whiteText,
                      fontFamily: AppTextStyles.escapeDetailCompanyBrandName.fontFamily!,
                      fontSize: 16,
                      text: _currentMonth.toUpperCase(),
                      align: TextAlign.center,
                      lineHeight: 1,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, color: AppColors.greyText),
                    onPressed: (){
                      setState((){
                        var last_day_date = DateTime(_targetDateTime.year, _targetDateTime.month + 2, 0);
                        _targetDateTime = DateTime(_targetDateTime.year, _targetDateTime.month + 1);
                        // _currentMonth = DateFormat.MMMM("es_ES").format(_targetDateTime).toUpperCase();
                        String _startDate = "01/" + _targetDateTime.month.toString() + "/" + _targetDateTime.year.toString();
                        String _endDate = last_day_date.day.toString() + "/" + _targetDateTime.month.toString() + "/" + _targetDateTime.year.toString();
                        loadEvents(
                            _startDate,
                            _endDate
                        );
                        var month = DateTime(_targetDateTime.year, _targetDateTime.month, 1);
                        setState(() {
                          heightCalendar = _targetDateTime.weekday >= 6 ? 340 : 290;
                          _currentMonth = DateFormat.MMMM("es_ES").format(_targetDateTime).toUpperCase();
                        });
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _calendarCarouselNoHeader,
              _timesRow,

              // HORAS SELECCIONADAS
              /*
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  slotsSelected.isNotEmpty
                      ? GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 1.5,
                    shrinkWrap: true,
                    crossAxisCount: 4,
                    children: List.generate(slotsSelected.length, (index) {
                      return Center(
                        child: SlotTimeRow(
                          onPressed: (selected) {
                            setState(() {
                              for (int i = 0; i < slotsSelected.length; i++) {
                                slotsSelected[i].selected = false;
                              }
                              slotsSelected[index].selected = selected;
                            });
                          },
                          slot: slotsSelected[index],
                        ),
                      );
                    }),
                  ) : Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: StandardText(
                      colorText: AppColors.whiteText,
                      fontFamily: "Kanit_Regular",
                      fontSize: 16,
                      text: noSlotsDay, lineHeight: 1, align: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),
                  LegendCircle(
                      color: AppColors.primaryRed,
                      text: FlutterI18n.translate(
                          context, "hour_closed")),
                  LegendCircle(
                      color: AppColors.greyDarkText,
                      text: FlutterI18n.translate(
                          context, "hour_no_available")),
                  LegendCircle(
                      color: AppColors.pinkPrimary,
                      text: FlutterI18n.translate(
                          context, "hour_consult")),
                  LegendCircle(
                      color: AppColors.whiteText,
                      text: FlutterI18n.translate(
                          context, "hour_available")),
                  LegendCircle(
                      color: AppColors.yellowPrimary,
                      text: FlutterI18n.translate(
                          context, "hour_selected")),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
          slotBooking != 0
              ? StandardButton(
              colorButton: AppColors.yellowPrimary,
              standardText: StandardText(
                text: FlutterI18n.translate(context, "next"),
                fontFamily: "Kanit_Medium",
                fontSize: 18,
                colorText: AppColors.white, align: TextAlign.center, lineHeight: 1,
              ),
              onPressed: () {
                // TODO: HA PRESIONADO EL BOTÓN DE SIGUIENTE
                /*
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (BuildContext context) =>
                                        TicketsPage(
                                            escape: widget.escape,
                                            slotBooking: slotBooking,
                                            timezone: timezone,
                                            maxSeats: maxSeatsLeft,
                                            minSeatsBuy: minSeatsBuy)));
                             */
              })
              : StandardButton(
              colorButton: AppColors.primaryYellow30,
              standardText: StandardText(
                text: FlutterI18n.translate(context, "next"),
                fontFamily: "Kanit_Medium",
                fontSize: 18,
                colorText: AppColors.white, align: TextAlign.center, lineHeight: 1,
              ),
              onPressed: () {}),
           */
            ],
          ),
           */
          child: _phase == 0 ? _booking_phase_0 :
          _phase == 1 ? _booking_phase_1 :
          _phase == 2 ? _booking_phase_2 :
          _phase == 3 ? _booking_phase_3 : Text("Phase X"),
        )
      );


    }));
  }

  bool check_group_selection(TicketsGroup ticketsGroup){
    TotalRules rules = ticketsGroup.total_rules;
    TicketsSelection selection = ticketsGroup.tickets_selection;
    bool counterOk = selection.counter_selected_units >= rules.counter_min_units && selection.counter_selected_units <= rules.counter_max_units;
    bool checkOk = selection.check_selected_units >= rules.check_min_units && selection.check_selected_units <= rules.check_max_units;
    bool optionOk = selection.option_selected_units >= rules.option_min_units && selection.option_selected_units <= rules.option_max_units;
    print("SLECTION VS RULES");
    print("Counter: selected (" + selection.counter_selected_units.toString() + ") - min (" + rules.counter_min_units.toString() + ") - max (" + rules.counter_max_units.toString() + ")");
    print("Check: selected (" + selection.check_selected_units.toString() + ") - min (" + rules.check_min_units.toString() + ") - max (" + rules.check_max_units.toString() + ")");
    print("Option: selected (" + selection.option_selected_units.toString() + ") - min (" + rules.option_min_units.toString() + ") - max (" + rules.option_max_units.toString() + ")");
    return counterOk && checkOk && optionOk;
  }


  bool isSameDate(DateTime date1, DateTime date2){
    if (date1.year == date2.year && date1.month == date2.month && date1.day == date2.day){
      return true;
    }
    return false;
  }


  void checkSlots(DateTime selectedDate) async {
    setState(() {
      slotsSelected.clear();
    });

    CalendarDay? dayFound;

    if (visibleCalendar != null){
      for (CalendarDay day in visibleCalendar!.days){
        if (isSameDate(selectedDate, DateTime(day.year, day.month, day.day))){
          dayFound = day;
          break;
        }
      }

      if (dayFound != null){
        print("Events of the day (" + selectedDate.day.toString() + "-" + selectedDate.month.toString() + "-" + selectedDate.year.toString() + "):");
        // Cargamos los slots disponibles en la row
        for (CalendarSimpleEvent event in dayFound.events){
          slotsSelected.add(SlotTime(false, event));
          print(event.time + " ... ");
        }


      }else{
        print("Day not found in calendar");
      }

    }else{
      // Todo, poner mensaje de que no hay slots
      print("Calendar is null");
    }

    setState((){});

    // Cargar en slotsSelected los slots del dia en cuestión

    /*
    slotBooking = 0;
    noSlotsDay = slotsEvents.isNotEmpty ? FlutterI18n.translate(context, "no_slots_day") : ""; // TODO: REVIEW ISEMPTY
    // tz.initializeTimeZones();
    // final timeZoneSlot = tz.getLocation(timezone);
    for (int i = 0; i < slotsEvents.length; i++) {
      var date = DateTime.fromMillisecondsSinceEpoch(slotsEvents[i].time * 1000);
      if (_currentDate2.day == date.day) {
        setState(() {
          slotsSelected.add(SlotTime(false, CalendarSimpleEvent())); // TODO
          slotsSelected.add(SlotTuritop(false,
              timestamp: slotsEvents[i].time,
              hour: DateFormat("HH:mm").format(tz.TZDateTime.from(date, timeZoneSlot)),
              maxSeats: slotsEvents[i].maxSeatsLeft,
              minSeatsBuy: slotsEvents[i].minSeatsBuy,
              status: slotsEvents[i].status,
              codeClosed: date.isBefore(DateTime.now()) ? Turitop.codeClosedEventFull: slotsEvents[i].codeClosed.length > 0 ? slotsEvents[i].codeClosed[0] : null));
        });
      } else if (date.isAfter(_currentDate2)) break;
    }

    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500), curve: Curves.ease);
     */
  }

  /*
  Future<bool> showPhoneDialog() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
          backgroundColor: AppColors.black,
          content: Form(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              StandardText(
                  fontSize: 14,
                  text: FlutterI18n.translate(context, "no_slots_phone"),
                  fontFamily: "Kanit_Regular",
                  colorText: AppColors.whiteText,
                  align: TextAlign.center),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  launchOn("tel:", widget.escape.phone.replaceAll(RegExp(' +'), ''));
                  Navigator.pop(context);
                },
                child: Container(
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: StandardTextIcon(
                      colorText: AppColors.white,
                      fontFamily: "Kanit_Regular",
                      fontSize: 18,
                      align: TextAlign.center,
                      imageAsset: "assets/images/icon_phone_detail.png",
                      paddingImg: 14,
                      text: FlutterI18n.translate(context, "phone"),
                    ),
                  ),
                ),
              ),
            ]),
          )),
    )) ??
        false;
  }
   */

  /*
  launchOn(String type, String value) async {
    var url = type + value;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
   */
}