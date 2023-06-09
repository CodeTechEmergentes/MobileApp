import 'dart:convert';
import 'dart:io';

import 'package:codetech_app/models/address.dart';
import 'package:codetech_app/models/appliance.dart';
import 'package:http/http.dart' as http;
import 'package:codetech_app/models/appointment.dart';
import 'package:codetech_app/models/money.dart';
import 'package:codetech_app/models/review.dart';
import 'package:codetech_app/models/technical.dart';

import '../models/shift.dart';

class HttpNewAppointment {
  String baseUrl = 'http://192.168.18.7:8080/api/v1/';

  Future<List> fetchApplianceByName(String name) async {
    print("*-*-*-**-*-**-");
    print(name);
    print("*-*-*-**-*-**-");
    String urlString = baseUrl + 'appliances/name/${name}';
    Uri url = Uri.parse(urlString);

    http.Response response = await http.get(url);

    if (response.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(response.body);
      List appliances =
          jsonResponse.map((map) => Appliance.fromJson(map)).toList();
      return appliances;
    }
    return [];
  }

  Future<List> fetchAllAppliances() async {
    String urlString = baseUrl + 'appliances';
    print("*-*-*-**-*-**-");
    print(urlString);
    print("*-*-*-**-*-**-");
    Uri url = Uri.parse(urlString);

    http.Response response = await http.get(url);

    if (response.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(response.body);
      List appliances =
          jsonResponse.map((map) => Appliance.fromJson(map)).toList();
      return appliances;
    }
    return [];
  }

  Future<List> fetchAllShifts() async {
    String urlString = baseUrl + 'shifts';
    Uri url = Uri.parse(urlString);

    http.Response response = await http.get(url);

    if (response.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(response.body);
      List shifts = jsonResponse.map((map) => Shift.fromJson(map)).toList();
      return shifts;
    }
    return [];
  }

  Future<List> fetchTechnicalsByApplianceShiftAndDate(
      int applianceId, int shiftId, String date) async {
    String urlString = baseUrl +
        'technicals/appliance/${applianceId}/shift/${shiftId}/date/${date}';
    Uri url = Uri.parse(urlString);

    print(urlString);

    http.Response response = await http.get(url);

    if (response.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(response.body);
      List technicians =
          jsonResponse.map((map) => Technical.fromJson(map)).toList();
      return technicians;
    }
    return [];
  }

  Future<List> fetchAllTechnicals() async {
    String urlString = baseUrl + 'technicals';
    Uri url = Uri.parse(urlString);

    http.Response response = await http.get(url);

    if (response.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(response.body);
      List technicians =
          jsonResponse.map((map) => Technical.fromJson(map)).toList();
      return technicians;
    }
    return [];
  }

  Future<Appointment?> createAppointment(
      String country,
      String city,
      String street,
      String problemDescription,
      int applianceId,
      int userId,
      DateTime date,
      int technicalId) async {
    String urlString = baseUrl +
        'users/${userId}/technicals/${technicalId}/appliance/${applianceId}/appointments';

    Uri url = Uri.parse(urlString);

    Address address = Address(country: country, city: city, street: street);
    Money money = Money(amount: 100, currency: 'Soles');

    final body = {
      "problemDescription": problemDescription,
      "scheduledAt": date.toIso8601String(),
      "address": address.toJson(),
      "status": "SCHEDULED",
      "reparationCost": money.toJson(),
      "paymentStatus": "SUCCEED"
    };

    var headers = {
      'Content-Type': 'application/json',
    };

    print(jsonEncode(body));

    http.Response response =
        await http.post(url, headers: headers, body: jsonEncode(body));

    if (response.statusCode == HttpStatus.created) {
      final jsonResponse = json.decode(response.body);
      Appointment appointment = Appointment.fromJson(jsonResponse);
      return appointment;
    } else {
      return null;
    }
  }

  Future<List> fetchReviewsByTechnicalId(int technicalId) async {
    String urlString = baseUrl + 'reviews/technical/${technicalId}';
    Uri url = Uri.parse(urlString);

    http.Response response = await http.get(url);

    print(urlString);

    if (response.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(response.body);
      List reviews = jsonResponse.map((map) => Review.fromJson(map)).toList();
      print(reviews);
      return reviews;
    }
    return [];
  }

  Future<Technical> getAverageScoreByTechnicalId(int technicalId) async {
    String urlString = baseUrl + 'technicals/averageScore/${technicalId}';
    Uri url = Uri.parse(urlString);

    http.Response response = await http.get(url);

    if (response.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(response.body);
      Technical technical = Technical.fromJson(jsonResponse);
      print(technical);
      return technical;
    } else {
      throw Exception('Failed to load score');
    }
  }
}
