import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_escaperank_web/bloc/bookings_layer/calendar/calendar_bloc.dart';
import 'package:flutter_escaperank_web/bloc/bookings_layer/calendar/calendar_event.dart';
import 'package:flutter_escaperank_web/bloc/bookings_layer/calendar/calendar_state.dart';
import 'package:flutter_escaperank_web/models/bookings_layer/calendar/calendar_day.dart';
import 'package:flutter_escaperank_web/models/bookings_layer/calendar/calendar_general.dart';
import 'package:flutter_escaperank_web/models/bookings_layer/calendar/calendar_simple_event.dart';
import 'package:flutter_escaperank_web/models/escape_room.dart';
import 'package:flutter_escaperank_web/services/calendar_service.dart';
import 'package:flutter_escaperank_web/utils/app_colors.dart';
import 'package:flutter_escaperank_web/utils/app_text_styles.dart';
import 'package:flutter_escaperank_web/widgets/booking/slot_time_row.dart';
import 'package:flutter_escaperank_web/widgets/buttons/standard_button.dart';
import 'package:flutter_escaperank_web/widgets/text/legend_circle.dart';
import 'package:flutter_escaperank_web/widgets/text/standard_text.dart';
import 'package:flutter_escaperank_web/widgets/text/title_circle.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel, WeekdayFormat;

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

  int slotBooking = 0;
  String noSlotsDay = "";
  int maxSeatsEvent = 0;
  int maxSeatsLeft = 0;
  // String minSeatsBuy;
  late SharedPreferences prefs;
  var _calendarBloc;
  double heightCalendar = 340;
  double widthCalendar = 340;

  List<CalendarSimpleEvent> slotsEvents = [];
  CalendarGeneral? visibleCalendar;
  late String timezone;
  List<SlotTime> slotsSelected = [];
  CalendarSimpleEvent? selectedEvent;

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
    _calendarBloc.add(
      GetTickets(
        event_date: DateFormat('dd/MM/yyyy').format(_currentDate2),
        event_time: slot.event.time,
        booking_system_id: widget.escapeRoom.bookingSystemId!,
        bs_config: widget.escapeRoom.bsConfigId!,
        event_id: slot.event.eventId
      )
    );
    // TODO: WHAT DO WE DO WHEN USER CLICS ON A TIME
    //  -- SAVE:
    //    -- DATE
    //    -- TIME
    //    -- SLOT INFO (SlotTime object)
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
                    // TODO: JUMP TO PHASE X TO LOAD
                    _selectTime(slotsSelected[index]);
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
    var _booking_phase_2 = Text("PHASE 2");




    return BlocListener<CalendarBloc, CalendarState>(listener: (context, state) {

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
        });
      }

    } , child: BlocBuilder<CalendarBloc, CalendarState>(builder: (context, state) {
      return SizedBox(
        width: 400,
        child: Container(
          decoration: BoxDecoration(
              color: AppColors.blackBackGround,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
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
          _phase == 2 ? _booking_phase_2 : Text("Phase X"),
        )
      );


    }));
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