import 'dart:collection';
import 'dart:convert';
import 'package:flutter_escaperank_web/models/escapist.dart';
import 'package:flutter_escaperank_web/models/newuser.dart';
import 'package:flutter_escaperank_web/models/notifications_list.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../configuration.dart';

abstract class UserService {
  Future<Escapist?> getCurrentUser(String token);

  Future<Escapist?> registerUser(String fullname, String gender, String birthdate, String city, String state, String country, String phone, String email,
      String password, String nick, String photo);

  Future<Escapist?> updateUserPersonalData(String fullname, String gender, String birthdate, String city, String state, String country, String phone,
      String photo, String token);

  Future<Escapist?> updateUserAccessData(String email, String password, String username, String token);

  Future<Escapist?> registerSocialUser(String fullname, String gender, String birthdate, String city, String state, String country, String phone, String email,
      String socialProvider, String socialProviderId, String accessToken, String nick, String photo);

  Future<Escapist?> loginUser(String email, String password);

  Future<String?> socialLogin(String email, String socialProvider, String socialProviderId, String accessToken);

  Future<void> updateDeviceId(String token, String deviceId);

  Future<NotificationsList?> getNotifications(String token, String type);

  Future<bool> readNotifications(String token);
}

class UserServices extends UserService {
  @override
  Future<Escapist?> registerUser(String fullname, String gender, String birthdate, String city, String state, String country, String phone, String email,
      String password, String username, String photo) async {
    Uri uri = Uri.https(API.baseURL, API.registerUser);
    final response = await http.post(uri,
        headers: {
          'ApiKey': API.apiKey,
          'accept': 'application/json',
          "Content-Type": "application/json; charset=utf-8",
        },
        body: json.encode({
          "full_name": fullname,
          "birthdate": birthdate,
          "gender": gender,
          "phone_number": phone,
          "country": country,
          "province": state,
          "city": city,
          "username": username,
          "email": email,
          "password": password,
          "image": photo,
        }));
  
    if (response.statusCode == RESPONSES.RESPONSE_OK) {
      dynamic body = json.decode(response.body);
      //Login User
      var escapist = await loginUser(email, password);
      if (escapist != null) {
        //Get Current User
        //var escapist = await getCurrentUser(newuser.token);
        return escapist;
      }
    } else if (response.statusCode == RESPONSES.RESPONSE_UNPROCESSABLE_ENTITY) {
      String printedErrors = "";
      Map<String, dynamic> errors = json.decode(response.body)["errors"];

      errors.values.forEach((value) {
        printedErrors += value.toString() + "\n";
      });
      printedErrors = printedErrors.replaceAll("[", "").replaceAll("]", "");
      return Escapist(
        userId: null,
        errors: printedErrors.substring(0, printedErrors.length - 1),
        username: '', selected: false, image: '', points: '', country: '',
        id: '', phoneNumber: '', province: '', city: '', position: '',
        phoneValidated: false, gender: '', user: null, birthdate: '',
      );
    }
    return null;
  }

