
import 'dart:convert';

import 'package:flutter_escaperank_web/models/bookings_layer/booking/booking_second_step_data.dart';

class BookingSecondStepResponse{
  final String? status;
  final String? code;
  final BookingSecondStepData data;

  BookingSecondStepResponse({this.status, this.code, required this.data});

  factory BookingSecondStepResponse.fromJson(Map<String, dynamic> json){
    print("Json response (BookingSecondStepResponse): " + json.toString());
    BookingSecondStepData data = BookingSecondStepData.fromJson(json);

    return BookingSecondStepResponse(data: data);
  }

  String toJsonString(){
    String data_string = "Data: " + jsonEncode(data);
    return data_string;
  }
}