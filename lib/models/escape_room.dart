import 'package:equatable/equatable.dart';
import 'package:flutter_escaperank_web/models/review.dart';
import 'dart:convert';
import 'company.dart';
import 'image_escaperoom.dart';
import 'topic.dart';

class EscapeRoom extends Equatable {
  final int id;
  final int companyId;
  final String description;
  final String name;
  final String phone;
  final String email;
  final String url;
  final String bookingUrl;
  final String street;
  final String city;
  final String state;
  final String postalCode;
  final String cancelPolicy;
  final String difficulty;
  final String audience;
  final String supersaasApiKey;
  final String comments;
  final bool hearingImpairment;
  final bool motorDisability;
  final bool visualImpairment;
  final bool claustrophobia;
  final bool english;
  final bool pregnant;
  final String priceFrom;
  final String priceTo;
  final int numPlayersFrom;
  final int numPlayersTo;
  final int duration;
  final int cancellationHours;
  final Company company;
  final List<Topic> topics;
  final List<ImageEscapeRoom> images;
  final String latitude;
  final String longitude;
  final String externalId;
  final String score;
  List<Review> reviews;
  bool isFaved;

  EscapeRoom({
    required this.id,
    required this.companyId,
    required this.name,
    required this.description,
    required this.phone,
    required this.email,
    required this.url,
    required this.bookingUrl,
    required this.street,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.cancelPolicy,
    required this.difficulty,
    required this.audience,
    required this.supersaasApiKey,
    required this.comments,
    required this.hearingImpairment,
    required this.motorDisability,
    required this.visualImpairment,
    required this.claustrophobia,
    required this.english,
    required this.pregnant,
    required this.priceFrom,
    required this.priceTo,
    required this.numPlayersFrom,
    required this.numPlayersTo,
    required this.duration,
    required this.cancellationHours,
    required this.topics,
    required this.images,
    required this.company,
    required this.latitude,
    required this.longitude,
    required this.externalId,
    required this.isFaved,
    required this.score,
    required this.reviews
  });

  @override
  String toString() => 'Escape Room {$id}';

  factory EscapeRoom.fromJson(Map<String, dynamic> json) {
    List <Topic> topicList = [];
    if(json["topics"] != null) {
      var topicsFromJson = json["topics"] as List;
      topicList = topicsFromJson.map((i) => Topic.fromJson(i)).toList();
    }
    // TODO (TESTING ONLY): Remove hardcoded topics
    topicList = [
      Topic(
          false,
          id: 1,
          name: "Aventuras"
      ),
      Topic(
          false,
          id: 2,
          name: "Criminal"
      ),
      Topic(
          false,
          id: 3,
          name: "Historia"
      ),
    ];
    json['description'] = "¡Infíltrate, cumple con tu objetivo y escapa! Según nuestros informadores, se está experimentando con sustancias sumamente peligrosas en la Mansión Odisea, a las afueras del rancho Trashville. Hemos enviado al equipo Bravo para conseguir más información al respecto, pero han desaparecido sin dejar rastro alguno. Nuestra última conexión con el equipo Bravo fue hace 36 horas. Ante el fracaso de Bravo nos vemos obligados a contratar al mejor equipo de infiltración conocido…. ¡Vosotros! Sois el último as en la manga que tenemos, os necesitamos para saber que está sucediendo. ¿Os atrevéis?";

    List<ImageEscapeRoom> imagesList = [];
    if(json["images"] != null) {
      var imagesFromJson = json["images"] as List;
      imagesList = imagesFromJson.map((i) => ImageEscapeRoom.fromJson(i)).toList();
    }

    List<Review> reviewsList = [];
    if(json["reviews"] != null) {
      var reviewsFromJson = json["reviews"] as List;
      reviewsList = reviewsFromJson.map((i) => Review.fromJson(i)).toList();
    }

    Company company;
    if(json["company"] != null) {
      var companyFromJson = json["company"] as Map<String, dynamic>;
      company = Company.fromJson(companyFromJson);
    }else{
      company = Company(id: -1, name: "Null Company", brandName: "-", phone: "-");
    }
    return EscapeRoom(
        id: json["id"],
        companyId: json["company_id"],
        name: json["name"],
        description: json["description"],
        phone: json["phone"],
        email: json["email"],
        url: json["url"],
        bookingUrl: json["booking_url"],
        street: json["street"],
        city: json["city"],
        state: json["state"] ?? "null",
        postalCode: json["postal_code"],
        cancelPolicy: json["cancel_policy"] ?? "null",
        difficulty: json["difficulty"],
        audience: json["audience"],
        supersaasApiKey: json["supersaas_api_key"] ?? "null",
        comments: json["comments"] ?? "",
        hearingImpairment: json["hearing_impairment"],
        motorDisability: json["motor_disability"],
        visualImpairment: json["visual_impairment"],
        claustrophobia: json["claustrophobia"],
        english: json["english"],
        pregnant: json["pregnant"],
        priceFrom: json["price_from"].toString(),
        priceTo: json["price_to"].toString(),
        numPlayersFrom: json["num_players_from"],
        numPlayersTo: json["num_players_to"],
        duration: json["duration"],
        latitude: json["latitude"] != null ? json["latitude"].toString() : "null",
        longitude: json["longitude"] != null ? json["longitude"].toString() : "null",
        topics: topicList,
        company: company,
        cancellationHours: json["cancellation_hours"] ?? -1,
        isFaved: json["is_favorite"],
        externalId: json["external_id"] ?? "null",
        images: imagesList,
        score: json["score"] != null ? (json["score"].toString().contains(".")? json["score"].toString() :
        json["score"].toString()+".0") : "-",
        reviews: reviewsList
    );
  }

  @override
  // TODO: implement props
  List<Object> get props => [];
}

List<Topic> topicFromJson(String str) =>
    List<Topic>.from(json.decode(str).map((x) => Topic.fromJson(x)));

List<ImageEscapeRoom> imageFromJson(String str) => List<ImageEscapeRoom>.from(
    json.decode(str).map((x) => ImageEscapeRoom.fromJson(x)));
