class Topic {

  final int id;
  final String name;
  bool selected;

  Topic(this.selected, {required this.id, required this.name});

  Topic.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        selected = false;

}
