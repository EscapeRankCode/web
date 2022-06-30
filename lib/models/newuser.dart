import 'package:meta/meta.dart';

class NewUser {
  final int userId;
  final String userName;
  final String token;

  NewUser({required this.userId, required this.userName, required this.token});

  NewUser.fromJson(Map<String, dynamic> json)
      : userId = json["id"],
        userName = json["username"],
        token = json["token"];
}