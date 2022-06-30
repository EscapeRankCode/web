import 'dart:convert';
import 'package:flutter_escaperank_web/models/escapist.dart';
import 'package:meta/meta.dart';

class Team {
  final String id;
  final String name;
  final String escapistId;
  final String city;
  final String country;
  final String image;
  final String points;
  final String? participantsCount;
  final List<Escapist> escapists;
  final List<String> externalEscapists;
  bool selected = false;

  Team({required this.id, required this.name, required this.escapistId, required this.city, required this.country,
    required this.image, required this.points, required this.participantsCount, required this.escapists, required this.externalEscapists});

  factory Team.fromJson(Map<String, dynamic> json) {
    List<Escapist> escapistList =[];
    if(json["escapists"] != null) {
      var escapistsFromJson = json["escapists"] as List;
      escapistList = escapistsFromJson.map((i) =>
          Escapist.fromJson(i)).toList();
    }

    List<String> externalList =[];
    if(json["external_escapists"] != null) {
      var externalFromJson = json["external_escapists"] as List;
      externalList = externalFromJson.cast<String>();
      //externalList = externalFromJson.map((i) => String.fromJson(i)).toList();
    }
    return Team(
        id : json["id"].toString(),
        name : json["name"],
        escapistId : json["escapist_id"].toString(),
        city : json["city"],
        country : json["country"],
        image : json["image"],
        escapists: escapistList,
        externalEscapists: externalList,
        points : json["points"].toString(),
        participantsCount : json["participants_count"] != null ? json["participants_count"].toString() : null);
  }

}