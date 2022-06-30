import 'package:flutter/material.dart';
import 'package:flutter_escaperank_web/utils/app_colors.dart';
import 'package:flutter_escaperank_web/utils/app_text_styles.dart';
import 'package:flutter_escaperank_web/widgets/text/standard_text.dart';


class TopicCardDetail extends StatelessWidget {
  final String name;
  int id;

  TopicCardDetail({
    required this.name,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right:15),
      child: Container(
          decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: AppColors.yellowPrimary),
              borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: StandardText(
              fontSize: AppTextStyles.escapeCardTopic.fontSize!,
              text: name,
              fontFamily: AppTextStyles.escapeCardTopic.fontFamily!,
              colorText: AppTextStyles.escapeCardTopic.color!,
              align: TextAlign.center, lineHeight: 1,)),
    );
  }
}


class TopicPageDetail extends StatelessWidget {
  final String name;
  int id;

  TopicPageDetail({
    required this.name,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right:15),
      child: Container(
          decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: AppColors.yellowPrimary),
              borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: StandardText(
            fontSize: AppTextStyles.escapeDetailTopic.fontSize!,
            text: name,
            fontFamily: AppTextStyles.escapeDetailTopic.fontFamily!,
            colorText: AppTextStyles.escapeDetailTopic.color!,
            align: TextAlign.center, lineHeight: 1,)),
    );
  }
}
