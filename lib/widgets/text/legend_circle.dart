import 'package:flutter/material.dart';
import 'package:flutter_escaperank_web/utils/app_colors.dart';

class LegendCircle extends StatelessWidget {
  String text;
  Color color;
  LegendCircle({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8,0,8,0),
      child: Row(
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color),
          ),
          Padding(
            padding: const EdgeInsets.only(left:10.0),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                fontFamily: "Kanit_Light",
                color: AppColors.whiteText,
              ),
            ),
          ),

        ],
      ),
    );
  }
}