  @override
  Future<Escapist?> updateUserPersonalData(String fullname, String gender, String birthdate, String city, String state, String country,
      String phone, String photo, String token) async {
    Uri uri = Uri.https(API.baseURL, API.updateUser);
    var jsonData;
    if (photo == null) {
      jsonData = {
        "full_name": fullname,
        "birthdate": birthdate,
        "gender": gender,
        "phone_number": phone,
        "country": country,
        "province": state,
        "city": city
      };
    } else {
      jsonData = {
        "full_name": fullname,
        "birthdate": birthdate,
        "gender": gender,
        "phone_number": phone,
        "country": country,
        "province": state,
        "city": city,
        "image": photo
      };
    }
    final response = await http.put(uri,
        headers: {
          'ApiKey': API.apiKey,
          'accept': 'application/json',
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(jsonData));

    if (response.statusCode == RESPONSES.RESPONSE_OK) {
      var escapist = await getCurrentUser(token);
      return escapist;
    } else if (response.statusCode == RESPONSES.RESPONSE_UNPROCESSABLE_ENTITY) {
      String printedErrors = "";
      Map<String, dynamic> errors = json.decode(response.body)["errors"];

      errors.values.forEach((value) {
        printedErrors += value.toString() + "\n";
      });
      printedErrors = printedErrors.replaceAll("[", "").replaceAll("]", "");
      return Escapist(
          userId: null,
          errors: printedErrors.substring(0, printedErrors.length - 1),
        username: '', selected: false, image: '', points: '', country: '',
        id: '', phoneNumber: '', province: '', city: '', position: '',
        phoneValidated: false, gender: '', user: null, birthdate: '',);
    }
    return null;
  }

  @override
  Future<Escapist?> updateUserAccessData(String email, String password, String username, String token) async {
    Uri uri = Uri.https(API.baseURL, API.updateUser);

    var jsonData;
    if (password == null || password.isEmpty) {
      jsonData = {"username": username};
    } else {
      jsonData = {"password": password, "username": username};
    }

    final response = await http.put(uri,
        headers: {
          'ApiKey': API.apiKey,
          'accept': 'application/json',
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(jsonData));

    if (response.statusCode == RESPONSES.RESPONSE_EDIT_OK_NO_CONTENT) {
      var escapist = await getCurrentUser(token);
      return escapist;
    } else if (response.statusCode == RESPONSES.RESPONSE_UNPROCESSABLE_ENTITY) {
      String printedErrors = "";
      Map<String, dynamic> errors = json.decode(response.body)["errors"];

      errors.values.forEach((value) {
        printedErrors += value.toString() + "\n";
      });
      printedErrors = printedErrors.replaceAll("[", "").replaceAll("]", "");
      return Escapist(
          userId: null,
          errors: printedErrors.substring(0, printedErrors.length - 1),
        username: '', selected: false, image: '', points: '', country: '',
        id: '', phoneNumber: '', province: '', city: '', position: '',
        phoneValidated: false, gender: '', user: null, birthdate: '',);
    }
    return null;
  }

  @override
  Future<Escapist?> registerSocialUser(String fullname, String gender, String birthdate, String city, String state, String country, String phone,
      String email, String socialProvider, String socialProviderId, String accessToken, String username, String photo) async {
    Uri uri = Uri.https(API.baseURL, API.registerUser);
    final response = await http.post(uri, headers: {
      'ApiKey': API.apiKey,
      'accept': 'application/json',
      "Content-Type": "application/json; charset=utf-8",
    }, body: json.encode({
      "full_name": fullname,
      "birthdate": birthdate,
      "gender": gender,
      "phone_number": phone,
      "country": country,
      "province": state,
      "city": city,
      "username": username,
      "email": email,
      "social_provider": socialProvider,
      "social_provider_id": socialProviderId,
      "image": photo,
    }));

    if (response.statusCode == RESPONSES.RESPONSE_OK) {
      dynamic body = json.decode(response.body);
      //Login User
      var escapist = await socialLogin(
          email, socialProvider, socialProviderId, accessToken);
      if (escapist != null) {
        return Escapist.fromJson(body);
      }
    } else if (response.statusCode == RESPONSES.RESPONSE_UNPROCESSABLE_ENTITY) {
      String printedErrors = "";
      Map<String, dynamic> errors = json.decode(response.body)["errors"];

      errors.values.forEach((value) {
        printedErrors += value.toString() + "\n";
      });
      printedErrors = printedErrors.replaceAll("[", "").replaceAll("]", "");
      return Escapist(
          userId: null,
          errors: printedErrors.substring(0, printedErrors.length - 1),
        username: '', selected: false, image: '', points: '', country: '',
        id: '', phoneNumber: '', province: '', city: '', position: '',
        phoneValidated: false, gender: '', user: null, birthdate: '',);
    }
    return null;
  }

  @override
  Future<Escapist?> loginUser(String email, String password) async {
    Uri uri = Uri.https(API.baseURL, API.loginUser);
    final response = await http.post(uri, headers: {
      'ApiKey': API.apiKey,
      'accept': 'application/json',
    }, body: {
      "email": email,
      "password": password,
    });

    if (response.statusCode == RESPONSES.RESPONSE_OK) {
      dynamic body = json.decode(response.body);
      updateUserToken(NewUser.fromJson(body));
      var escapist = await getCurrentUser(NewUser.fromJson(body).token);
      return escapist;
    }
    return null;
  }

  Future<Escapist?> getCurrentUser(String token) async {
    Uri uri = Uri.https(API.baseURL, API.getUser);
    final response = await http.get(
      uri,
      headers: {
        'ApiKey': API.apiKey,
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == RESPONSES.RESPONSE_OK) {
      dynamic body = json.decode(response.body);
      updateUserInfo(Escapist.fromJson(body));
      return Escapist.fromJson(body);
    }

    return null;
  }

  Future<NotificationsList?> getNotifications(String token, String type) async {
    Uri uri = Uri.https(API.baseURL, API.getNotifications);
    final response = await http.get(
      uri,
      headers: {
        'ApiKey': API.apiKey,
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == RESPONSES.RESPONSE_OK) {
      dynamic body = json.decode(response.body);
      return NotificationsList.fromJson(body);
    }

    return null;
  }

  Future<bool> readNotifications(String token) async {
    Uri uri = Uri.https(API.baseURL, API.readNotifications);
    final response = await http.put(
      uri,
      headers: {
        'ApiKey': API.apiKey,
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == RESPONSES.RESPONSE_OK) {
      dynamic body = json.decode(response.body);
      return true;
    }
  return false;
  }

  @override
  Future<String?> socialLogin(String email, String socialProvider,
      String socialProviderId, String accessToken) async {
    Uri uri = Uri.https(API.baseURL, API.socialLogin);
    final response = await http.post(uri, headers: {
      'ApiKey': API.apiKey,
      'accept': 'application/json',
    }, body: {
      "email": email,
      "social_provider": socialProvider,
      "social_provider_id": socialProviderId,
      "access_token": accessToken,
    });

    if (response.statusCode == RESPONSES.RESPONSE_OK) {
      dynamic body = json.decode(response.body);
      updateUserToken(NewUser.fromJson(body));
      await getCurrentUser(NewUser.fromJson(body).token);
      return "token";
    } else if (response.statusCode == RESPONSES.RESPONSE_NOT_EXIST) {
      return "register";
    } else {
      return null;
    }
  }

  Future<void> updateUserInfo(Escapist escapist) async {
    var prefs = await SharedPreferences.getInstance();

    prefs.setString("userName", escapist.user!.name);
    prefs.setString("userUsername", escapist.username);
    prefs.setString("userId", escapist.userId.toString());
    prefs.setString("escapistId", escapist.id);
    prefs.setString("userBirthdate", escapist.birthdate);
    prefs.setString("userAvatar", escapist.image);
    prefs.setString("userCity", escapist.city);
    prefs.setString("userProvince", escapist.province);
    prefs.setString("userCountry", escapist.country);
    prefs.setString("userGender", escapist.gender);
    prefs.setString("userEmail", escapist.user!.email);
    prefs.setBool("userPhoneValidated", escapist.phoneValidated);
    prefs.setString("userPhone", escapist.phoneNumber);
  }

  Future<void> updateUserToken(NewUser user) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString("token", user.token);
  }

  @override
  Future<void> updateDeviceId(String token, String deviceId) async {
    Uri uri = Uri.https(API.baseURL, API.updateUser);
    var jsonData = {
        "fcm_token": deviceId};
    final response = await http.put(uri,
        headers: {
          'ApiKey': API.apiKey,
          'accept': 'application/json',
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(jsonData));

  }
}
