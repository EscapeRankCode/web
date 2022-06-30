import 'package:meta/meta.dart';

class PlaceInfoGoogle {
  String city;
  String province;
  String country;
  double latitude;
  double longitude;
  bool searchMoreRadius;

  PlaceInfoGoogle(this.city, this.province, this.country, this.latitude,
      this.longitude, this.searchMoreRadius);
}