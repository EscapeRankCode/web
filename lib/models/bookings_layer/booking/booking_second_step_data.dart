
class BookingSecondStepData{
  final bool booked;
  final String error;

  BookingSecondStepData({
    required this.booked,
    required this.error
  });

  factory BookingSecondStepData.fromJson(Map<String, dynamic> json_object){
    return BookingSecondStepData(
        booked: json_object["booked"],
        error: json_object["error"]
    );
  }

  Map toJson() => {
    'booked': booked,
    'error': error
  };
}