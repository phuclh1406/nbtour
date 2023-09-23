import 'dart:convert';

import 'package:nbtour/models/schedule_model.dart';
import 'package:http/http.dart' as http;
import 'package:nbtour/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScheduleService {
  static var client = http.Client();
  static Future<List<Schedules>?> getScheduleToursByUserId(
      String? userId) async {
    List<Schedules> result = [];
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('accesstoken')!;
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      var url = Uri.parse(
          'https://${Config.apiURL}${Config.getSchedule}?tourGuildId=$userId');
      var response = await client.get(url, headers: headers);
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        List<Schedules> schedules = schedulesFromJson(data["schedules"]);

        if (userId != null && userId.isNotEmpty) {
          result = schedules.toList();
          print(result.toString());
        } else {
          result = schedules;
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
