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
    print("Json response (TicketInfoOption): " + json.toString());
    print("Json response (TicketInfoOption [default_value]): " + json["default_value"].toString());
    print("Json response (TicketInfoOption [single_unit_value]): " + json["single_unit_value"].toString());
    print("Json response (TicketInfoOption [price_per_unit]): " + json["price_per_unit"].toString());
    print("Json response (TicketInfoOption [currency]): " + json["currency"].toString());
    return TicketInfoOption(
        default_value: json["default_value"],
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
    print("Json response (TicketInfoCheck): " + json.toString());
    print("Json response (TicketInfoCheck [default_value]): " + json["default_value"].toString());
    print("Json response (TicketInfoCheck [single_unit_value]): " + json["single_unit_value"].toString());
    print("Json response (TicketInfoCheck [price_per_unit]): " + json["price_per_unit"].toString());
    print("Json response (TicketInfoCheck [currency]): " + json["currency"].toString());
    return TicketInfoCheck(
        default_value: json["default_value"],
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
    print("Json response (TicketInfoCounter): " + json.toString());
    print("Json response (TicketInfoCounter [min_option]): " + json["min_option"].toString());
    print("Json response (TicketInfoCounter [max_option): " + json["max_option"].toString());
    print("Json response (TicketInfoCounter [default_value]): " + json["default_value"].toString());
    print("Json response (TicketInfoCounter [single_unit_value]): " + json["single_unit_value"].toString());
    print("Json response (TicketInfoCounter [price_per_unit]): " + json["price_per_unit"].toString());
    print("Json response (TicketInfoCounter [currency]): " + json["currency"].toString());
    return TicketInfoCounter(
      min_option: json["min_option"],
      max_option: json["max_option"],
      default_value: json["default_value"],
      single_unit_value: json["single_unit_value"],
      price_per_unit: json["price_per_unit"],
      currency: json["currency"]
    );
  }
}