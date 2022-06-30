import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_escaperank_web/models/escape_room.dart';
import 'package:flutter_escaperank_web/pages/escape/escape_detail_page.dart';
import 'package:flutter_escaperank_web/utils/app_colors.dart';
import 'package:flutter_escaperank_web/utils/app_sizing.dart';
import 'package:flutter_escaperank_web/utils/app_text_styles.dart';
import 'package:flutter_escaperank_web/utils/image_utils.dart';
import 'package:flutter_escaperank_web/widgets/buttons/topic_detail.dart';
import 'package:flutter_escaperank_web/widgets/text/standard_text_icon.dart';
import 'package:image_network/image_network.dart';

class HomeBiggerEscape extends StatelessWidget{
  final EscapeRoom mission;
  Size screen_size = const Size(200, 150);

  HomeBiggerEscape({Key? key, required this.mission}) : super(key: key);

  goToDetailPage(context){
    print("Mission clicked: " + mission.name);
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => EscapeDetailPage(escape: mission)));
  }

  @override
  Widget build(BuildContext context) {
    screen_size = MediaQuery.of(context).size;
    // TODO: CALCULATE SIZES depending on screen size (responsive)
    // double image_width = (screen_size.width - 20) / 4;
    double cardWidth = AppSizing.bigger_cardWidth;
    double cardHeight = AppSizing.bigger_cardHeight;

    return Container(
      width: cardWidth,
      height: cardHeight,
      decoration: BoxDecoration(
        color: AppColors.blackRow,
        borderRadius: BorderRadius.circular(10)),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: (){
            goToDetailPage(context);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ------------------------- ESCAPE IMAGE ------------------------
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)
                ),
                /*
                child: ImageNetwork(
                  image: ImageUtils.getFirstImage(mission.images, true, imageWidth.toInt() , 100),
                  imageCache: CachedNetworkImageProvider(
                      ImageUtils.getFirstImage(mission.images, true, imageWidth.toInt(), 100)
                  ),
                  height: 150,
                  width: imageWidth,
                  fitAndroidIos: BoxFit.cover,
                  fitWeb: BoxFitWeb.cover,
                  onError: ImageNetwork(
                    image: ImageUtils.getFirstImage(mission.images, false, imageWidth.toInt(), 100),
                    imageCache: CachedNetworkImageProvider(
                        ImageUtils.getFirstImage(mission.images, false, imageWidth.toInt(), 100)
                    ),
                    height: 150,
                    width: imageWidth,
                    fitAndroidIos: BoxFit.cover,
                    fitWeb: BoxFitWeb.cover,
                  ),
                ),
                 */
                child: ImageUtils.getFirstImage(mission.images, false) != "null"
                    ? Stack(
                  children:[ ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      child: CachedNetworkImage(
                          imageUrl: ImageUtils.getFirstImage(mission.images, true),
                          errorWidget: (context, url, error) =>
                              CachedNetworkImage(
                                  imageUrl: ImageUtils.getFirstImage(mission.images, false),
                                  height: AppSizing.bigger_cardImageHeight,
                                  width: AppSizing.bigger_cardWidth,
                                  fit: BoxFit.cover),
                          height: AppSizing.bigger_cardImageHeight,
                          width: AppSizing.bigger_cardWidth,
                          fit: BoxFit.cover)
                  ),
                    mission.externalId != "null" ?  Padding(
                      padding: const EdgeInsets.only(top:6.0, left:6.0),
                      child: Image.asset(
                        "assets/images/icon_direct_booking.png",
                      ),
                    ) : const SizedBox.shrink()
                  ],
                )
                    : Stack(
                  children:[
                    Image.asset(
                      "assets/images/logo_app.png",
                      height: AppSizing.bigger_cardImageHeight,
                      width: AppSizing.bigger_cardWidth,
                    ),
                    mission.externalId != "null" ?  Padding(
                      padding: const EdgeInsets.only(top:6.0, left:6.0),
                      child: Image.asset("assets/images/icon_direct_booking.png"),
                    ) : const SizedBox.shrink(),
                  ],
                ),
              ),
              // ------------------------- TEXT CONTENT PADDING ----------------
              Padding(
                padding: const EdgeInsetsDirectional.all(AppSizing.cardGeneralPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ------------------------- ESCAPE NAME -------------------
                    Text(
                      mission.name,
                      style: AppTextStyles.escapeBiggerCardEscapeName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSizing.cardRegularSpaceBetween),

                    // ------------------------- COMPANY NAME ------------------
                    Text(
                      mission.company.name,
                      style: AppTextStyles.escapeBiggerCardCompanyName,
                    ),
                    const SizedBox(height: AppSizing.cardDoubleSpaceBetween),

                    // ------------------------- TOPICS ------------------------
                    mission.topics.isNotEmpty ?
                    Container(
                      height: AppSizing.cardTopicHeight,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(right: AppSizing.topicListMarginBetween),
                        itemCount: mission.topics.length,
                        itemBuilder: (_, index) {
                          return Center(
                            child: TopicCardDetail(
                              id: mission.topics[index].id,
                              name: mission.topics[index].name,
                            ),
                          );
                        },
                      ),
                    ) :
                    const SizedBox(height: 0),
                    const SizedBox(height: AppSizing.cardDoubleSpaceBetween),

                    // ------------------------- DESCRIPTION -------------------
                    Text(
                      mission.description,
                      style: AppTextStyles.escapeBiggerCardDescription,
                      maxLines: AppTextStyles.escapeBiggerCardDescriptionMaxLines,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSizing.cardDoubleSpaceBetween),

                    // ------------------------- ROW INFORMATION ---------------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // ------------------------- NUM PLAYERS AND TIME ------
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // ------------------------- NUM PLAYERS -----------
                            StandardTextIcon(
                                colorText: AppTextStyles.escapeCardInformationLeft.color!,
                                text: mission.numPlayersTo.toString() + "-" + mission.numPlayersTo.toString(),
                                fontSize: AppTextStyles.escapeCardInformationLeft.fontSize!,
                                fontFamily: AppTextStyles.escapeCardInformationLeft.fontFamily!,
                                lineHeight: 1,
                                align: TextAlign.start,
                                imageAsset: "assets/images/icon_location_row.png",
                                paddingImg: AppSizing.cardInfoIconsPadding
                            ),
                            const SizedBox(width: AppSizing.cardDoubleSpaceBetween),

                            // ------------------------- TIME -----------
                            StandardTextIcon(
                                colorText: AppTextStyles.escapeCardInformationLeft.color!,
                                text: mission.duration.toString() + "'",
                                fontSize: AppTextStyles.escapeCardInformationLeft.fontSize!,
                                fontFamily: AppTextStyles.escapeCardInformationLeft.fontFamily!,
                                lineHeight: 1,
                                align: TextAlign.start,
                                imageAsset: "assets/images/icon_time_row.png",
                                paddingImg: AppSizing.cardInfoIconsPadding
                            )

                          ],
                        ),

                        // ------------------------- LOCATION ------------------
                        StandardTextIcon(
                            colorText: AppTextStyles.escapeCardInformationLeft.color!,
                            text: mission.city,
                            fontSize: AppTextStyles.escapeCardInformationLeft.fontSize!,
                            fontFamily: AppTextStyles.escapeCardInformationLeft.fontFamily!,
                            lineHeight: 1,
                            align: TextAlign.start,
                            imageAsset: "assets/images/icon_location_row.png",
                            paddingImg: AppSizing.cardInfoIconsPadding
                        ),
                      ],
                    )

                  ],
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}