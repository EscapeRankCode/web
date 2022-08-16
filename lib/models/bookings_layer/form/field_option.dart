import 'dart:convert';

class FieldOption{

  final String option_text;
  final String option_value;
  final Map option_others_map;

  FieldOption(
      {
        required this.option_text,
        required this.option_value,
        required this.option_others_map
      }
      );

  factory FieldOption.fromJson(Map<String, dynamic> json){

    return FieldOption(
        option_text: json["option_text"],
        option_value: json["option_value"],
        option_others_map: jsonDecode(json["option_others_map"])
    );
  }

}