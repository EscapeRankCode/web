import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_escaperank_web/bloc/filters/filters_bloc.dart';
import 'package:flutter_escaperank_web/bloc/filters/filters_event.dart';
import 'package:flutter_escaperank_web/bloc/filters/filters_state.dart';
import 'package:flutter_escaperank_web/models/filter_escaperoom.dart';
import 'package:flutter_escaperank_web/models/topic.dart';
import 'package:flutter_escaperank_web/pages/finder/results_page.dart';
import 'package:flutter_escaperank_web/services/escaperoom_service.dart';
import 'package:flutter_escaperank_web/utils/app_colors.dart';
import 'package:flutter_escaperank_web/utils/app_sizing.dart';
import 'package:flutter_escaperank_web/utils/app_text_styles.dart';
import 'package:flutter_escaperank_web/utils/filters_utils.dart';
import 'package:flutter_escaperank_web/utils/user_utils.dart';
import 'package:flutter_escaperank_web/widgets/buttons/standard_button.dart';
import 'package:flutter_escaperank_web/widgets/text/form_text.dart';
import 'package:flutter_escaperank_web/widgets/text/standard_text.dart';
import 'package:flutter_escaperank_web/widgets/text/standard_text_icon.dart';
import 'package:flutter_escaperank_web/widgets/user_inputs/duration_slider.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class FiltersDialogCard extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AlertDialog(
      backgroundColor: AppColors.blackBackGround,
      title: Text(
        FlutterI18n.translate(context, "search_mission_hint"),
        style: AppTextStyles.filtersDialogTitle,
        textAlign: TextAlign.center,
      ), // TODO: HARDCODED
      content: BlocProvider<FiltersBloc>(
        create:(context) => FiltersBloc(EscapeRoomServices()),
        child: _FiltersDialogCard(),
      ),
    );
  }

 /*
  @override
  Widget build(BuildContext context) {
    return BlocProvider<FiltersBloc>(
      create:(context) => FiltersBloc(EscapeRoomServices()),
      child: _FiltersDialogCard(),
    );
  }
  */
}

class _FiltersDialogCard extends StatefulWidget {
  @override
  __FiltersFormState createState() => __FiltersFormState();
}

class __FiltersFormState extends State<_FiltersDialogCard> {
  SharedPreferences? prefs;
  final _missionNameController = TextEditingController();
  final _missionPeopleController = TextEditingController();
  final _missionLocationController = TextEditingController();
  final _missionDurationController = TextEditingController();
  int _positionDifficultList = 0;
  String _difficultSelected = "null";
  int _positionPublicList = 0;
  String _publicSelected = "null";
  RangeValues _durationValue = const RangeValues(0, 240);
  List<Topic> topicsList = [];
  List<Topic> selectedTopics = [];
  bool hearingImpairment = false;
  bool motorDisability = false;
  bool visualImpairment = false;
  bool claustrophobia = false;
  bool english = false;
  bool pregnant = false;
  bool showMore = false;

  String _sessionToken = "null";
  var uuid = const Uuid();
  var _focusLocation = FocusNode();
  List<dynamic> _placeList = [];
  double latitude = LATITUDE_NOT_DEFINED;
  double longitude = LONGITUDE_NOT_DEFINED;
  bool directBooking = false;
  bool selectedNearMe = false;
  bool searchMoreRadius = false;
  bool selectedGooglePlace = true;

