
import 'dart:convert';

import 'package:flutter_escaperank_web/models/bookings_layer/booking/booking_first_step_data.dart';

class BookingFirstStepResponse{
  final String? status;
  final String? code;
  final BookingFirstStepData data;

  BookingFirstStepResponse({
    required this.data,
    this.status,
    this.code
  });

  factory BookingFirstStepResponse.fromJson(Map<String, dynamic> json){
    print("Json response (BookingFirstStepResponse): " + json.toString());
    BookingFirstStepData data = BookingFirstStepData.fromJson(json);

    return BookingFirstStepResponse(data: data);
  }

  String toJsonString(){
    String data_string = "Data: " + jsonEncode(data);
    return data_string;
  }

}