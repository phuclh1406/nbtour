import 'dart:convert';

import 'package:http/http.dart' as http;
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
      return tour;
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

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        List<Tour> tour = toursFromJson(data["tours"]);

        if (userId != null && userId.isNotEmpty) {
          result = tour.toList();
        } else {
          result = tour;
        }

        // Return the result here
        return result;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception(e);
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
      var url = Uri.parse(
          'https://${Config.apiURL}${Config.getTour}?driverId=$userId');
      var response = await client.get(url, headers: headers);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        List<Tour> tour = toursFromJson(data["tours"]);

        if (userId != null && userId.isNotEmpty) {
          result = tour.toList();
        } else {
          result = tour;
        }

        // Return the result here
        return result;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}