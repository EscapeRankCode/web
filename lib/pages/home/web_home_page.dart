
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_escaperank_web/bloc/missions/featured_missions/featured_missions_row_bloc.dart';
import 'package:flutter_escaperank_web/bloc/missions/featured_missions/featured_missions_row_event.dart';
import 'package:flutter_escaperank_web/bloc/missions/new_missions/new_missions_row_bloc.dart';
import 'package:flutter_escaperank_web/bloc/missions/new_missions/new_missions_row_event.dart';
import 'package:flutter_escaperank_web/models/escape_room.dart';
import 'package:flutter_escaperank_web/models/topic.dart';
import 'package:flutter_escaperank_web/services/escaperoom_service.dart';
import 'package:flutter_escaperank_web/utils/app_colors.dart';
import 'package:flutter_escaperank_web/utils/app_sizing.dart';
import 'package:flutter_escaperank_web/utils/app_text_styles.dart';
import 'package:flutter_escaperank_web/widgets/cards/filters/filters_dialog_card.dart';
import 'package:flutter_escaperank_web/widgets/cards/home/home_bigger_escape.dart';
import 'package:flutter_escaperank_web/widgets/cards/home/home_normal_escape.dart';
import 'package:flutter_escaperank_web/widgets/text/search_button.dart';
import 'package:flutter_escaperank_web/widgets/text/standard_text.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class WebHomePage extends StatelessWidget{
  WebHomePage() : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        minimum: const EdgeInsets.all(0),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => NewMissionsRowBloc(escapeRoomServices: EscapeRoomServices()),
            ),
            BlocProvider(
              create: (context) => FeaturedMissionsRowBloc(escapeRoomServices: EscapeRoomServices()),
            )
          ],
          child: _WebHomePage(),
        ),
      ),
    );
  }
}


class _WebHomePage extends StatefulWidget{

  const _WebHomePage() : super();

  @override
  _WebHomePageState createState() => _WebHomePageState();

}



class _WebHomePageState extends State<_WebHomePage>{
  // Blocs
  var _newMissionsBloc;
  var _featuredMissionsBloc;
  late final ScrollController controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadMissions();
    _loadControllers();
  }

  _loadMissions() async{
    // Load the blocs into the Context
    _featuredMissionsBloc = BlocProvider.of<FeaturedMissionsRowBloc>(context);
    _newMissionsBloc = BlocProvider.of<NewMissionsRowBloc>(context);
    // Add events to the blocs to load the missions
    _featuredMissionsBloc.add(FeaturedMissionsRowEventLoad());
    _newMissionsBloc.add(NewMissionsRowEventLoad());
  }

  _loadControllers(){
    controller = ScrollController();
  }

  // --------------------- WIDGETS ----------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackBackGround,
      body: SafeArea(
        child: _body(),
      ),
    );
  }

  _body(){
    return SingleChildScrollView(
      child: Column(
        children: [
          // Search Button
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: SearchButton(
                text: FlutterI18n.translate(context, "search_mission_hint"),
                max_width: 700,
                onTap: (){
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return FiltersDialogCard();
                      });
                }
            ),
          ),

          const SizedBox(height: AppSizing.subSearchButtonSeparation,),

          Padding(
              padding: const EdgeInsets.fromLTRB(AppSizing.mainPageExternalPadding, 0, AppSizing.mainPageExternalPadding, AppSizing.mainPageExternalPadding),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // FEATURED MISSIONS BLOC
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppSizing.sectionsPadding),
                      child: StandardText(
                        text: FlutterI18n.translate(context, "title_featured"),
                        fontFamily: AppTextStyles.homeSectionTitle.fontFamily!,
                        fontSize: AppTextStyles.homeSectionTitle.fontSize!,
                        colorText: AppTextStyles.homeSectionTitle.color!,
                        align: TextAlign.start,
                        lineHeight: 1,
                      ),
                    ),
                    BlocBuilder<FeaturedMissionsRowBloc, FeaturedMissionsRowState>(
                        builder: (BuildContext context, FeaturedMissionsRowState state) {
                          if (state is FeaturedMissionsRowStateLoaded) {
                            List<EscapeRoom> missions = state.list.escaperooms;
                            return bigger_row(missions);
                          }
                          return const Center(
                            // TODO: Change to SHIMMER
                              child: Padding(
                                padding: EdgeInsets.only(top: 20.0),
                                child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.yellowPrimary)
                                ),
                              )
                          );
                        }
                    ),

                    const SizedBox(height: AppSizing.sectionsSeparator),

                    // NEW MISSIONS BLOC
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppSizing.sectionsPadding),
                      child: StandardText(
                        text: FlutterI18n.translate(context, "new_missions"),
                        fontFamily: AppTextStyles.homeSectionTitle.fontFamily!,
                        fontSize: AppTextStyles.homeSectionTitle.fontSize!,
                        colorText: AppTextStyles.homeSectionTitle.color!,
                        align: TextAlign.start,
                        lineHeight: 1,
                      ),
                    ),
                    BlocBuilder<NewMissionsRowBloc, NewMissionsRowState>(
                        builder: (BuildContext context, NewMissionsRowState state) {
                          if (state is NewMissionsRowStateLoaded) {
                            List<EscapeRoom> missions = state.list.escaperooms;
                            return normal_row(missions);
                          }
                          return const Center(
                            // TODO: Change to SHIMMER
                              child: Padding(
                                padding: EdgeInsets.only(top: 20.0),
                                child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.yellowPrimary)
                                ),
                              )
                          );
                        }
                    ),
                  ],
                ),
              )
          )
        ],
      ),
    );

  }


  // -------------------- FUNCTIONS -----------------------
  Future<String> _onRefresh() async{
    return "Refresh";
  }


  Widget bigger_row(List<EscapeRoom> missions){
    return Container(
      height: AppSizing.homeBiggerRowHeight,
      child: ListView.builder(
        itemCount: missions.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              HomeBiggerEscape(mission: missions.elementAt(index)),
              const SizedBox(width: AppSizing.rowsInsideSeparation,)
            ],
          );
        },
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
      ),
    );
  }

  Widget normal_row(List<EscapeRoom> missions){
    return Container(
      height: AppSizing.homeNormalRowHeight,
      child: ListView.builder(
        itemCount: missions.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              HomeNormalEscape(mission: missions.elementAt(index)),
              const SizedBox(width: AppSizing.rowsInsideSeparation,)
            ],
          );
        },
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
      ),
    );
  }

}