  @override
  void initState() {
    super.initState();
    if (_sessionToken == "null") {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    _missionLocationController.addListener(() {
      _onChanged();
    });
    loadTopics();
  }

  _onChanged() async {
    if (_missionLocationController.text.length > 3 && _focusLocation.hasFocus) {
      selectedGooglePlace = false;
      _placeList = await UserUtils.getSuggestion(_missionLocationController.text, _sessionToken);
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initFilters();
  }

  void loadTopics() async {
    final _filtersBloc = BlocProvider.of<FiltersBloc>(context);
    _filtersBloc.add(LoadTopics());
  }

  @override
  Widget build(BuildContext context) {
    setPlaceInfo(String value) async {
      var infoGoogle = await UserUtils.getPlaceInfo(value, _sessionToken);
      searchMoreRadius = infoGoogle.searchMoreRadius;
      _missionLocationController.text = infoGoogle.city;
      latitude = infoGoogle.latitude;
      longitude = infoGoogle.longitude;
    }

    _onSearchButtonPressed() {
      Filters.filterName = _missionNameController.text;
      Filters.filterNumPeople = _missionPeopleController.text;
      Filters.filterLocation = _missionLocationController.text;
      Filters.filterPositionDifficult = _positionDifficultList;
      Filters.filterPositionPublic = _positionPublicList;
      Filters.filterPublicSelected = _publicSelected;
      Filters.filterDifficultSelected = _difficultSelected;
      Filters.filterDurationValue = _durationValue;
      Filters.filterSelectedTopics = selectedTopics;
      Filters.filterHearingImpairment = hearingImpairment;
      Filters.filterMotorDisability = motorDisability;
      Filters.filterVisualImpairment = visualImpairment;
      Filters.filterClaustrophobia = claustrophobia;
      Filters.filterEnglish = english;
      Filters.filterPregnant = pregnant;
      Filters.filterShowMore = showMore;
      Filters.filterLatitude = latitude;
      Filters.filterLongitude = longitude;
      Filters.filterSelectedNearMe = selectedNearMe;
      Filters.filterDirectBooking = directBooking;
      var filters = FiltersEscapeRoom(
          name: _missionNameController.text,
          latitude: latitude.toString(),
          longitude: longitude.toString(),
          numPlayers: _missionPeopleController.text,
          audience: _positionPublicList,
          difficulty: _positionDifficultList,
          duration: _durationValue,
          hearing: hearingImpairment,
          motor: motorDisability,
          visual: visualImpairment,
          pregnant: pregnant,
          claustrophobia: claustrophobia,
          english: english,
          topics: selectedTopics,
          directBooking: directBooking,
          limit: 20,
          page: 1,
          searchMoreRadius: searchMoreRadius);

      // TODO: GO TO RESULTS PAGE
      print("Go to Results Page");
      Navigator.pushReplacement(
          context, CupertinoPageRoute(builder: (BuildContext context) => ResultsPage(filters: filters)));
    }

    return Container(
        width: AppSizing.filters_dialog_max_width,
        height: AppSizing.filters_dialog_max_height,
        decoration: BoxDecoration(
          color: AppColors.blackBackGround,
          borderRadius: BorderRadius.circular(30)),
        child: SafeArea(
            minimum: const EdgeInsets.all(0),

            child: Column(
              children: [
                Expanded(
                    child: BlocListener<FiltersBloc, FiltersState>(
                      listener: (context, state) {
                        if (state is TopicsSuccess) {
                          topicsList = state.topicList.topics;
                        } else if (state is TopicsFailure) {
                          _showError("topics.error");
                        }
                      },
                      child: BlocBuilder<FiltersBloc, FiltersState>(
                        builder: (context, state) {
                          return Container(
                            constraints: const BoxConstraints.expand(),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Scrollbar(
                                    thumbVisibility: false,
                                    child: SingleChildScrollView(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[

                                              // ---------- SECCION FILTROS: NOMBRE Y LOCALIZACION
                                              Text(
                                                FlutterI18n.translate(context, "filters_name_section_title"),
                                                style: AppTextStyles.filtersDialogSectionNameTitle,
                                                textAlign: TextAlign.start,
                                              ),

                                              const SizedBox(
                                                height: AppSizing.filters_dialog_fields_sep,
                                              ),

                                              // NOMBRE DE LA SALA --> TODO: NOMBRE DE LA EMPRESA
                                              FormText(
                                                  text: FlutterI18n.translate(context, "mission_name"),
                                                  inputType: TextInputType.emailAddress,
                                                  controller: _missionNameController,
                                                  inputAction: TextInputAction.done,
                                                  obscureText: false,
                                                  errorText: FlutterI18n.translate(context, "error_field")),
                                              const SizedBox(
                                                height: AppSizing.filters_dialog_fields_sep,
                                              ),
                                              //Field City
                                              FormText(
                                                  text: FlutterI18n.translate(context, "mission_location"),
                                                  inputType: TextInputType.name,
                                                  controller: _missionLocationController,
                                                  inputAction: TextInputAction.done,
                                                  obscureText: false,
                                                  focus: _focusLocation,
                                                  errorText: FlutterI18n.translate(context, "error_field")),

                                              const SizedBox(
                                                height: AppSizing.filters_dialog_sections_sep,
                                              ),

                                              // ---------- SECCION FILTROS: FILTROS
                                              Text(
                                                FlutterI18n.translate(context, "filters_name_section_filters"),
                                                style: AppTextStyles.filtersDialogSectionNameTitle,
                                                textAlign: TextAlign.start,
                                              ),

                                              const SizedBox(
                                                height: AppSizing.filters_dialog_fields_sep,
                                              ),
                                              // -------- NUM PLAYERS
                                              FormText(
                                                  text: FlutterI18n.translate(context, "mission_num_people"),
                                                  inputType: TextInputType.number,
                                                  controller: _missionPeopleController,
                                                  inputAction: TextInputAction.done,
                                                  obscureText: false,
                                                  errorText: FlutterI18n.translate(context, "error_field")),

                                              const SizedBox(
                                                height: AppSizing.filters_dialog_fields_sep,
                                              ),

                                              // ------- DURATION -- TODO: Duration input widget
                                              FormText(
                                                  text: FlutterI18n.translate(context, "mission_duration"),
                                                  inputType: TextInputType.number,
                                                  controller: _missionDurationController,
                                                  inputAction: TextInputAction.done,
                                                  obscureText: false,
                                                  errorText: FlutterI18n.translate(context, "error_field")
                                              ),


                                              const SizedBox(
                                                height: 10,
                                              ),

                                              // TODO: Difficult
                                              /*
                                          SelectBoxText(
                                              text: FlutterI18n.translate(context, "mission_difficult"),
                                              options: [
                                                FlutterI18n.translate(context, "level_all"),
                                                FlutterI18n.translate(context, "level_easy"),
                                                FlutterI18n.translate(context, "level_medium"),
                                                FlutterI18n.translate(context, "level_hard"),
                                                FlutterI18n.translate(context, "level_expert"),
                                              ],
                                              position: _positionDifficultList,
                                              onChanged: (String value, int numPosition) {
                                                setState(() {
                                                  _difficultSelected = value;
                                                  _positionDifficultList = numPosition;
                                                });
                                              },
                                              chosenValue: _difficultSelected),
                                           */
                                              const SizedBox(height: 20),

                                              Padding(
                                                padding: const EdgeInsets.only(bottom: 10),
                                                child: StandardText(
                                                  colorText: AppColors.greyText,
                                                  fontFamily: "Kanit_Light",
                                                  fontSize: 16,
                                                  text: FlutterI18n.translate(context, "mission_themes"),
                                                  align: TextAlign.start,
                                                  lineHeight: 1,
                                                ),
                                              ),

                                              // TODO: TOPICS SELECTOR
                                              /*
                                          selectedTopics.length <= 0
                                              ? ImageButton(
                                            borderColor: AppColors.greyText,
                                            colorButton: AppColors.translucidWhite,
                                            standardTextIcon: StandardTextIcon(
                                              text: FlutterI18n.translate(context, "select"),
                                              fontSize: 14,
                                              fontFamily: "Kanit_Light",
                                              colorText: AppColors.greyText,
                                              imageAsset: "assets/images/icon_add.png",
                                              paddingImg: 5,
                                            ),
                                            onPressed: () {
                                              getSelectedItems();
                                            },
                                          )
                                              : Container(
                                            height: 60,
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: selectedTopics.length,
                                              itemBuilder: (_, index) {
                                                return Center(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(right: 15),
                                                    child: TagButton(
                                                      onPressed: (selected, id, position) {
                                                        getSelectedItems();
                                                      },
                                                      id: selectedTopics[index].id,
                                                      position: index,
                                                      selected: selectedTopics[index].selected,
                                                      name: selectedTopics[index].name,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                           */
                                              const SizedBox(height: 20),

                                              // TODO: Show More
                                              /*
                                          !showMore
                                              ? Center(
                                            child: LinkText(
                                              onTap: () {
                                                setState(() {
                                                  showMore = true;
                                                });
                                              },
                                              colorText: AppColors.greyText,
                                              fontFamily: "Kanit_Light",
                                              fontSize: 14,
                                              text: FlutterI18n.translate(context, "show_more_filters"),
                                            ),
                                          )
                                              : Column(
                                            children: [
                                              //Publico
                                              SelectBoxText(
                                                  text: FlutterI18n.translate(context, "mission_public"),
                                                  options: [
                                                    FlutterI18n.translate(context, "public_default"),
                                                    FlutterI18n.translate(context, "public_kids"),
                                                    FlutterI18n.translate(context, "public_adults"),
                                                    FlutterI18n.translate(context, "public_all"),
                                                  ],
                                                  position: _positionPublicList,
                                                  onChanged: (String value, int numPosition) {
                                                    setState(() {
                                                      _publicSelected = value;
                                                      _positionPublicList = numPosition;
                                                    });
                                                  },
                                                  chosenValue: _publicSelected),
                                              const SizedBox(height: 20),
                                              //Switchs
                                              CustomSwitch(
                                                title: FlutterI18n.translate(context, "mission_additional_1"),
                                                selected: hearingImpairment,
                                                onChanged: (selected) {
                                                  setState(() {
                                                    hearingImpairment = selected;
                                                  });
                                                },
                                              ),
                                              CustomSwitch(
                                                title: FlutterI18n.translate(context, "mission_additional_2"),
                                                selected: motorDisability,
                                                onChanged: (selected) {
                                                  setState(() {
                                                    motorDisability = selected;
                                                  });
                                                },
                                              ),
                                              CustomSwitch(
                                                title: FlutterI18n.translate(context, "mission_additional_3"),
                                                selected: visualImpairment,
                                                onChanged: (selected) {
                                                  setState(() {
                                                    visualImpairment = selected;
                                                  });
                                                },
                                              ),
                                              CustomSwitch(
                                                title: FlutterI18n.translate(context, "mission_additional_4"),
                                                selected: claustrophobia,
                                                onChanged: (selected) {
                                                  setState(() {
                                                    claustrophobia = selected;
                                                  });
                                                },
                                              ),
                                              CustomSwitch(
                                                title: FlutterI18n.translate(context, "mission_additional_6"),
                                                selected: english,
                                                onChanged: (selected) {
                                                  setState(() {
                                                    english = selected;
                                                  });
                                                },
                                              ),
                                              CustomSwitch(
                                                title: FlutterI18n.translate(context, "mission_additional_5"),
                                                selected: pregnant,
                                                onChanged: (selected) {
                                                  setState(() {
                                                    pregnant = selected;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                           */

                                            ],
                                          ),
                                        )
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10.0, 16, 0),
                  child: Column(children: <Widget>[
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: StandardButton(
                            colorButton: AppColors.yellowPrimary,
                            standardText: StandardText(
                              text: FlutterI18n.translate(context, "search_button"),
                              fontFamily: "Montserrat_Semibold",
                              fontSize: 18,
                              colorText: AppColors.white, align: TextAlign.start, lineHeight: 1,
                            ),
                            onPressed: () {
                              _onSearchButtonPressed();
                            })),
                    const SizedBox(height: 15),
                  ]),
                )
              ],
            )));
  }

  void cleanFilters() {
    setState(() {
      _missionNameController.text = "";
      _missionPeopleController.text = "";
      _missionLocationController.text = "";
      _positionDifficultList = 0;
      _positionPublicList = 0;
      _publicSelected = FlutterI18n.translate(context, "public_default");
      _difficultSelected = FlutterI18n.translate(context, "level_all");
      _durationValue = const RangeValues(0, 240);
      selectedTopics = [];
      hearingImpairment = false;
      motorDisability = false;
      visualImpairment = false;
      claustrophobia = false;
      english = false;
      pregnant = false;
      showMore = false;
      latitude = LATITUDE_NOT_DEFINED;
      longitude = LONGITUDE_NOT_DEFINED;
      selectedNearMe = false;
      directBooking = false;
      Filters.filterName = "";
      Filters.filterNumPeople = "";
      Filters.filterLocation = "";
      Filters.filterPositionDifficult = 0;
      Filters.filterPositionPublic = 0;
      Filters.filterPublicSelected = "";
      Filters.filterDifficultSelected = "";
      Filters.filterDurationValue = const RangeValues(0, 240);
      Filters.filterSelectedTopics = [];
      Filters.filterHearingImpairment = false;
      Filters.filterMotorDisability = false;
      Filters.filterVisualImpairment = false;
      Filters.filterClaustrophobia = false;
      Filters.filterEnglish = false;
      Filters.filterPregnant = false;
      Filters.filterShowMore = false;
      Filters.filterLatitude = LATITUDE_NOT_DEFINED;
      Filters.filterLongitude = LONGITUDE_NOT_DEFINED;
      Filters.filterSelectedNearMe = false;
      Filters.filterDirectBooking = false;
    });
  }

  void initFilters() {
    setState(() {
      _missionNameController.text = Filters.filterName;
      _missionPeopleController.text = Filters.filterNumPeople;
      _missionLocationController.text = Filters.filterLocation;
      _positionDifficultList = Filters.filterPositionDifficult;
      _difficultSelected = Filters.filterDifficultSelected.isNotEmpty
          ? Filters.filterDifficultSelected
          : FlutterI18n.translate(context, "level_all");
      _positionPublicList = Filters.filterPositionPublic;
      _publicSelected = Filters.filterPublicSelected.isNotEmpty
          ? Filters.filterPublicSelected
          : FlutterI18n.translate(context, "public_default");
      _durationValue = Filters.filterDurationValue;
      selectedTopics = Filters.filterSelectedTopics;
      hearingImpairment = Filters.filterHearingImpairment;
      motorDisability = Filters.filterMotorDisability;
      visualImpairment = Filters.filterVisualImpairment;
      claustrophobia = Filters.filterClaustrophobia;
      english = Filters.filterEnglish;
      pregnant = Filters.filterPregnant;
      showMore = Filters.filterShowMore;
      latitude = Filters.filterLatitude;
      longitude = Filters.filterLongitude;
      selectedNearMe = Filters.filterSelectedNearMe;
      directBooking = Filters.filterDirectBooking;
    });
  }

  // TODO: GET SELECTED TOPICS
  /*
  void getSelectedItems() async {
    var selected = await Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false, // set to false
        pageBuilder: (_, __, ___) => TopicsPage(topics: topicsList),
      ),
    );
    if (selected != null)
      setState(() {
        selectedTopics = selected != null ? selected : [];
      });
  }
   */

  void _showError(String error) {
    Scaffold.of(context).showSnackBar(
        SnackBar(content: Text(FlutterI18n.translate(context, error)), backgroundColor: AppColors.primaryRed));
  }

  // MAYBE CHECK IF NECESSARY CHECK_LOCATION FUNCTION
  /*
  void _checkLocation() async {
    var position = await UserUtils.determinePosition(true);
    if (position != null) {
      latitude = position.latitude;
      longitude = position.longitude;
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks != null && placemarks.length > 0) {
        _missionLocationController.text = placemarks[0].locality;
      }
    }
  }
   */

  void uncheckLocation() {
    latitude = LATITUDE_NOT_DEFINED;
    longitude = LONGITUDE_NOT_DEFINED;
  }
}
