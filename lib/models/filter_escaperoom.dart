import 'package:flutter/material.dart';
import 'package:flutter_escaperank_web/models/topic.dart';

class FiltersEscapeRoom  {

  final String name;
  final String latitude;
  final String longitude;
  final int difficulty;
  final RangeValues duration;
  final String numPlayers;
  final List<Topic> topics;
  final int audience;
  final bool hearing;
  final bool motor;
  final bool visual;
  final bool pregnant;
  final bool claustrophobia;
  final bool english;
  final int limit;
  final bool searchMoreRadius;
  final bool directBooking;
  int page;

  FiltersEscapeRoom({required this.name,
    required this.latitude,
    required this.longitude,
    required this.difficulty,
    required this.numPlayers,
    required this.topics,
    required this.audience,
    required this.hearing,
    required this.motor,
    required this.duration,
    required this.visual,
    required this.pregnant,
    required this.claustrophobia,
    required this.english,
    required this.limit,
    required this.searchMoreRadius,
    required this.page,
    required this.directBooking});

}
