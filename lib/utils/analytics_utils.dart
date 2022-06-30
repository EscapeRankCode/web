import 'package:flutter_escaperank_web/models/escape_room.dart';
// TODO: import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsUtils {
  AnalyticsUtils._();

  // TODO: static FirebaseAnalytics analytics = FirebaseAnalytics();

  static void logEventEscape(String name, String id, String companyId) {
   /* analytics.logEvent(
      name: 'escape_visit',
      parameters: <String, dynamic>{
        'escape_id': id,
        'escape_name': name,
        'company_id': companyId
      },
    );*/
  }

  static void logEventEscaperoom(String name, String id, String companyId) {
   /*  analytics.logEvent(
      name: 'escaperoom_visit',
      parameters: <String, dynamic>{
        'escape_id': id,
        'escape_name': name,
        'company_id': companyId
      },
    ); */
  }

  static void logEventFav(String name, String id, String companyId) {
   /* analytics.logEvent(
      name: 'fav_escape',
      parameters: <String, dynamic>{
        'escape_id': id,
        'escape_name': name,
        'company_id': companyId
      },
    ); */
  }

  static void logEventUnfav(String name, String id, String companyId) {
   /* analytics.logEvent(
      name: 'unfav_escape',
      parameters: <String, dynamic>{
        'escape_id': id,
        'escape_name': name,
        'company_id': companyId
      },
    );*/
  }

  static void logEventBooking(String name, String id, String companyId) {
  /*  analytics.logEvent(
      name: 'booking_escape',
      parameters: <String, dynamic>{
        'escape_id': id,
        'escape_name': name,
        'company_id': companyId
      },
    );*/

  }

  static void logEventSearchEscape(List<EscapeRoom> escapes) {
   /* for (int i = 0; i < escapes.length; i++) {
      analytics.logEvent(
        name: 'escape_search',
        parameters: <String, dynamic>{
          'escape_id': escapes[i].id.toString(),
          'escape_name': escapes[i].name,
          'company_id': escapes[i].companyId.toString(),
        },
      );
    } */
  }


  static void logEventPaymentEscape(List<EscapeRoom> escapes) {
   /* for (int i = 0; i < escapes.length; i++) {
      analytics.logEvent(
        name: 'payment_featured_rows',
        parameters: <String, dynamic>{
          'escape_id': escapes[i].id.toString(),
          'escape_name': escapes[i].name,
          'company_id': escapes[i].companyId.toString(),
        },
      );
    }*/
  }

  static void logEventFeaturedEscape(List<EscapeRoom> escapes) {
   /* for (int i = 0; i < escapes.length; i++) {
      analytics.logEvent(
        name: 'featured_rows',
        parameters: <String, dynamic>{
          'escape_id': escapes[i].id.toString(),
          'escape_name': escapes[i].name,
          'company_id': escapes[i].companyId.toString(),
        },
      );
    }*/
  }
  static void logEventCompany(String name, String id) {
   /* analytics.logEvent(
      name: 'company_visit',
      parameters: <String, dynamic>{
        "company_id": id,
        'company_name': name,
      },
    );*/
  }
}
