import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_escaperank_web/bloc/missions/new_missions/new_missions_row_bloc.dart';
import 'package:flutter_escaperank_web/configuration.dart';
import 'package:flutter_escaperank_web/models/escape_room.dart';
import 'package:flutter_escaperank_web/services/escaperoom_service.dart';
import 'package:flutter_escaperank_web/utils/analytics_utils.dart';
import 'package:flutter_escaperank_web/utils/app_colors.dart';
import 'package:flutter_escaperank_web/utils/app_sizing.dart';
import 'package:flutter_escaperank_web/utils/app_text_styles.dart';
import 'package:flutter_escaperank_web/utils/image_utils.dart';
import 'package:flutter_escaperank_web/utils/map_utils.dart';
import 'package:flutter_escaperank_web/widgets/booking/booking_widget.dart';
import 'package:flutter_escaperank_web/widgets/buttons/topic_detail.dart';
import 'package:flutter_escaperank_web/widgets/rows/ficha_tecnica.dart';
import 'package:flutter_escaperank_web/widgets/text/standard_text.dart';
import 'package:flutter_escaperank_web/widgets/text/standard_text_icon.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:map/map.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class EscapeDetailPage extends StatefulWidget {
  final EscapeRoom escape;

  const EscapeDetailPage({required this.escape}) : super();

  @override
  __EscapeDetailPage createState() => __EscapeDetailPage();
}

class __EscapeDetailPage extends State<EscapeDetailPage> {
  late SharedPreferences prefs;
  final EscapeRoomServices _escapeService = EscapeRoomServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackBackGround,
      body: SafeArea(
        child: BlocProvider<NewMissionsRowBloc>(
          create: (context) => NewMissionsRowBloc(escapeRoomServices: EscapeRoomServices()),
          child: _MissionDetailPage(escape: widget.escape),
        ),
      ),
    );
  }
}

class _MissionDetailPage extends StatefulWidget {
  final EscapeRoom escape;

  const _MissionDetailPage({required this.escape}) : super();

  @override
  _EscapeDetailPageState createState() => _EscapeDetailPageState();
}

class _EscapeDetailPageState extends State<_MissionDetailPage> {

  final bool _darkMode = false;
  late List<LatLng>markers = [];
  bool firstLoad = true;
  bool is_desktop = true;


  @override
  void initState() {
    super.initState();
    // Add the escape marker
    markers.add(
        LatLng(
            double.parse(widget.escape.latitude),
            double.parse(widget.escape.longitude)
        )
    );
    if (firstLoad) {
      firstLoad = false;
      AnalyticsUtils.logEventEscape(widget.escape.name,
          widget.escape.id.toString(), widget.escape.companyId.toString());
      AnalyticsUtils.logEventEscaperoom(widget.escape.name,
          widget.escape.id.toString(), widget.escape.companyId.toString());
    }
  }

  Future<String> _getFileData(String path) async {
    return await rootBundle.loadString(path);
  }

  void _setMapStyle(String mapStyle) {
    setState(() {
      // TODO: _controller.setMapStyle(mapStyle);
    });
  }

