


import 'package:flutter/material.dart';
import 'package:flutter_escaperank_web/utils/app_colors.dart';
import 'package:flutter_escaperank_web/utils/app_text_styles.dart';

class FormText extends StatelessWidget {
  String text;
  String errorText;
  TextInputType inputType;
  TextEditingController controller;
  TextInputAction inputAction;
  bool obscureText;
  FocusNode? focus;
  VoidCallback? onTap;

  FormText(
      {
        required this.text,
        required this.errorText,
        required this.inputType,
        required this.controller,
        required this.inputAction,
        required this.obscureText,
        this.focus,
        this.onTap
      }
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          onTap: onTap,
          decoration: InputDecoration(
              labelText: text,
              labelStyle: AppTextStyles.filtersDialogTextInputTitle,
              isDense: true,
              contentPadding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.greyText, width: 1),
                //  when the TextFormField in unfocused
              ) ,
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.greyText, width:1.5),
                //  when the TextFormField in focused
              ) ,
              border: const UnderlineInputBorder(),
          ),
          style: AppTextStyles.filtersDialogTextInputTitle,
          controller: controller,
          keyboardType: inputType,
          textInputAction: inputAction,
          autocorrect: false,
          focusNode: focus,
          obscureText: obscureText,
          cursorColor: AppColors.greyText,
          validator: (value) {
            if (value == null  || value.isEmpty) {
              return errorText;
            }
            return null;
          },
        ),
      ],
    );
  }
}