class TicketsSelection{
  int counter_selected_units;
  int check_selected_units;
  int option_selected_units;

  TicketsSelection({this.counter_selected_units = 0, this.check_selected_units = 0, this.option_selected_units = 0});

  Map toJson() => {
    'counter_selected_units': counter_selected_units,
    'check_selected_units': check_selected_units,
    'option_selected_units': option_selected_units
  };

}