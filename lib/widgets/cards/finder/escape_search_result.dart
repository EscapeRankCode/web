
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_escaperank_web/models/escape_room.dart';
import 'package:flutter_escaperank_web/utils/app_colors.dart';
import 'package:flutter_escaperank_web/utils/image_utils.dart';
import 'package:flutter_escaperank_web/widgets/text/standard_row_text_.dart';
import 'package:flutter_escaperank_web/widgets/text/standard_text_icon.dart';

class EscapeSearchResult extends StatelessWidget {
  //
  final EscapeRoom escape;
  final Function() onTap;
  EscapeSearchResult({required this.escape, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8.0, 12, 8),
        child: Container(
          //color: Colors.white,
          decoration: BoxDecoration(
              color: AppColors.blackRow,
              borderRadius: BorderRadius.circular(10)),
          //
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageUtils.getFirstImage(escape.images, false) != null
                  ? Stack(
                children:[ ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10)),
                    child: CachedNetworkImage(
                        imageUrl: ImageUtils.getFirstImage(escape.images, true),
                        errorWidget: (context, url, error) =>
                            CachedNetworkImage(
                                imageUrl: ImageUtils.getFirstImage(escape.images, false),
                                height: 180,
                                width: 120,
                                fit: BoxFit.cover),
                        height: 180,
                        width: 120,
                        fit: BoxFit.cover)),

                  escape.externalId!= null ?  Padding(
                    padding: const EdgeInsets.only(top:6.0, left:6.0),
                    child: Image.asset("assets/images/icon_direct_booking.png"),
                  ) : SizedBox.shrink(),
                ],
              )
                  : Stack(
                children:[ Image.asset("assets/images/logo_app.png",
                    height: 180, width: 120),
                  escape.externalId!= null ?  Padding(
                    padding: const EdgeInsets.only(top:6.0, left:6.0),
                    child: Image.asset("assets/images/icon_direct_booking.png"),
                  ) : SizedBox.shrink(),
                ],
              ),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(12, 16.0, 12, 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StandardRowText(
                        text: escape.name,
                        fontFamily: "Kanit_Regular",
                        fontSize: 15,
                        colorText: AppColors.yellowPrimary, lineHeight: 1, align: TextAlign.start,
                      ),
                      StandardRowText(
                        text: escape.company!= null ? escape.company.brandName : "",
                        fontFamily: "Kanit_Light",
                        fontSize: 15,
                        colorText: AppColors.white, lineHeight: 1, align: TextAlign.start,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child:StandardTextIcon(
                          text: escape.city,
                          fontFamily: "Kanit_Light",
                          fontSize: 14,
                          paddingImg: 4,
                          colorText: AppColors.greyText,
                          imageAsset: "assets/images/icon_location_row.png",
                          lineHeight: 1, align: TextAlign.start,
                        ),

                        /*StandardRowText(
                          text: escape.company.brandName + " - " + escape.city,
                          fontFamily: "Kanit_Light",
                          fontSize: 12,
                          colorText: AppColors.white,
                        )*/

                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                            escape.description
                                .replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ''),
                            style: const TextStyle(
                                fontFamily: "Kanit_Light",
                                fontSize: 14,
                                color: AppColors.greyText),
                              maxLines: 2,
                            ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            StandardTextIcon(
                              text: escape.numPlayersFrom.toString() +
                                  "-" +
                                  escape.numPlayersTo.toString(),
                              fontFamily: "Kanit_Light",
                              fontSize: 13,
                              paddingImg: 4,
                              colorText: AppColors.greyText,
                              imageAsset: "assets/images/icon_people_row.png",
                              lineHeight: 1, align: TextAlign.start,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: StandardTextIcon(
                                text: escape.duration.toString() + "'",
                                fontFamily: "Kanit_Light",
                                fontSize: 13,
                                paddingImg: 4,
                                colorText: AppColors.greyText,
                                imageAsset: "assets/images/icon_time_row.png",
                                lineHeight: 1, align: TextAlign.start,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: StandardTextIcon(
                                text: escape.score != null ? escape.score.toString() : "-",
                                fontFamily: "Kanit_Light",
                                fontSize: 13,
                                paddingImg: 4,
                                colorText: AppColors.greyText,
                                imageAsset: "assets/images/icon_rating_row.png",
                                lineHeight: 1, align: TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}