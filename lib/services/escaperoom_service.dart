import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import '../configuration.dart';
import '../models/escape_room.dart';
import '../models/escaperooms_list.dart';
import '../models/featured_list.dart';
import '../models/filter_escaperoom.dart';
import '../models/topic_list.dart';
import 'package:flutter_escaperank_web/utils/filters_utils.dart';

abstract class EscapeRoomService {
  Future<EscapeRoomsList?> searchEscapeRooms(
      FiltersEscapeRoom filters, String token);

  Future<EscapeRoomsList?> getNewMissions(String token);

  Future<EscapeRoomsList?> getFavs(String token);

  Future<FeaturedList?> getFeatured(
      double latitude, double longitude, int radius);

  Future<EscapeRoomsList?> getNearMissions(
      double latitude, double longitude, int radius, String token);

  Future<EscapeRoomsList?> getHomeMissions(double latitude, double longitude,
      int radius, String topicId, String token);

  Future<EscapeRoomsList?> getPaymentMissions(double latitude, double longitude, String token);

  Future<EscapeRoomsList?> getMissionsByCompany(int companyId, String token, int page);

  Future<TopicList?> getTopics();

  Future<void> makeFav(String token, String escapeRoomId);

  Future<void> makeUnfav(String token, String escapeRoomId);
}

class EscapeRoomServices extends EscapeRoomService {

  Map<String, dynamic> getFilters(FiltersEscapeRoom filters) {
    Map<String, dynamic> _queryParameters = <String, dynamic>{
      'limit': filters.limit.toString(),
      'page': filters.page.toString()
    };
    //Name
    if (filters.name.isNotEmpty) _queryParameters['name'] = filters.name;
    //Location
    if (filters.latitude != LATITUDE_NOT_DEFINED.toString() && filters.longitude != LONGITUDE_NOT_DEFINED.toString()) {
      _queryParameters['longitude'] = filters.longitude;
      _queryParameters['latitude'] = filters.latitude;
      _queryParameters['radius'] = filters.searchMoreRadius ? "500": "30";
    } else {
      _queryParameters['randomize'] = "true";
    }
    //Difficult
    if (filters.difficulty.toInt() == 1) {
      _queryParameters['difficulty'] = "easy";
    } else if (filters.difficulty.toInt() == 2) {
      _queryParameters['difficulty'] = "medium";
    } else if (filters.difficulty.toInt() == 3) {
      _queryParameters['difficulty'] = "hard";
    } else if (filters.difficulty.toInt() == 4) {
      _queryParameters['difficulty'] = "expert";
    }
    //Num Players
    if (filters.numPlayers.isNotEmpty) {
      _queryParameters['num_players'] = filters.numPlayers;
    }
    //Topics
    List<String> topics = [];
    for (int i = 0; i < filters.topics.length; i++) {
      topics.add(filters.topics[i].id.toString());
    }
    if (topics.isNotEmpty) _queryParameters['topics[]'] = topics;

    List<String> audience = [];
    //audience_flags
    if (filters.motor) audience.add("motor_disability");
    if (filters.visual) audience.add("visual_impairment");
    if (filters.hearing) audience.add("hearing_impairment");
    if (filters.pregnant) audience.add("pregnant");
    if (filters.claustrophobia) audience.add("claustrophobia");
    if (filters.english) audience.add("english");


    if (audience.isNotEmpty) _queryParameters['audience_flags[]'] = audience;

    //audience
    if (filters.audience == 1) {
      _queryParameters['audience'] = "kids";
    } else if (filters.audience == 2) {
      _queryParameters['audience'] = "adults";
    } else if (filters.audience == 3) {
      _queryParameters['audience'] = "all";
    }

    //duration
    _queryParameters['duration_min'] =
        filters.duration.start.toInt().toString();
    //No filter max if duration is 240'
    if(filters.duration.end.toInt() < 240) {
      _queryParameters['duration_max'] = filters.duration.end.toInt().toString();
    }

    print("Query parameters: " + _queryParameters.toString());

    return _queryParameters;
  }

