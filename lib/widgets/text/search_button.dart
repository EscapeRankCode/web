import 'package:flutter/material.dart';
import 'package:flutter_escaperank_web/utils/app_colors.dart';
import 'package:flutter_escaperank_web/widgets/text/standard_text.dart';

class SearchButton extends StatelessWidget {

  Function() onTap;
  String text;
  double? max_width;

  SearchButton({Key? key, required this.onTap, required this.text, this.max_width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
        child: Container(
          width: max_width,
          decoration: BoxDecoration(
              color:AppColors.blackRow,
              borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                  Image.asset("assets/images/icon_search.png"),
                  Padding(
                    padding: const EdgeInsets.only(left:12.0),
                    child: StandardText(
                      fontSize: 15,
                      fontFamily: "Kanit_Light",
                      colorText: AppColors.greyText,
                      text: text,
                      align: TextAlign.center,
                      lineHeight: 1,
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
