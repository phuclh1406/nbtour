import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nbtour/main.dart';
import 'package:nbtour/services/api/config.dart';
import 'package:nbtour/services/models/tour_model.dart';
import 'package:nbtour/services/models/tour_schedule_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScheduleService {
  static var client = http.Client();
  static Future<TourSchedule?> getScheduleByScheduleId(
      String? scheduleId) async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('accesstoken')!;
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    var url =
        Uri.parse('https://${Config.apiURL}${Config.getSchedule}/$scheduleId');
    var response = await client.get(url, headers: requestHeaders);

    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var schedule = TourSchedule.fromJson(data['schedule'][0]);

      if (schedule.status == 'Active') {
        return schedule;
      }
      return null;
    } else {
      return null;
    }
  }

  static Future<List<TourSchedule>?> getAllSchedules() async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('accesstoken')!;
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    var url = Uri.parse('https://${Config.apiURL}${Config.getSchedule}');
    var response = await client.get(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var schedule = schedulesFromJson(data['schedules']);
      schedule = schedule
          .where((schedule) =>
              schedule.status == 'Active' &&
              schedule.scheduleStatus != 'Canceled')
          .toList();
      return schedule;
    } else {
      return null;
    }
  }

  static Future<List<TourSchedule>?> getSchedulesByTourGuideId(
      String? userId) async {
    List<TourSchedule> result = [];
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('accesstoken')!;
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      var url = Uri.parse(
          'https://${Config.apiURL}${Config.getSchedule}?tourGuideId=$userId');
      var response = await client.get(url, headers: headers);
      print(response.body);
      print(response.statusCode);
      print('checkkkkkkk');
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        List<TourSchedule> schedule = schedulesFromJson(data["schedules"]);

        if (userId != null && userId.isNotEmpty) {
          result = schedule.toList();
        } else {
          result = schedule;
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

  static Future<List<TourSchedule>?> getScheduleByScheduleStatusAndDriverId(
      String? userId, String? status) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('accesstoken')!;
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      var url = Uri.parse(
          'https://${Config.apiURL}${Config.getSchedule}?driverId=$userId&scheduleStatus=$status');
      var response = await client.get(url, headers: headers);

      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        List<TourSchedule> listSchedule = schedulesFromJson(data["schedules"]);
        // Return the result here
        return listSchedule;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<String> updateScheduleStatus(
      String scheduleId, String status) async {
    try {
      String token = sharedPreferences.getString('accesstoken')!;
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final body = json.encode({"scheduleStatus": status});

      var url = Uri.parse(
          'https://${Config.apiURL}${Config.getSchedule}/$scheduleId');
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

  static Future<List<TourSchedule>?> getSchedulesByDriverId(
      String? userId) async {
    List<TourSchedule> result = [];
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('accesstoken')!;
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      print(userId);
      var url = Uri.parse(
          'https://${Config.apiURL}${Config.getSchedule}?driverId=$userId');
      var response = await client.get(url, headers: headers);

      print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        List<TourSchedule> schedule = schedulesFromJson(data["schedules"]);

        if (userId != null && userId.isNotEmpty) {
          result = schedule.toList();
        } else {
          result = schedule;
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
