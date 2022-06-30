import 'dart:convert';
import 'package:flutter_escaperank_web/models/team.dart';
import 'package:flutter_escaperank_web/models/user.dart';
import 'package:meta/meta.dart';

class Escapist {
  final String id;
  final String? userId;
  final String username;
  final String birthdate;
  final String gender;
  final String phoneNumber;
  final String city;
  final String image;
  final String province;
  final String country;
  final User? user;
  final bool phoneValidated;
  final String points;
  final String position;
  bool selected;
  String? errors;

  Escapist(
      {required this.userId,
      required this.id,
      required this.username,
      required this.birthdate,
      required this.gender,
      required this.phoneNumber,
      required this.city,
      required this.province,
      required this.country,
      required this.image,
      required this.phoneValidated,
      required this.points,
      required this.user,
      required this.position,
      required this.selected,
      this.errors});

  factory Escapist.fromJson(Map<String, dynamic> json) {
    User? user = null;
    if (json["user"] != null) {
      var userFromJson = json["user"] as Map<String, dynamic>;
      user = User.fromJson(userFromJson);
    }

    return Escapist(
      id: json["id"].toString(),
      userId: json["user_id"].toString(),
      username: json["username"],
      birthdate: json["birthdate"],
      gender: json["gender"],
      phoneNumber: json["phone_number"],
      city: json["city"],
      province: json["province"],
      country: json["country"],
      points: json["points"].toString(),
      image: json["image"],
      phoneValidated: json["phone_validated"],
      user: user,
      position: json["position"].toString(),
      selected: false,
    );
  }
}

List<Team> teamFromJson(String str) => List<Team>.from(json.decode(str).map((x) => Team.fromJson(x)));
