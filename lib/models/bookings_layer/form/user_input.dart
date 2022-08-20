
import 'dart:convert';

class UserInput{
  String user_input_text;
  String user_input_value;
  Map user_input_others_map;

  UserInput(
    {
      required this.user_input_text,
      required this.user_input_value,
      required this.user_input_others_map
    }
  );

  factory UserInput.fromJson(Map<String, dynamic> json){

    return UserInput(
        user_input_text: json["user_input_text"],
        user_input_value: json["user_input_value"],
        user_input_others_map: jsonDecode(json["user_input_others_map"])
    );
  }

  Map toJson() => {
    'user_input_text': user_input_text,
    'user_input_value': user_input_value,
    'user_input_others_map': jsonEncode(user_input_others_map)
  };

}