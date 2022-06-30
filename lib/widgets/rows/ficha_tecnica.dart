import 'package:flutter/material.dart';
import 'package:flutter_escaperank_web/configuration.dart';
import 'package:flutter_escaperank_web/models/escape_room.dart';
import 'package:flutter_escaperank_web/utils/app_colors.dart';
import 'package:flutter_escaperank_web/utils/app_sizing.dart';
import 'package:flutter_escaperank_web/utils/app_text_styles.dart';
import 'package:flutter_escaperank_web/widgets/text/standard_text.dart';
import 'package:flutter_escaperank_web/widgets/text/standard_text_icon.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class FichaTecnica extends StatelessWidget{
  final EscapeRoom escape;


  const FichaTecnica({Key? key,
    required this.escape}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StandardTextIcon(
            colorText: AppTextStyles.escapeDetailFichaTecnica.color!,
            text: escape.numPlayersFrom.toString() + "-" + escape.numPlayersTo.toString(),
            fontSize: AppTextStyles.escapeDetailFichaTecnica.fontSize!,
            fontFamily: AppTextStyles.escapeDetailFichaTecnica.fontFamily!,
            lineHeight: AppTextStyles.escapeDetailFichaTecnica.height!,
            align: TextAlign.start,
            imageAsset: "assets/images/icon_people_row.png",
            paddingImg: AppSizing.cardInfoIconsPadding
        ),

        const SizedBox(width: AppSizing.escapeDetailFichaTecnicaPadding),

        StandardTextIcon(
            text: escape.duration.toString() + "'",
            colorText: AppTextStyles.escapeDetailFichaTecnica.color!,
            fontSize: AppTextStyles.escapeDetailFichaTecnica.fontSize!,
            fontFamily: AppTextStyles.escapeDetailFichaTecnica.fontFamily!,
            lineHeight: AppTextStyles.escapeDetailFichaTecnica.height!,
            align: TextAlign.start,
            imageAsset: "assets/images/icon_time_row.png",
            paddingImg: AppSizing.cardInfoIconsPadding
        ),

        const SizedBox(width: AppSizing.escapeDetailFichaTecnicaPadding),

        StandardTextIcon(
            colorText: AppTextStyles.escapeDetailFichaTecnica.color!,
            text: getDifficult(context, escape.difficulty),
            fontSize: AppTextStyles.escapeDetailFichaTecnica.fontSize!,
            fontFamily: AppTextStyles.escapeDetailFichaTecnica.fontFamily!,
            lineHeight: AppTextStyles.escapeDetailFichaTecnica.height!,
            align: TextAlign.start,
            imageAsset: "assets/images/icon_time_row.png",
            paddingImg: AppSizing.cardInfoIconsPadding
        ),

        const SizedBox(width: AppSizing.escapeDetailFichaTecnicaPadding),

        StandardTextIcon(
            colorText: AppTextStyles.escapeDetailFichaTecnica.color!,
            text: getAudience(context, escape.audience),
            fontSize: AppTextStyles.escapeDetailFichaTecnica.fontSize!,
            fontFamily: AppTextStyles.escapeDetailFichaTecnica.fontFamily!,
            lineHeight: AppTextStyles.escapeDetailFichaTecnica.height!,
            align: TextAlign.start,
            imageAsset: "assets/images/icon_time_row.png",
            paddingImg: AppSizing.cardInfoIconsPadding
        ),

        const SizedBox(width: AppSizing.escapeDetailFichaTecnicaPadding),

        escape.externalId != "null" ?
        StandardTextIcon(
            colorText: AppTextStyles.escapeDetailFichaTecnica.color!,
            text: "100 pts",
            fontSize: AppTextStyles.escapeDetailFichaTecnica.fontSize!,
            fontFamily: AppTextStyles.escapeDetailFichaTecnica.fontFamily!,
            lineHeight: AppTextStyles.escapeDetailFichaTecnica.height!,
            align: TextAlign.start,
            imageAsset: "assets/images/icon_target_row.png",
            paddingImg: AppSizing.cardInfoIconsPadding
        ) : const SizedBox.shrink(),

      ],
    );
  }

  String getDifficult(BuildContext ctx, String level) {
    if (level == VARS.LEVEL_EASY) {
      return FlutterI18n.translate(ctx, "level_easy");
    } else if (level == VARS.LEVEL_MEDIUM) {
      return FlutterI18n.translate(ctx, "level_medium");
    } else if (level == VARS.LEVEL_HARD) {
      return FlutterI18n.translate(ctx, "level_hard");
    } else if (level == VARS.LEVEL_EXPERT) {
      return FlutterI18n.translate(ctx, "level_expert");
    } else {
      return "";
    }
  }

  String getAudience(BuildContext ctx, String audience) {
    if (audience == VARS.AUDIENCE_KIDS) {
      return FlutterI18n.translate(ctx, "public_kids");
    } else if (audience == VARS.AUDIENCE_ADULTS) {
      return FlutterI18n.translate(ctx, "public_adults");
    } else {
      return FlutterI18n.translate(ctx, "public_all");
    }
  }


}