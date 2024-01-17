import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nbtour/main.dart';
import 'package:nbtour/services/api/config.dart';
import 'package:nbtour/services/models/tour_model.dart';
import 'package:nbtour/services/models/tour_schedule_model.dart';
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

    print(response.statusCode);
    print(response.body);
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
}
