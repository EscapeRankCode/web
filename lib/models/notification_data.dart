import 'package:equatable/equatable.dart';
import 'package:flutter_escaperank_web/models/escapist.dart';
import 'package:flutter_escaperank_web/models/team.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

class NotificationData extends Equatable {

  final Team? team;
  final Escapist? escapistWhoAdded;

  NotificationData({required this.team, required this.escapistWhoAdded});

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    Team? team;
    if (json["team"] != null) {
      var teamFromJson = json["team"] as Map<String, dynamic>;
      team = Team.fromJson(teamFromJson);
    }
    Escapist? escapistWhoAddedYou;
    if (json["escapist_who_added_you"] != null) {
      var escapistFromJson = json["escapist_who_added_you"] as Map<String, dynamic>;
      escapistWhoAddedYou = Escapist.fromJson(escapistFromJson);
    }

    return NotificationData(
      team: team,
      escapistWhoAdded: escapistWhoAddedYou
    );
  }

  @override
  // TODO: implement props
  List<Object> get props => [];

}

