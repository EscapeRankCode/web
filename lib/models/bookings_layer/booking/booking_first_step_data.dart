import 'dart:convert';

class BookingFirstStepData{
  final bool pre_booked;
  final String error;
  final double total_price;
  final double deposit_price;
  final String currency;
  final Map<String, dynamic> booking_info;

  BookingFirstStepData({
    required this.pre_booked,
    required this.error,
    required this.total_price,
    required this.deposit_price,
    required this.currency,
    required this.booking_info
  });

  factory BookingFirstStepData.fromJson(Map<String, dynamic> json_object){
    return BookingFirstStepData(
      pre_booked: json_object["pre_booked"],
      error: json_object["error"],
      total_price: json_object["total_price"],
      deposit_price: json_object["deposit_price"],
      currency: json_object["currency"],
      booking_info: json.decode(json_object["booking_info"])
    );
  }

  Map toJson() => {
    'pre_booked': pre_booked,
    'error': error,
    'total_price': total_price,
    'deposit_price': deposit_price,
    'currency': currency,
    'booking_info': booking_info
  };

}

/*

    def __init__(self, pre_booked: bool, error: str, total_price: float, deposit_price: float, currency: str, booking_info):
        self.pre_booked = pre_booked
        self.error = error
        self.total_price = total_price
        self.deposit_price = deposit_price
        self.currency = currency
        self.booking_info = booking_info

 */