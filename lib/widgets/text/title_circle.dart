import 'package:flutter/material.dart';
import 'package:flutter_escaperank_web/utils/app_colors.dart';

class TitleCircle extends StatelessWidget {
  String text;
  TitleCircle({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.yellowPrimary),
        ),
        Padding(
          padding: const EdgeInsets.only(left:10.0),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              fontFamily: "Kanit_Medium",
              color: AppColors.whiteText,
            ),
          ),
        ),

      ],
    );
  }
}