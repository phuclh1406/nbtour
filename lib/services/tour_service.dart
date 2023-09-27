import 'dart:convert';

import 'package:nbtour/models/schedule_model.dart';
import 'package:http/http.dart' as http;
import 'package:nbtour/models/tour_model.dart';
import 'package:nbtour/services/config.dart';
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
}
