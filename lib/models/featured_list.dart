import 'package:equatable/equatable.dart';
import 'dart:convert';
import 'escape_room.dart';

class FeaturedList extends Equatable {

  final String title;
  final List<EscapeRoom> escaperooms;

  FeaturedList({required this.title, required this.escaperooms});

  factory FeaturedList.fromJson(Map<String, dynamic> json) {

    var escapesJson = json["escape_rooms"] as List;
    List<EscapeRoom> escapesList = escapesJson.map((i) => EscapeRoom.fromJson(i)).toList();

    return new FeaturedList(
        title: json["title"],
        escaperooms: escapesList
    );
  }

  @override
  // TODO: implement props
  List<Object> get props => [];

}

List<EscapeRoom> escapesFromJson(String str) =>
    List<EscapeRoom>.from(json.decode(str).map((x) => EscapeRoom.fromJson(x)));