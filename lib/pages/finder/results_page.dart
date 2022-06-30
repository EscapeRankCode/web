

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_escaperank_web/bloc/missions/list/mission_list_bloc.dart';
import 'package:flutter_escaperank_web/bloc/missions/list/mission_list_event.dart';
import 'package:flutter_escaperank_web/bloc/missions/list/mission_list_state.dart';
import 'package:flutter_escaperank_web/models/escape_room.dart';
import 'package:flutter_escaperank_web/models/filter_escaperoom.dart';
import 'package:flutter_escaperank_web/pages/escape/escape_detail_page.dart';
import 'package:flutter_escaperank_web/services/escaperoom_service.dart';
import 'package:flutter_escaperank_web/utils/app_colors.dart';
import 'package:flutter_escaperank_web/widgets/cards/finder/escape_search_result.dart';
import 'package:flutter_escaperank_web/widgets/rows/empty_row.dart';
import 'package:flutter_escaperank_web/widgets/text/search_button.dart';
import 'package:flutter_escaperank_web/widgets/text/standard_text.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:shimmer/shimmer.dart';

class ResultsPage extends StatelessWidget {
  final FiltersEscapeRoom filters;

  ResultsPage({required this.filters}) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: StandardText(
            text: FlutterI18n.translate(context, "search_results"),
            fontFamily: "Kanit_Regular",
            colorText: AppColors.white,
            fontSize: 20,
            align: TextAlign.center, lineHeight: 1,),
      ),
      backgroundColor: AppColors.blackBackGround,
      body: SafeArea(
        child: Column(
          children: [
            SearchButton(
              text: FlutterI18n.translate(context, "search_mission_hint"),
              onTap: () {
                // TODO: GO BACK TO FILTERS DIALOG
                /*
                Navigator.pushReplacement(
                    context,
                    CupertinoPageRoute(
                        fullscreenDialog: true,
                        builder: (BuildContext context) => FiltersPage()));
                 */
              },
            ),
            //SizedBox(height: 15),
            BlocProvider<MissionListBloc>(
              create: (context) => MissionListBloc(EscapeRoomServices()),
              child: _SearchPage(filters: filters),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchPage extends StatefulWidget {
  final FiltersEscapeRoom filters;

  _SearchPage({required this.filters}) : super();

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<_SearchPage> {
  var _missionsBloc;
  String numResults = "";

  int _pos = 1;
  Timer? _timer;

  int _page = 1;
  int _limit = 20;

  // There is next page or not
  bool _hasNextPage = true;

  // Used to display loading indicators when _firstLoad function is running
  bool _isFirstLoadRunning = true;

  // Used to display loading indicators when _loadMore function is running
  bool _isLoadMoreRunning = true;
  ScrollController? _controller;
  List<EscapeRoom> missions = [];

  @override
  void initState() {
    super.initState();
    _searchByFilter();
    _incrementCounter();
    _controller = new ScrollController()..addListener(_loadMore);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    _controller?.removeListener(_loadMore);
    super.dispose();
  }

  void _incrementCounter() {
    _timer = Timer.periodic(const Duration(milliseconds: 600), (Timer t) {
      setState(() {
        _pos = _pos + 1;
        if (_pos > 3) _pos = 1;
      });
    });
  }

  _searchByFilter() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    _missionsBloc = BlocProvider.of<MissionListBloc>(context);
    _missionsBloc.add(GetMissionsByFilters(filters: widget.filters));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MissionListBloc, MissionListState>(
        builder: (BuildContext context, MissionListState state) {
          if (state is MissionsByFilterLoaded) {
            return Container(
              child: _body(),
            );
          } else if (state is MissionsByFilterNoResults) {
            return Container(
              child: _noResults(),
            );
          } else if (state is ShowResultsByFilter) {
            return Container(
              child: _body(),
            );
          }
          else {
            return _loadingList(180, MediaQuery.of(context).size.width);
          }
        });
  }

  Widget _loadingList(double height, double width) {
    return Expanded(
      child: Shimmer.fromColors(
        period: const Duration(seconds: 2),
        baseColor: AppColors.blackBackGround,
        highlightColor: AppColors.blackRow,
        child: Padding(
          padding: const EdgeInsets.only(top:20.0),
          child: ListView.builder(
            itemCount: 10,
            scrollDirection: Axis.vertical,
            itemBuilder: (_, index) {
              return EmptyRow(width: width, height: height);
            },
          ),
        ),
      ),
    );
  }

  _noResults() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(height: 40),
          Image.asset("assets/images/icon_no_results.png"),
          const SizedBox(height: 15),
          StandardText(
            text: FlutterI18n.translate(context, "not_missions_found"),
            fontFamily: "Kanit_Light",
            fontSize: 16,
            align: TextAlign.center,
            colorText: AppColors.greyText, lineHeight: 1,
          ),

          // TODO: If not found results, open filters again
          /*
          SizedBox(height: 15),
          LinkText(
            onTap: () {
              setState(() {
                Navigator.pushReplacement(
                    context,
                    CupertinoPageRoute(
                        maintainState: true,
                        fullscreenDialog: true,
                        builder: (BuildContext context) => FiltersPage()));
              });
            },
            colorText: AppColors.yellowPrimary,
            fontFamily: "Kanit_Regular",
            fontSize: 16,
            text: FlutterI18n.translate(context, "modify_search"),
          ),
           */
        ]);
  }

  _body() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          //   Padding(
          //    padding: const EdgeInsets.only(bottom:10.0),
          //   child: BookingDirectMessage(text: FlutterI18n.translate(context, "booking_direct")),
          // ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Row(
              children: [
                StandardText(
                  text: numResults,
                  fontFamily: "Kanit_Medium",
                  fontSize: 16,
                  colorText: AppColors.yellowPrimary, lineHeight: 1,
                  align: TextAlign.start,
                ),
                StandardText(
                  text: FlutterI18n.translate(context, "results"),
                  fontFamily: "Kanit_Regular",
                  fontSize: 16,
                  colorText: AppColors.white,  lineHeight: 1,
                  align: TextAlign.start,
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          BlocBuilder<MissionListBloc, MissionListState>(
              builder: (BuildContext context, MissionListState state) {
                if (state is MissionsByFilterLoaded) {
                  if (_isLoadMoreRunning && _page == state.list.currentPage) {
                    if (state.list.escaperooms.isNotEmpty) {
                      missions.addAll(state.list.escaperooms);
                    } else {
                      _hasNextPage = false;
                    }
                    _isFirstLoadRunning = false;
                    _isLoadMoreRunning = false;
                    numResults = state.list.total.toString();
                  }
                  return _list(missions);
                }
                else if (state is ShowResultsByFilter) {
                  return _list(missions);
                }
                return const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primaryYellow)),
                    ));
              }),
        ],
      ),
    );
  }

  Widget _list(List<EscapeRoom> escaperooms) {
    return Expanded(
      child: ListView.builder(
        controller: _controller,
        physics: const BouncingScrollPhysics(),
        itemCount: escaperooms.length,
        itemBuilder: (_, index) {
          EscapeRoom escapeRoom = escaperooms[index];
          return index+1 >= escaperooms.length && _isLoadMoreRunning ? Column(
            children: [
              EscapeSearchResult(escape: escapeRoom, onTap:() {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => EscapeDetailPage(escape: escapeRoom)));
              }),
              Padding(
                padding: const EdgeInsets.only(top:8.0, bottom:8.0),
                child: CircularProgressIndicator(strokeWidth: 1, valueColor: new AlwaysStoppedAnimation<Color>(AppColors.yellowPrimary)),
              )
            ],
          ) : EscapeSearchResult(escape: escapeRoom, onTap:() {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => EscapeDetailPage(escape: escapeRoom)));
          },);
        },
      ),
    );
  }

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller!.position.extentAfter < 500) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      _page += 1; // Increase _page by 1
      widget.filters.page = _page;
      _missionsBloc.add(LoadMoreMissionsByFilters(filters: widget.filters));
    }
  }
}