  @override
  Future<EscapeRoomsList?> searchEscapeRooms(FiltersEscapeRoom filters, String token) async {
    var _query = getFilters(filters);

    developer.log("Query: " + _query.toString(), name: "escaperoom_service");
    developer.log("ApiKey: " + API.apiKey, name: "escaperoom_service");
    developer.log("Token: " + token, name: "escaperoom_service");

    Uri uri = Uri.https(API.baseURL, API.searchEscapeRoom, _query);

    developer.log("URL: " + uri.toString(), name: "escaperoom_service");
    print("Print url: " + uri.toString());

    final response = await http.get(
      uri,
      headers: {
        'ApiKey': API.apiKey,
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    developer.log("Response --> Status Code: " + response.statusCode.toString(), name: "escaperoom_service");
    developer.log("Response --> Body: " + response.body, name: "escaperoom_service");

    if (response.statusCode == RESPONSES.RESPONSE_OK) {
      dynamic body = json.decode(response.body);

      // TODO: TESTING ONLY
      developer.log("Response --> Body decoded: " + body.toString(), name: "escaperoom_service");
      EscapeRoomsList escapes = EscapeRoomsList.fromJson(body);
      developer.log("Response --> Results length: " + escapes.total.toString(), name: "escaperoom_service");

      return EscapeRoomsList.fromJson(body);
    }

    developer.log("Response --> Response status code again: " + response.statusCode.toString(), name: "escaperoom_service");

    return null;
  }

  @override
  Future<EscapeRoomsList?> getNewMissions(String token) async {
    final Map<String, String> _queryParameters = <String, String>{
      'order': "created_at",
      'order_direction': "desc",
      'limit': "10"
    };
    /* if(latitude != null && longitude != null){
      _queryParameters['longitude'] = longitude.toString();
      _queryParameters['latitude'] = latitude.toString();
      _queryParameters['radius'] = "1000000";
    } */
    Uri uri = Uri.https(API.baseURL, API.searchEscapeRoom, _queryParameters);
    final response = await http.get(
      uri,
      headers: {
        'ApiKey': API.apiKey,
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == RESPONSES.RESPONSE_OK) {
      dynamic body = json.decode(response.body);
      return EscapeRoomsList.fromJson(body);
    }

    return null;
  }

  @override
  Future<EscapeRoomsList?> getFavs(String token) async {
    final Map<String, String> _queryParameters = <String, String>{
      'only_favorites': "true",
      'order': "created_at",
      'order_direction': "desc",
      'limit': "50"
    };

    Uri uri = Uri.https(API.baseURL, API.searchEscapeRoom, _queryParameters);
    final response = await http.get(
      uri,
      headers: {
        'ApiKey': API.apiKey,
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == RESPONSES.RESPONSE_OK) {
      dynamic body = json.decode(response.body);
      return EscapeRoomsList.fromJson(body);
    }

    return null;
  }

  @override
  Future<FeaturedList?> getFeatured(
      double latitude, double longitude, int radius) async {
    final Map<String, dynamic> _queryParameters = <String, dynamic>{};

    if (latitude != null && longitude != null) {
      _queryParameters['longitude'] = longitude.toString();
      _queryParameters['latitude'] = latitude.toString();
      _queryParameters['radius'] = "1000000";
      //_queryParameters['order'] = "1000000";
    } else {
      _queryParameters['randomize'] = "true";
    }
    _queryParameters['distinct_company'] = "true";
    Uri uri = Uri.https(API.baseURL, API.getFeatured, _queryParameters);
    final response = await http.get(
      uri,
      headers: {'ApiKey': API.apiKey},
    );

    if (response.statusCode == RESPONSES.RESPONSE_OK) {
      dynamic body = json.decode(response.body);
      return FeaturedList.fromJson(body);
    }

    return null;
  }

  @override
  Future<void> makeFav(String token, String escapeRoomId) async {
    Uri uri = Uri.https(API.baseURL, API.makeFav);
    await http.post(uri, headers: {
      'ApiKey': API.apiKey,
      'Authorization': "Bearer " + token,
    }, body: {
      "escape_room_id": escapeRoomId
    });
    //dynamic body = json.decode(response.body);
  }

  @override
  Future<void> makeUnfav(String token, String escapeRoomId) async {
    Uri uri = Uri.https(API.baseURL, API.makeUnfav);
    await http.post(uri, headers: {
      'ApiKey': API.apiKey,
      'Authorization': "Bearer " + token,
    }, body: {
      "escape_room_id": escapeRoomId
    });
  }

  @override
  Future<EscapeRoomsList?> getHomeMissions(double? latitude, double? longitude,
      int radius, String topic, String token) async {
    final Map<String, dynamic> _queryParameters = <String, dynamic>{
      'distinct_company': "true",
      'limit': "10",
      'topics[]': topic,
    };

    if (latitude != null && longitude != null) {
      _queryParameters['longitude'] = longitude.toString();
      _queryParameters['latitude'] = latitude.toString();
      _queryParameters['radius'] = "1000000";
      //_queryParameters['order'] = "1000000";
    } else {
      _queryParameters['randomize'] = "true";
    }

    Uri uri = Uri.https(API.baseURL, API.searchEscapeRoom, _queryParameters);
    final response = await http.get(
      uri,
      headers: {
        'ApiKey': API.apiKey,
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == RESPONSES.RESPONSE_OK) {
      dynamic body = json.decode(response.body);
      return EscapeRoomsList.fromJson(body);
    }

    return null;
  }

  @override
  Future<EscapeRoomsList?> getPaymentMissions(double latitude, double longitude, String token) async {

    final Map<String, dynamic> _queryParameters = <String, dynamic>{
      'is_featured': "true"
    };

    if (latitude != null && longitude != null) {
      _queryParameters['longitude'] = longitude.toString();
      _queryParameters['latitude'] = latitude.toString();
    }
    Uri uri = Uri.https(API.baseURL, API.searchEscapeRoom, _queryParameters);
    final response = await http.get(
      uri,
      headers: {
        'ApiKey': API.apiKey,
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == RESPONSES.RESPONSE_OK) {
      dynamic body = json.decode(response.body);
      return EscapeRoomsList.fromJson(body);
    }

    return null;
  }

  @override
  Future<EscapeRoomsList?> getMissionsByCompany(int id, String token, int page) async {
    final Map<String, String> _queryParameters = <String, String>{
      'company_id': id.toString(),
      'page': page.toString(),
      'limit': "20"
    };
    Uri uri = Uri.https(API.baseURL, API.searchEscapeRoom, _queryParameters);
    final response = await http.get(
      uri,
      headers: {
        'ApiKey': API.apiKey,
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == RESPONSES.RESPONSE_OK) {
      dynamic body = json.decode(response.body);
      return EscapeRoomsList.fromJson(body);
    }

    return null;
  }

  Future<EscapeRoom?> getMissionsById(String id, String token) async {
    Uri uri = Uri.https(API.baseURL, API.searchEscapeRoom + "/$id");
    final response = await http.get(
      uri,
      headers: {
        'ApiKey': API.apiKey,
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == RESPONSES.RESPONSE_OK) {
      dynamic body = json.decode(response.body);
      return EscapeRoom.fromJson(body);
    }

    return null;
  }

  @override
  Future<EscapeRoomsList?> getNearMissions(
      double latitude, double longitude, int radius, String token) async {
    final Map<String, String> _queryParameters = <String, String>{
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'radius': radius.toString(),
      'limit': "10"
    };
    Uri uri = Uri.https(API.baseURL, API.searchEscapeRoom, _queryParameters);
    final response = await http.get(
      uri,
      headers: {
        'ApiKey': API.apiKey,
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == RESPONSES.RESPONSE_OK) {
      dynamic body = json.decode(response.body);
      return EscapeRoomsList.fromJson(body);
    }

    return null;
  }

  @override
  Future<TopicList?> getTopics() async {
    Uri uri = Uri.https(API.baseURL, API.getTopics);
    final response = await http.get(
      uri,
      headers: {
        'ApiKey': API.apiKey,
      },
    );

    if (response.statusCode == RESPONSES.RESPONSE_OK) {
      List<dynamic> body = json.decode(response.body);
      //dynamic body = json.decode(response.body);
      return TopicList.fromJson(body);
    }

    return null;
  }
}
