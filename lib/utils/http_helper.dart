import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:codetech_app/models/appointment.dart';
import 'package:codetech_app/models/fullname.dart';
import 'package:codetech_app/models/report.dart';
import 'package:codetech_app/models/review.dart';
import 'package:codetech_app/models/user.dart';

const URL_BASE = 'http://192.168.18.7:8080/api/v1';

class HttpHelper {
  Future<List> fetchUsers() async {
    String urlString =
        '${URL_BASE}/users';
    Uri url = Uri.parse(urlString);

    http.Response response = await http.get(url);

    if (response.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(response.body);
      List users = jsonResponse.map((map) => User.fromJson(map)).toList();
      return users;
    }
    return [];
  }

  Future<User> fetchUserById(int id) async {
    String urlString =
        '${URL_BASE}/users/${id}';
    Uri url = Uri.parse(urlString);

    http.Response response = await http.get(url);

    if (response.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(response.body);
      User user = User.fromJson(jsonResponse);
      return user;
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<User> fetchByUserEmail(String email) async {
    try {

      String urlString = '${URL_BASE}/users/emails/${email}';

      Uri url = Uri.parse(urlString);

      http.Response response = await http.get(url);

      if (response.statusCode == HttpStatus.ok) {
        final jsonResponse = json.decode(response.body);
        User user = User.fromJson(jsonResponse);
        return user;
      } else {
        throw Exception('Failed to load user');
      }
        }
        catch(e){

          print("------");
          print("FFFFFFFFFFF ${e}");
          print("------");
          throw Exception('Failed to load user');
        }
  }

  Future<User?> createUser(
    int id,
    FullName fullName,
    String dni,
    String email,
    String password,
    String profilePictureUrl,
    String address,
    String phone,
    String birthdayDate,
  ) async {
    final String urlString =
        '${URL_BASE}/users';
    Uri url = Uri.parse(urlString);

    final body = {
      "id": id,
      "fullName": fullName.toJson(),
      "dni": dni,
      "email": email,
      "password": password,
      "profilePictureUrl": profilePictureUrl,
      "address": address,
      "phone": phone,
      "birthdayDate": birthdayDate,
    };

    var headers = {
      'Content-Type': 'application/json',
    };

    final response =
        await http.post(url, headers: headers, body: jsonEncode(body));

    if (response.statusCode == HttpStatus.ok) {
      final String responseString = response.body;
      return userFromJson(responseString);
    } else {
      return null;
    }
  }

  Future updateUser(int id, User request) async {
    final String urlString =
        '${URL_BASE}/users/${id}';
    Uri url = Uri.parse(urlString);

    var headers = {
      'Content-Type': 'application/json',
    };

    final response =
        await http.put(url, headers: headers, body: jsonEncode(request));

    if (response.statusCode == HttpStatus.ok) {
      var user = User.fromJson(json.decode(response.body));
      return user;
    } else {
      return null;
    }
  }

  Future<List> fetchAppointmentsByUserId(int userId) async {
    String urlString =
        '${URL_BASE}/users/${userId}/appointments';
    Uri url = Uri.parse(urlString);

    http.Response response = await http.get(url);

    if (response.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(response.body);
      List appointments =
          jsonResponse.map((map) => Appointment.fromJson(map)).toList();
      return appointments;
    }
    return [];
  }

  Future<List> fetchAppointmentsByUserIdAndStatus(
      int userId, String status) async {
    String urlString =
        '${URL_BASE}/users/${userId}/status/${status}/appointments';
    Uri url = Uri.parse(urlString);

    http.Response response = await http.get(url);

    if (response.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(response.body);
      List appointments =
          jsonResponse.map((map) => Appointment.fromJson(map)).toList();
      return appointments;
    }
    return [];
  }

  Future deleteAppointmentById(int id) async {
    String urlString =
        '${URL_BASE}/appointments/${id}';
    Uri url = Uri.parse(urlString);

    http.Response response = await http.delete(url);

    if (response.statusCode == HttpStatus.ok) {
      return true;
    }
    return false;
  }

  Future fetchReports() async {
    String urlString =
        '${URL_BASE}/reports';
    Uri url = Uri.parse(urlString);

    http.Response response = await http.get(url);

    if (response.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(response.body);
      List reports = jsonResponse.map((map) => Report.fromJson(map)).toList();
      return reports;
    }
    return [];
  }

  Future<Review?> createReview(String text, int userId, int technicalId, int appointmentId) async {
    final String urlString = 
    '${URL_BASE}/reviews/user/${userId}/technical/${technicalId}/appointment/${appointmentId}';
    Uri url = Uri.parse(urlString);

    final body = {
      "text": text,
    };

    var headers = {
      'Content-Type': 'application/json',
    };

    final response = await http.post(url, headers: headers, body: jsonEncode(body));

    if (response.statusCode == HttpStatus.ok) {
      final String responseString = response.body;
      return reviewFromJson(responseString);
    } else {
      return null;
    }
  }

  Future<bool> appointmentHasReview(int appointmentId) async {
    final String urlString =
        '${URL_BASE}/reviews/appointment/${appointmentId}';
    Uri url = Uri.parse(urlString);
    
    http.Response response = await http.get(url);
    if(response.statusCode == HttpStatus.ok) {
      return true;
    } else {
      return false;
    }
  }
}