  void onMapCreated(MapController controller) {
    setState(() {
      //_controller = controller;
      //_getFileData('assets/night_mode.json').then(_setMapStyle);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewMissionsRowBloc, NewMissionsRowState>(
        builder: (BuildContext context, NewMissionsRowState state) {
          return Container(
            child: _body(),
          );
        });
  }

  _body() {
    Size screen_size = MediaQuery.of(context).size;
    double columns_width = (screen_size.width - (2 * AppSizing.sectionsPadding)) / 2 - 30;
    LatLng escapeLocation = LatLng(double.parse(widget.escape.latitude), double.parse(widget.escape.longitude));
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSizing.escapeDetailPageExternalPadding, 0, AppSizing.escapeDetailPageExternalPadding, AppSizing.escapeDetailPageExternalPadding),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AppSizing.sectionsPadding, 0, AppSizing.sectionsPadding, 0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                // Row to have ESCAPE NAME and FAV and SHARE buttons
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, AppSizing.sectionsPadding, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // ----------------------------------- Escape Name
                      StandardText(
                        text: widget.escape.name,
                        fontFamily: AppTextStyles.escapeDetailEscapeName.fontFamily!,
                        fontSize: AppTextStyles.escapeDetailEscapeName.fontSize!,
                        colorText: AppTextStyles.escapeDetailEscapeName.color!,
                        align: TextAlign.start,
                        lineHeight: 1,
                      ),
                    ],
                  ),
                ),


                // ---------------------------------------- Topics
                widget.escape.topics.isNotEmpty ?
                Container(
                  height: AppSizing.escapeDetailPageTopicsContainerHeight,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(right: 10),
                    itemCount: widget.escape.topics.length,
                    itemBuilder: (_, index) {
                      return Center(
                        child: TopicPageDetail(
                          id: widget.escape.topics[index].id,
                          name: widget.escape.topics[index].name,
                        ),
                      );
                    },
                  ),
                ) : const SizedBox.shrink(),


                // Row with info about Rating, Company and City
                Row(
                  children: [
                    // ----------------------------------- Escape Score
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        child: StandardTextIcon(
                          text: widget.escape.score + " · " + widget.escape.reviews.length.toString() + " valoraciones",
                          fontFamily: AppTextStyles.escapeDetailRatingAndCity.fontFamily!,
                          fontSize: AppTextStyles.escapeDetailRatingAndCity.fontSize!,
                          colorText: AppTextStyles.escapeDetailRatingAndCity.color!,
                          paddingImg: AppSizing.escapeDetailPageTopicsIconsPadding,
                          imageAsset: "assets/images/icon_rating_white.png", lineHeight: 1, align: TextAlign.start,
                        ),
                        onTap: (){
                          // TODO: When user clics on ratings
                        },
                      ),
                    ),


                    // Separator
                    const Text(
                      "  -  ",
                      style: AppTextStyles.escapeDetailRatingAndCity,
                    ),


                    // ----------------------------------- Escape Company Name
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        child: Text(
                          widget.escape.company.brandName,
                          style: AppTextStyles.escapeDetailCompanyBrandName,
                        ),
                        onTap: (){
                          // TODO: When user clics on company name
                        },
                      ),
                    ),


                    // Separator
                    const Text(
                      "  -  ",
                      style: AppTextStyles.escapeDetailRatingAndCity,
                    ),


                    // -------------------------------- Location
                    StandardTextIcon(
                      text: widget.escape.city,
                      fontFamily: AppTextStyles.escapeDetailRatingAndCity.fontFamily!,
                      fontSize: AppTextStyles.escapeDetailRatingAndCity.fontSize!,
                      colorText: AppTextStyles.escapeDetailRatingAndCity.color!,
                      paddingImg: AppSizing.escapeDetailPageTopicsIconsPadding,
                      imageAsset: "assets/images/icon_location_row.png", lineHeight: 1, align: TextAlign.start,
                    ),


                  ],
                ),

                // Two Columns of info
                is_desktop ?
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, AppSizing.sectionsPadding, 0, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // LEFT Side
                      Container(
                        width: columns_width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ----------------------------------- Escape Description
                            StandardText(
                              text: FlutterI18n.translate(context, "description"),
                              fontFamily: AppTextStyles.escapeDetailMiniTitle.fontFamily!,
                              fontSize: AppTextStyles.escapeDetailMiniTitle.fontSize!,
                              colorText: AppTextStyles.escapeDetailMiniTitle.color!,
                              lineHeight: 1,
                              align: TextAlign.start,
                            ),
                            const SizedBox(height: 10),
                            StandardText(
                              text: widget.escape.description,
                              fontFamily: AppTextStyles.escapeDetailNormalText.fontFamily!,
                              fontSize: AppTextStyles.escapeDetailNormalText.fontSize!,
                              colorText: AppTextStyles.escapeDetailNormalText.color!,
                              lineHeight: AppTextStyles.escapeDetailNormalText.height!,
                              align: TextAlign.start ,
                            ),
                            const SizedBox(height: 10),

                            // ----------------------------------- Ficha Tecnica
                            FichaTecnica(escape: widget.escape),
                            // ----------------------------------- Aditional Info
                            widget.escape.comments.isNotEmpty ? // comments field refers to "additional info"
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: AppSizing.sectionsPadding),
                                StandardText(
                                  text: FlutterI18n.translate(context, "additional_info"),
                                  fontFamily: AppTextStyles.escapeDetailMiniTitle.fontFamily!,
                                  fontSize: AppTextStyles.escapeDetailMiniTitle.fontSize!,
                                  colorText: AppTextStyles.escapeDetailMiniTitle.color!,
                                  lineHeight: 1,
                                  align: TextAlign.start,
                                ),
                                const SizedBox(height: 10),
                                StandardText(
                                  text: widget.escape.comments,
                                  fontFamily: AppTextStyles.escapeDetailNormalText.fontFamily!,
                                  fontSize: AppTextStyles.escapeDetailNormalText.fontSize!,
                                  colorText: AppTextStyles.escapeDetailNormalText.color!,
                                  lineHeight: AppTextStyles.escapeDetailNormalText.height!,
                                  align: TextAlign.start ,
                                ),

                                widget.escape.hearingImpairment
                                    ? Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: StandardTextIcon(
                                    text: FlutterI18n.translate(context, "mission_additional_1"),
                                      colorText: AppTextStyles.escapeDetailFichaTecnica.color!,
                                      fontSize: AppTextStyles.escapeDetailFichaTecnica.fontSize!,
                                      fontFamily: AppTextStyles.escapeDetailFichaTecnica.fontFamily!,
                                      lineHeight: AppTextStyles.escapeDetailFichaTecnica.height!,
                                      align: TextAlign.start,
                                      imageAsset: "assets/images/icon_adapt1.png",
                                      paddingImg: AppSizing.cardInfoIconsPadding
                                  ),
                                )
                                    : SizedBox.shrink(),

                                widget.escape.motorDisability
                                    ? Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: StandardTextIcon(
                                    text: FlutterI18n.translate(context, "mission_additional_2"),
                                      colorText: AppTextStyles.escapeDetailFichaTecnica.color!,
                                      fontSize: AppTextStyles.escapeDetailFichaTecnica.fontSize!,
                                      fontFamily: AppTextStyles.escapeDetailFichaTecnica.fontFamily!,
                                      lineHeight: AppTextStyles.escapeDetailFichaTecnica.height!,
                                      align: TextAlign.start,
                                      imageAsset: "assets/images/icon_adapt2.png",
                                      paddingImg: AppSizing.cardInfoIconsPadding
                                  ),
                                )
                                    : SizedBox.shrink(),

                                widget.escape.visualImpairment
                                    ? Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: StandardTextIcon(
                                    text: FlutterI18n.translate(context, "mission_additional_3"),
                                      colorText: AppTextStyles.escapeDetailFichaTecnica.color!,
                                      fontSize: AppTextStyles.escapeDetailFichaTecnica.fontSize!,
                                      fontFamily: AppTextStyles.escapeDetailFichaTecnica.fontFamily!,
                                      lineHeight: AppTextStyles.escapeDetailFichaTecnica.height!,
                                      align: TextAlign.start,
                                      imageAsset: "assets/images/icon_adapt3.png",
                                      paddingImg: AppSizing.cardInfoIconsPadding
                                  ),
                                )
                                    : SizedBox.shrink(),

                                widget.escape.claustrophobia
                                    ? Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: StandardTextIcon(
                                    text: FlutterI18n.translate(context, "mission_additional_4"),
                                      colorText: AppTextStyles.escapeDetailFichaTecnica.color!,
                                      fontSize: AppTextStyles.escapeDetailFichaTecnica.fontSize!,
                                      fontFamily: AppTextStyles.escapeDetailFichaTecnica.fontFamily!,
                                      lineHeight: AppTextStyles.escapeDetailFichaTecnica.height!,
                                      align: TextAlign.start,
                                      imageAsset: "assets/images/icon_adapt4.png",
                                      paddingImg: AppSizing.cardInfoIconsPadding
                                  ),
                                )
                                    : SizedBox.shrink(),

                                widget.escape.pregnant
                                    ? Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: StandardTextIcon(
                                    text: FlutterI18n.translate(context, "mission_additional_5"),
                                      colorText: AppTextStyles.escapeDetailFichaTecnica.color!,
                                      fontSize: AppTextStyles.escapeDetailFichaTecnica.fontSize!,
                                      fontFamily: AppTextStyles.escapeDetailFichaTecnica.fontFamily!,
                                      lineHeight: AppTextStyles.escapeDetailFichaTecnica.height!,
                                      align: TextAlign.start,
                                      imageAsset: "assets/images/icon_adapt5.png",
                                      paddingImg: AppSizing.cardInfoIconsPadding
                                  ),
                                )
                                    : SizedBox.shrink(),

                                widget.escape.english
                                    ? Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: StandardTextIcon(
                                    text: FlutterI18n.translate(context, "mission_additional_6"),
                                    colorText: AppTextStyles.escapeDetailFichaTecnica.color!,
                                    fontSize: AppTextStyles.escapeDetailFichaTecnica.fontSize!,
                                    fontFamily: AppTextStyles.escapeDetailFichaTecnica.fontFamily!,
                                    lineHeight: AppTextStyles.escapeDetailFichaTecnica.height!,
                                    align: TextAlign.start,
                                    imageAsset: "assets/images/icon_adapt6.png",
                                    paddingImg: AppSizing.cardInfoIconsPadding
                                  ),
                                )
                                    : SizedBox.shrink(),
                              ],
                            ) : const SizedBox.shrink(),


                            // MAP AND CONTACT INFORMATION ---------------------
                            const SizedBox(height: AppSizing.sectionsPadding),
                            StandardText(
                              text: FlutterI18n.translate(context, "location_contact"),
                              fontFamily: AppTextStyles.escapeDetailMiniTitle.fontFamily!,
                              fontSize: AppTextStyles.escapeDetailMiniTitle.fontSize!,
                              colorText: AppTextStyles.escapeDetailMiniTitle.color!,
                              lineHeight: 1,
                              align: TextAlign.start,
                            ),

                            const SizedBox(height: 10),
                            _map(escapeLocation, columns_width),

                            const SizedBox(height: 10),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16, right: 16),
                                child: GestureDetector(
                                  onTap: () {
                                    if (widget.escape.latitude != null && widget.escape.longitude != null)
                                      MapUtils.openMap(double.parse(widget.escape.latitude), double.parse(widget.escape.longitude));
                                  },
                                  child: StandardTextIcon(
                                    text: widget.escape.street + ", " + widget.escape.city,
                                    imageAsset: "assets/images/icon_location_detail.png",
                                    paddingImg: 16,
                                    fontFamily: "Kanit_Light",
                                    fontSize: 18,
                                    colorText: AppColors.greyText,
                                    lineHeight: 1,
                                    align: TextAlign.start,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0, left: 16, right: 16),
                              child: GestureDetector(
                                onTap: () {
                                  launchOn("mailto:", widget.escape.email);
                                },
                                child: StandardTextIcon(
                                    text: widget.escape.email,
                                    imageAsset: "assets/images/icon_send_detail.png",
                                    paddingImg: 16,
                                    fontFamily: "Kanit_Light",
                                    fontSize: 18,
                                    colorText: AppColors.greyText,
                                  lineHeight: 1,
                                  align: TextAlign.start,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0, left: 16, right: 16),
                              child: GestureDetector(
                                onTap: () {
                                  launchOn("tel:", widget.escape.phone.replaceAll(RegExp(' +'), ''));
                                },
                                child: StandardTextIcon(
                                    text: widget.escape.phone,
                                    imageAsset: "assets/images/icon_phone_detail.png",
                                    paddingImg: 16,
                                    fontFamily: "Kanit_Light",
                                    fontSize: 18,
                                    colorText: AppColors.greyText,
                                    lineHeight: 1,
                                    align: TextAlign.start,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                launchOn("", widget.escape.url);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10.0, left: 16, right: 16),
                                child: StandardTextIcon(
                                    text: widget.escape.url,
                                    imageAsset: "assets/images/icon_web_detail.png",
                                    paddingImg: 16,
                                    fontFamily: "Kanit_Light",
                                    fontSize: 18,
                                    colorText: AppColors.greyText,
                                    lineHeight: 1,
                                    align: TextAlign.start,
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),


                      // Separator
                      const SizedBox(width: AppSizing.escapeDetailPageColumnsSeparator),


                      // RIGHT Side
                      Container(
                        width: columns_width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            BookingsWidget(
                              escapeRoom: widget.escape,
                            ),

                            const SizedBox(height: 10),

                            widget.escape.images.isNotEmpty ?
                            Image.network(widget.escape.images[0].url) :
                            const SizedBox.shrink(),

                            const SizedBox(height: 10),

                          ],
                        )
                      )
                    ],
                  ),
                ) :
                Text("Mobile version"),


              ]
          )
        ),

      ),
    );

  }

  // -------------------------- MAP FUNCTIONS ------------------------------
  _map(escapeLocation, map_width){
    return Container(
      child: MapboxMap(
        accessToken: MAPBOX.accessToken,
        initialCameraPosition: CameraPosition(
          target: escapeLocation,
          zoom: 14,
        ),
      ),
      width: map_width,
      height: 300,
    );
  }

  void _onDoubleTap() {
    // _controller.zoom += 0.5;
    setState(() {});
  }

  Offset? _dragStart;
  double _scaleStart = 1.0;
  void _onScaleStart(ScaleStartDetails details) {
    _dragStart = details.focalPoint;
    _scaleStart = 1.0;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    final scaleDiff = details.scale - _scaleStart;
    _scaleStart = details.scale;

    if (scaleDiff > 0) {
      // _controller.zoom += 0.02;
      setState(() {});
    } else if (scaleDiff < 0) {
      // _controller.zoom -= 0.02;
      setState(() {});
    } else {
      final now = details.focalPoint;
      final diff = now - _dragStart!;
      _dragStart = now;
      // _controller.drag(diff.dx, diff.dy);
      setState(() {});
    }
  }

  Widget _buildMarkerWidget(Offset pos, Color color) {
    return Positioned(
      left: pos.dx - 16,
      top: pos.dy - 16,
      width: 24,
      height: 24,
      child: Icon(Icons.location_on, color: color),
    );
  }

  String getDifficult(BuildContext ctx, String level) {
    if (level == VARS.LEVEL_EASY)
      return FlutterI18n.translate(ctx, "level_easy");
    else if (level == VARS.LEVEL_MEDIUM)
      return FlutterI18n.translate(ctx, "level_medium");
    else if (level == VARS.LEVEL_HARD)
      return FlutterI18n.translate(ctx, "level_hard");
    else if (level == VARS.LEVEL_EXPERT)
      return FlutterI18n.translate(ctx, "level_expert");
    else
      return "";
  }

  String getAudience(BuildContext ctx, String audience) {
    if (audience == VARS.AUDIENCE_KIDS)
      return FlutterI18n.translate(ctx, "public_kids");
    else if (audience == VARS.AUDIENCE_ADULTS)
      return FlutterI18n.translate(ctx, "public_adults");
    else
      return FlutterI18n.translate(ctx, "public_all");
  }

  launchOn(String type, String value) async {
    var url = type + value;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
