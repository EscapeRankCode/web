class TotalRules{
  final int counter_min_units;
  final int counter_max_units;
  final int check_min_units;
  final int check_max_units;
  final int option_min_units;
  final int option_max_units;

  TotalRules(
      {
        required this.counter_min_units,
        required this.counter_max_units,
        required this.check_min_units,
        required this.check_max_units,
        required this.option_min_units,
        required this.option_max_units});

  factory TotalRules.fromJson(Map<String, dynamic> json){
    return TotalRules(
      counter_min_units: json["counter_min_units"],
      counter_max_units: json["counter_max_units"],
      check_min_units: json["check_min_units"],
      check_max_units: json["check_max_units"],
      option_min_units: json["option_min_units"],
      option_max_units: json["option_min_units"]
    );
  }
}