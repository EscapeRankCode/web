import 'package:equatable/equatable.dart';
import 'escape_room.dart';
import 'dart:convert';
import 'dart:developer' as developer;

class EscapeRoomsList extends Equatable {

  final int currentPage;
  final int from;
  final int to;
  final String perPage;
  final int total;
  final List<EscapeRoom> escaperooms;

  EscapeRoomsList({required this.currentPage, required this.from, required this.to, required this.perPage,
    required this.escaperooms, required this.total});

  @override
  String toString() => 'List page $currentPage';

  factory EscapeRoomsList.fromJson(Map<String, dynamic> json) {

    var escapesJson = json["data"] as List;

    List<EscapeRoom> escapesList = escapesJson.map((i) => EscapeRoom.fromJson(i)).toList();

    return EscapeRoomsList(
        currentPage: json["current_page"],
        from: json["from"],
        to: json["to"],
        total: json["total"],
        perPage: json["per_page"].toString(),
        escaperooms: escapesList
    );
  }

  @override
  // TODO: implement props
  List<Object> get props => [];

}
