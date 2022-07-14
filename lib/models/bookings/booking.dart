

import 'package:flutter_escaperank_web/models/escape_room.dart';
import 'package:flutter_escaperank_web/models/escapist.dart';
import 'package:flutter_escaperank_web/models/review.dart';

class Booking {
  final String id;
  final String datetime;
  final String escapistId;
  final String? teamId;
  final String escapeRoomId;
  final String externalReservationId;
  final bool cancelled;
  final EscapeRoom? escapeRoom;
  final String amount;
  final String fee;
  final String total;
  final List<Escapist> escapists;
  final List<Review> reviews;
  final String timezone;


  Booking({required this.id, required this.datetime, required this.escapistId, required this.teamId, required this.escapeRoomId,
    required this.externalReservationId, required this.cancelled, required this.escapeRoom, required this.escapists,
    required this.amount, required this.fee,required this.total, required this.reviews, required this.timezone});

  factory Booking.fromJson(Map<String, dynamic> json) {
    //Escapists
    List<Escapist> escapistsList = [];
    if(json["escapists"] != null) {
      var escapistsFromJson = json["escapists"] as List;
      escapistsList = escapistsFromJson.map((i) => Escapist.fromJson(i)).toList();
    }
    List<Review> reviewsList = [];
    if(json["reviews"] != null) {
      var reviewsFromJson = json["reviews"] as List;
      reviewsList = reviewsFromJson.map((i) => Review.fromJson(i)).toList();
    }

    EscapeRoom? escape;
    if(json["escape_room"] != null) {
      var escapeFromJson = json["escape_room"] as Map<String, dynamic>;
      escape = EscapeRoom.fromJson(escapeFromJson);
    }

    return Booking(
        id: json["id"],
        datetime: json["datetime"],
        escapistId: json["escapist_id"].toString(),
        teamId: json["team_id"]?.toString(),
        escapeRoomId: json["escape_room_id"].toString(),
        externalReservationId: json["external_reservation_id"],
        amount: json["amount"] != null ? json["amount"].toString() : "-",
        fee: json["fee"] != null ? json["fee"].toString() : "-",
        total: json["total"] != null ? json["total"].toString() : "-",
        timezone: json["timezone"] ?? "Europe/Madrid",
        cancelled: json["cancelled"],
        escapeRoom: escape,
        reviews: reviewsList,
        escapists: escapistsList);
  }

}