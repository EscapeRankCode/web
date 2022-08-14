

import 'package:flutter/material.dart';
import 'package:flutter_escaperank_web/widgets/text/standard_text.dart';

class StandardButton extends StatelessWidget {

  Color colorButton;
  VoidCallback onPressed;
  StandardText standardText;

  StandardButton({required this.colorButton, required this.standardText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: colorButton,
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0)
          ),
        ),
        child: standardText,
        onPressed: onPressed,
      ),
    );
  }
}

class StandardDisabledButton extends StatelessWidget {

  Color colorButton;
  StandardText standardText;

  StandardDisabledButton({required this.colorButton, required this.standardText});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: colorButton,
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0)
          ),
        ),
        child: standardText,
        onPressed: null,
      ),
    );
  }
}