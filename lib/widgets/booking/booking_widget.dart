import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_escaperank_web/bloc/bookings_layer/calendar/calendar_bloc.dart';
import 'package:flutter_escaperank_web/bloc/bookings_layer/calendar/calendar_event.dart';
import 'package:flutter_escaperank_web/bloc/bookings_layer/calendar/calendar_state.dart';
import 'package:flutter_escaperank_web/models/bookings_layer/calendar_simple_event.dart';
import 'package:flutter_escaperank_web/models/escape_room.dart';
import 'package:flutter_escaperank_web/services/calendar_service.dart';
import 'package:flutter_escaperank_web/utils/app_colors.dart';
import 'package:flutter_escaperank_web/widgets/text/standard_text.dart';
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
      decoration: const BoxDecoration(
        color: AppColors.blackBackGround,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
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

  String initial_day_month = "22/07/2022";
  String final_day_month = "28/07/2022";

  ScrollController _scrollController = ScrollController();

  DateTime _currentDate = DateTime.now();
  DateTime _currentDate2 = DateTime.now();
  String _currentMonth = DateFormat.MMMM("es_ES").format(DateTime.now());
  DateTime _targetDateTime = DateTime.now();
  late String timezone;
  List<CalendarSimpleEvent> slotsEvents = [];
  // List<SlotTuritop> slotsSelected = [];
  int slotBooking = 0;
  String noSlotsDay = "";
  int maxSeatsEvent = 0;
  int maxSeatsLeft = 0;
  // String minSeatsBuy;
  late SharedPreferences prefs;
  var _calendarBloc;
  double heightCalendar = 340;

  
  @override
  void initState() {
    super.initState();
    loadEvents(
      initial_day_month,
      final_day_month
    );
    var month = DateTime(DateTime.now().year, DateTime.now().month, 1);
    setState(() {
      heightCalendar = month.weekday >= 6 ? 340 : 290;
    });

  }

  void loadEvents(String startDate, String endDate) async {
    prefs = await SharedPreferences.getInstance();
    _calendarBloc = BlocProvider.of<CalendarBloc>(context);
    _calendarBloc.add(GetCalendar(
        escape_id: widget.escapeRoom.id,
        start_date: startDate,
        end_date: endDate
    ));
  }

  @override
  Widget build(BuildContext context) {
    /// Example Calendar Carousel without header and custom prev & next button
    final _calendarCarouselNoHeader = CalendarCarousel<Event>(

      onDayPressed: (date, events) {
        setState(() => _currentDate2 = date);
        print(_currentDate2);
        // checkSlots();
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
          _currentMonth = DateFormat.MMMM("es_ES").format(_targetDateTime);
        });
      },
    );

    return BlocListener<CalendarBloc, CalendarState>(listener: (context, state) {
      // TODO: NUEVA FORMA DE CONSTRUIR EL CALENDARIO
      if (state is CalendarLoadedSuccess) {
        // timezone = state.calendarAvailability.data.calendar.timezone;
        slotsEvents = state.calendarAvailability.data.calendar.days[0].events; // TODO: #Invented
        print("slots loaded!");

        // maxSeatsEvent = state.product.data.maxSeatsBuy;
        // checkSlots();
      }
    }, child: BlocBuilder<CalendarBloc, CalendarState>(builder: (context, state) {
      return _calendarCarouselNoHeader;
      /*
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          constraints: const BoxConstraints.expand(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TitleCircle(text: FlutterI18n.translate(context, "date_and_hours")),
                      //Header
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios, color: AppColors.greyText),
                            onPressed: () {
                              setState(() {
                                if (DateTime.now().month != _targetDateTime.month) {
                                  _targetDateTime = DateTime(_targetDateTime.year, _targetDateTime.month - 1);
                                  _currentMonth = DateFormat.MMMM("es_ES").format(_targetDateTime);
                                  loadEvents(
                                      DateTime(DateTime.now().year, _targetDateTime.month, 0).millisecondsSinceEpoch ~/ 1000,
                                      DateTime(DateTime.now().year, _targetDateTime.month + 1, 1).millisecondsSinceEpoch ~/ 1000);
                                  var month = DateTime(DateTime.now().year, _targetDateTime.month, 1);
                                  setState(() {
                                    heightCalendar = month.weekday >= 6 ? 340 : 290;
                                  });
                                }
                              });
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                            child: StandardText(
                              colorText: AppColors.whiteText,
                              fontFamily: "Kanit_Regular",
                              fontSize: 16,
                              text: _currentMonth, align: TextAlign.start, lineHeight: 1,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward_ios, color: AppColors.greyText),
                            onPressed: () {
                              setState(() {
                                _targetDateTime = DateTime(_targetDateTime.year, _targetDateTime.month + 1);
                                _currentMonth = DateFormat.MMMM("es_ES").format(_targetDateTime);
                                loadEvents(
                                    DateTime(DateTime.now().year, _targetDateTime.month, 0).millisecondsSinceEpoch ~/ 1000,
                                    DateTime(DateTime.now().year, _targetDateTime.month + 1, 1).millisecondsSinceEpoch ~/ 1000);

                                var month = DateTime(DateTime.now().year, _targetDateTime.month, 1);
                                setState(() {
                                  heightCalendar = month.weekday >= 6 ? 340 : 290;
                                });
                              });
                            },
                          ),
                        ],
                      ),
                      Container(
                        child: _calendarCarouselNoHeader,
                      ),

                      slotsSelected.length > 0
                          ? GridView.count(
                        physics: new NeverScrollableScrollPhysics(),
                        childAspectRatio: 1.5,
                        shrinkWrap: true,
                        crossAxisCount: 4,
                        children: List.generate(slotsSelected.length, (index) {
                          return Center(
                            child: SlotTimeRow(
                              onPressed: (selected, position, String codeClosed) {
                                setState(() {
                                  if (codeClosed != null) {
                                    showPhoneDialog();
                                  } else {
                                    for (int i = 0; i < slotsSelected.length; i++) {
                                      slotsSelected[i].selected = false;
                                    }
                                    slotsSelected[position].selected = selected;
                                    slotBooking = slotsSelected[position].timestamp;
                                    maxSeatsLeft = slotsSelected[position].maxSeats != null ? slotsSelected[position].maxSeats : maxSeatsEvent;
                                    minSeatsBuy = slotsSelected[position].minSeatsBuy != null ? slotsSelected[position].minSeatsBuy : minSeatsBuy;
                                  }
                                });
                              },
                              position: index,
                              selected: slotsSelected[index].selected,
                              name: slotsSelected[index].hour,
                              status: slotsSelected[index].status,
                              codeClosed: slotsSelected[index].codeClosed,
                            ),
                          );
                        }),
                      )
                          : Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: StandardText(
                          colorText: AppColors.whiteText,
                          fontFamily: "Kanit_Regular",
                          fontSize: 16,
                          text: noSlotsDay,
                        ),
                      ),
                      const SizedBox(height: 10),
                      LegendCircle(color: AppColors.primaryRed, text: FlutterI18n.translate(context, "hour_closed")),
                      LegendCircle(
                          color: AppColors.greyDarkText, text: FlutterI18n.translate(context, "hour_no_available")),
                      LegendCircle(color: AppColors.pinkPrimary, text: FlutterI18n.translate(context, "hour_consult")),
                      LegendCircle(color: AppColors.whiteText, text: FlutterI18n.translate(context, "hour_available")),
                      LegendCircle(
                          color: AppColors.yellowPrimary, text: FlutterI18n.translate(context, "hour_selected")),
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
                    colorText: AppColors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (BuildContext context) => TicketsPage(
                                escape: widget.escape, slotBooking: slotBooking, timezone:timezone, maxSeats: maxSeatsLeft, minSeatsBuy: minSeatsBuy)));
                  })
                  : StandardButton(
                  colorButton: AppColors.primaryYellow30,
                  standardText: StandardText(
                    text: FlutterI18n.translate(context, "next"),
                    fontFamily: "Kanit_Medium",
                    fontSize: 18,
                    colorText: AppColors.white,
                  ),
                  onPressed: () {}),
            ],
          ),
        ),
      );
       */
    }));
  }

  /*
  void checkSlots() async {
    setState(() {
      slotsSelected.clear();
    });

    slotBooking = 0;
    noSlotsDay = slotsEvents.length > 0 ? FlutterI18n.translate(context, "no_slots_day") : "";
    tz.initializeTimeZones();
    final timeZoneSlot = tz.getLocation(timezone);
    for (int i = 0; i < slotsEvents.length; i++) {
      var date = DateTime.fromMillisecondsSinceEpoch(slotsEvents[i].time * 1000);
      if (_currentDate2.day == date.day) {
        setState(() {
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
  }
   */

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