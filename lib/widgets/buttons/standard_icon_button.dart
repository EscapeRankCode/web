import 'package:flutter/material.dart';
import 'package:flutter_escaperank_web/widgets/text/standard_text_icon.dart';


class StandardIconButton extends StatelessWidget {

  Color colorButton;
  Function() onPressed;
  StandardTextIcon standardIconText;

  StandardIconButton({Key? key, required this.colorButton, required this.standardIconText, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: colorButton,
          padding: const EdgeInsets.all(16),
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(18.0)),
        ),
        child: standardIconText,
        onPressed: onPressed,
      ),
    );
  }
}
