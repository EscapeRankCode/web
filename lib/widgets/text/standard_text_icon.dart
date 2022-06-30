import 'package:flutter/material.dart';

class StandardTextIcon extends StatelessWidget {
  Color colorText;
  String text;
  double fontSize;
  String fontFamily;
  double lineHeight;
  TextAlign align;
  String imageAsset;
  double paddingImg;
  int max_characters = -1;
  StandardTextIcon({Key? key, required this.colorText, required this.text,
    required this.fontSize, required this.fontFamily, required this.lineHeight,
    required this.align, required this.imageAsset, required this.paddingImg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(right:paddingImg),
          child: Image.asset(imageAsset),
        ),
        Flexible(
          child: Text(
            text,
            textAlign: align,
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: fontFamily,
              color: colorText,
              height: lineHeight,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,

          ),
        ),

      ],
    );
  }
}

