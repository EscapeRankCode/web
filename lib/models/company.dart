import 'package:meta/meta.dart';

class Company {
  final int id;
  final String name;
  final String brandName;
  final String phone;

  Company({required this.id, required this.name, required this.brandName, required this.phone});

  @override
  String toString() => 'Company {$name}';

  Company.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        brandName = json["brand_name"],
        phone = json["phone"]
  ;
}