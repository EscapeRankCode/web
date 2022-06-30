import 'package:flutter/material.dart';
import 'package:flutter_escaperank_web/utils/app_colors.dart';
import 'package:flutter_escaperank_web/utils/app_text_styles.dart';
import 'package:flutter_escaperank_web/widgets/text/standard_text.dart';

class DurationSlider extends StatefulWidget {
  RangeValues selectedValue;
  double minValue;
  double maxValue;
  int numDivisions;
  String title;
  final void Function(RangeValues) onChanged;

  DurationSlider(
      {required this.selectedValue,
        required this.minValue,
        required this.maxValue,
        required this.numDivisions,
        required this.onChanged,
        required this.title});

  @override
  _DurationSliderState createState() => _DurationSliderState();
}

class _DurationSliderState extends State<DurationSlider> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StandardText(
          colorText: AppColors.greyText,
          fontFamily: AppTextStyles.filtersDialogTextInputTitle.fontFamily!,
          fontSize: AppTextStyles.filtersDialogTextInputTitle.fontSize!,
          text: widget.title,
          lineHeight: 1,
          align: TextAlign.start,
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      //trackShape: CustomTrackShape(),
                      rangeTrackShape: CustomTrackShape(),
                      //trackHeight: 2.0,
                      //thumbColor: Colors.transparent,
                      //thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0.0),
                    ),
                    child: RangeSlider(
                      values: widget.selectedValue,
                      min: widget.minValue,
                      max: widget.maxValue,
                      divisions: widget.numDivisions,
                      activeColor: AppColors.yellowPrimary,
                      inactiveColor: AppColors.black,
                      onChanged: (RangeValues newValue) {
                        widget.selectedValue = newValue;
                        widget.onChanged(widget.selectedValue);
                      },
                      //label: widget.selectedValue.round().toString(),
                    )),
              ),
            ),
            Container(
              width:80,
              child: Align(
                alignment: Alignment.centerRight,
                child: StandardText(
                  text: widget.selectedValue.start.toInt().toString() +
                      "'" +
                      "-" +
                      widget.selectedValue.end.toInt().toString() +
                      "'",
                  colorText: AppColors.yellowPrimary,
                  fontFamily: "Kanit_Regular",
                  fontSize: 18,
                  lineHeight: 1,
                  align: TextAlign.start,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}

class CustomTrackShape extends RoundedRectRangeSliderTrackShape {
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double? trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}