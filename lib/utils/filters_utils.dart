import 'package:flutter/material.dart';
import 'package:flutter_escaperank_web/models/topic.dart';

const double LATITUDE_NOT_DEFINED = 100;
const double LONGITUDE_NOT_DEFINED = 100;

class Filters {
  static String filterName = "";
  static String filterNumPeople = "";
  static String filterLocation = "";
  static int filterPositionDifficult = 0;
  static int filterPositionPublic = 0;
  static String filterPublicSelected = "";
  static String filterDifficultSelected = "";
  static RangeValues filterDurationValue = const RangeValues(0, 240);
  static List<Topic> filterSelectedTopics = [];
  static bool filterHearingImpairment = false;
  static bool filterMotorDisability = false;
  static bool filterVisualImpairment = false;
  static bool filterClaustrophobia = false;
  static bool filterEnglish = false;
  static bool filterPregnant = false;
  static bool filterShowMore = false;
  static double filterLatitude = LATITUDE_NOT_DEFINED;
  static double filterLongitude = LONGITUDE_NOT_DEFINED;
  static bool filterSelectedNearMe = false;
  static bool filterDirectBooking = false;
}