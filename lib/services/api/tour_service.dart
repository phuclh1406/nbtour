import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nbtour/main.dart';
import 'package:nbtour/services/api/config.dart';
import 'package:nbtour/services/models/tour_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TourService {
  static var client = http.Client();
  static Future<Tour?> getTourByTourId(String? tourId) async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('accesstoken')!;
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    var url = Uri.parse('https://${Config.apiURL}${Config.getTour}/$tourId');
    var response = await client.get(url, headers: requestHeaders);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var tour = Tour.fromJson(data['tour'][0]);
      if (tour.status == 'Active') {
        return tour;
      }
      return null;
    } else {
      return null;
    }
  }

  static Future<List<Tour>?> getAllTours() async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('accesstoken')!;
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    var url = Uri.parse('https://${Config.apiURL}${Config.getTour}');
    var response = await client.get(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var tour = toursFromJson(data['tours']);
      tour = tour.where((tour) => tour.status == 'Active').toList();
      return tour;
    } else {
      return null;
    }
  }

  static Future<List<Tour>?> getToursByTourGuideId(String? userId) async {
    List<Tour> result = [];
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('accesstoken')!;
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      var url = Uri.parse(
          'https://${Config.apiURL}${Config.getTour}?tourGuideId=$userId');
      var response = await client.get(url, headers: headers);
      print(userId);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        List<Tour> tour = toursFromJson(data["tours"]);

        if (userId != null && userId.isNotEmpty) {
          result = tour.toList();
        } else {
          result = tour;
        }

        // Return the result here
        result = result.where((result) => result.status == 'Active').toList();
        return result;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<List<Tour>?> getTourByTourStatusAndDriverId(
      String? userId, String? status) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('accesstoken')!;
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      var url = Uri.parse(
          'https://${Config.apiURL}${Config.getTour}?driverId=$userId&tourStatus=$status');
      var response = await client.get(url, headers: headers);

      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        List<Tour> listTour = toursFromJson(data["tours"]);
        // Return the result here
        return listTour;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<String> updateTourStatus(
      String tourId, String status, String tourName) async {
    try {
      String token = sharedPreferences.getString('accesstoken')!;
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final body = json.encode({"tourName": tourName, "tourStatus": status});

      var url = Uri.parse('https://${Config.apiURL}${Config.getTour}/$tourId');
      var response = await client.put(url, headers: headers, body: body);

      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        return "Update success";
      } else {
        return json.decode(response.body)['msg'];
      }
    } catch (e) {
      return 'Update fail';
    }
  }

  static Future<List<Tour>?> getToursByDriverId(String? userId) async {
    List<Tour> result = [];
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('accesstoken')!;
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      print(userId);
      var url = Uri.parse(
          'https://${Config.apiURL}${Config.getTour}?driverId=$userId');
      var response = await client.get(url, headers: headers);

      print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        List<Tour> tour = toursFromJson(data["tours"]);

        if (userId != null && userId.isNotEmpty) {
          result = tour.toList();
        } else {
          result = tour;
        }
        result = result.where((result) => result.status == 'Active').toList();
        // Return the result here
        return result;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
