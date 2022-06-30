import 'package:flutter/material.dart';

class StandardMinRowText extends StatelessWidget {
  Color colorText;
  String text;
  double fontSize;
  String fontFamily;
  double lineHeight;
  TextAlign align;
  StandardMinRowText({Key? key, required this.colorText, required this.text, required this.fontSize, required this.fontFamily, required this.lineHeight, required this.align}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      style: TextStyle(
        letterSpacing: 0.4,
        fontSize: fontSize,
        fontFamily: fontFamily,
        color: colorText,
        height: lineHeight,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

