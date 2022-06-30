import 'dart:convert';
import 'package:flutter_escaperank_web/configuration.dart';
import 'package:flutter_escaperank_web/models/place_info_google.dart';
import 'package:flutter_escaperank_web/utils/filters_utils.dart';
import 'package:flutter_escaperank_web/utils/places_utils.dart';
import 'package:flutter_escaperank_web/widgets/cards/filters/filters_dialog_card.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class UserUtils {

  UserUtils._();

  static Future<List<dynamic>> getSuggestion(String input, String token) async {
    List<dynamic> _placeList;
    List<dynamic> _placeFinalList = [];
    String placesApiKey = Places.API_PLACES;
    String request = Places.AUTOCOMPLETE_URL + 'types: ["(cities)"]&input=$input&key=$placesApiKey&components=country:es&sessiontoken=$token';
    var response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      _placeList = json.decode(response.body)['predictions'];
      for(int i =0; i < _placeList.length; i++){
        for(int x =0; x < _placeList[i]["types"].length; x++){
          if(_placeList[i]["types"][x].toString() == "locality"){
            _placeFinalList.add(_placeList[i]);
            break;
          }
        }
      }
      return _placeFinalList;
    } else {
      throw Exception('Failed to get suggestion');
    }
  }

  static Future<Position?> determinePosition(bool firstLoad) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return await null;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      if (firstLoad) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          return await null;
        } else {
          await Geolocator.getCurrentPosition();
        }
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return await null;
      } else {
        await Geolocator.getCurrentPosition();
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return await null;
    }

    return await Geolocator.getCurrentPosition();
  }

  static Future<PlaceInfoGoogle> getPlaceInfo(String placeId, String token) async {
    List<dynamic> _placeInfo;
    PlaceInfoGoogle infoGooogle = PlaceInfoGoogle("null", "null", "null", LATITUDE_NOT_DEFINED, LONGITUDE_NOT_DEFINED, false);
    String placesApiKey = Places.API_PLACES;
    String request = Places.PLACES_URL + 'types: ["(cities)"]&place_id=$placeId&key=$placesApiKey&components=country:es&sessiontoken=$token&language=es';
    var response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      _placeInfo = json.decode(response.body)['result']['address_components'];
      for (int i = 0; i < _placeInfo.length; i++) {
        if (_placeInfo[i]['types'][0] == "locality") {
          infoGooogle.city = _placeInfo[i]['long_name'];
        } else if (_placeInfo[i]['types'][0] == "administrative_area_level_2") {
          infoGooogle.province = _placeInfo[i]['long_name'];
        } else if (_placeInfo[i]['types'][0] == "administrative_area_level_1" && infoGooogle.province == null) {
          infoGooogle.province = _placeInfo[i]['long_name'];
        } else if (_placeInfo[i]['types'][0] == "country") {
          infoGooogle.country = _placeInfo[i]['long_name'];
        }
        infoGooogle.latitude = json.decode(response.body)['result']['geometry']['location']['lat'];
        infoGooogle.longitude = json.decode(response.body)['result']['geometry']['location']['lng'];
      }
      if(infoGooogle.province == "null") {
        infoGooogle.province = infoGooogle.country;
      }
      if(infoGooogle.city == "null") {
        infoGooogle.city = infoGooogle.province;
        infoGooogle.searchMoreRadius = true;
      }else {
        infoGooogle.searchMoreRadius = false;
      }
      return infoGooogle;
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  static int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }
}