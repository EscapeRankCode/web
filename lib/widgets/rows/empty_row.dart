import 'package:flutter/material.dart';
import 'package:flutter_escaperank_web/utils/app_colors.dart';

class EmptyRow extends StatelessWidget {
  //
  final double height;
  final double width;

  EmptyRow({Key? key, required this.height, required this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8.0, 12, 8),
      child: Container(
        width: width,
        height:height,
        decoration: BoxDecoration(color: AppColors.blackRow, borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}