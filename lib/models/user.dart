import 'package:meta/meta.dart';

class User {
  final String name;
  final String email;

  User({required this.name, required this.email});

  User.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        email = json["email"];
}