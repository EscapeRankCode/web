import 'dart:convert';

class BookingSecondStepData{
  final bool booked;
  final String error;
  final Map<String, dynamic> booking_info;

  BookingSecondStepData({
    required this.booked,
    required this.error,
    required this.booking_info
  });

  factory BookingSecondStepData.fromJson(Map<String, dynamic> json_object){
    return BookingSecondStepData(
      booked: json_object["booked"],
      error: json_object["error"],
      booking_info: json.decode(json_object["booking_info"])
    );
  }

  Map toJson() => {
    'booked': booked,
    'error': error,
    'booking_info': booking_info
  };
}