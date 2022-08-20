
import 'dart:convert';

import 'package:flutter_escaperank_web/models/bookings_layer/form/field_option.dart';
import 'package:flutter_escaperank_web/models/bookings_layer/form/user_input.dart';

class Field{

  static const FIELD_TYPE_CHECK = 1;
  static const FIELD_TYPE_TEXT = 2;
  static const FIELD_TYPE_NUMBER = 3;
  static const FIELD_TYPE_SELECT = 4;
  static const FIELD_TYPE_DATE = 5;
  static const FIELD_TYPE_UNKNOWN = 6;

  final int field_type;
  final bool field_required;
  final String field_key;
  final String field_text;
  final String field_default_value;
  final List<FieldOption>? field_options;
  UserInput? user_input;

  Field(
    {
      required this.field_type,
      required this.field_required,
      required this.field_key,
      required this.field_text,
      required this.field_default_value,
      required this.field_options,
      required this.user_input
    }
  );

  factory Field.fromJson(Map<String, dynamic> json){
    print("Json response (Field): " + json.toString());

    List<FieldOption> field_options = [];
    if(json["field_options"] != null) {
      var fieldOptionsFromJson = json["field_options"] as List;
      print("Json response (Field[field_options]): " + json["field_options"].toString());
      field_options = fieldOptionsFromJson.map((i) => FieldOption.fromJson(i)).toList();
    }

    UserInput? user_input_json;
    if (json["user_input"] != null){
      user_input_json = UserInput.fromJson(json["user_input"]);
    }

    return Field(
        field_type: json["field_type"],
        field_required: json["field_required"],
        field_key: json["field_key"],
        field_text: json["field_text"],
        field_default_value: json["field_default_value"],
        field_options: field_options,
        user_input: user_input_json
    );
  }

  Map toJson() => {
    'field_type': field_type,
    'field_required': field_required,
    'field_key': field_key,
    'field_text': field_text,
    'field_default_value': field_default_value,
    'field_options': jsonEncode(field_options),
    'user_input': jsonEncode(user_input)
  };
  
}