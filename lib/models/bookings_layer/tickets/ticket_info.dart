abstract class TicketInfo{}

class TicketInfoOption implements TicketInfo{
  final bool default_value;
  final int single_unit_value;
  final double price_per_unit;
  final String currency;

  TicketInfoOption(
    {
      required this.default_value,
      required this.single_unit_value,
      required this.price_per_unit,
      required this.currency
    }
  );

  factory TicketInfoOption.fromJson(Map<String, dynamic> json){
    return TicketInfoOption(
        default_value: json["default"],
        single_unit_value: json["single_unit_value"],
        price_per_unit: json["price_per_unit"],
        currency: json["currency"]
    );
  }
}

class TicketInfoCheck implements TicketInfo{
  final bool default_value;
  final int single_unit_value;
  final double price_per_unit;
  final String currency;

  TicketInfoCheck(
      {
        required this.default_value,
        required this.single_unit_value,
        required this.price_per_unit,
        required this.currency
      }
      );

  factory TicketInfoCheck.fromJson(Map<String, dynamic> json){
    return TicketInfoCheck(
        default_value: json["default"],
        single_unit_value: json["single_unit_value"],
        price_per_unit: json["price_per_unit"],
        currency: json["currency"]
    );
  }
}

class TicketInfoCounter implements TicketInfo{
  final int min_option;
  final int max_option;
  final int default_value;
  final int single_unit_value;
  final double price_per_unit;
  final String currency;

  TicketInfoCounter(
    {
      required this.min_option,
      required this.max_option,
      required this.default_value,
      required this.single_unit_value,
      required this.price_per_unit,
      required this.currency
    }
  );

  factory TicketInfoCounter.fromJson(Map<String, dynamic> json){
    return TicketInfoCounter(
      min_option: json["min_option"],
      max_option: json["max_option"],
      default_value: json["default"],
      single_unit_value: json["single_unit_value"],
      price_per_unit: json["price_per_unit"],
      currency: json["currency"]
    );
  }
}