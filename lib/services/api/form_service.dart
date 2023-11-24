import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nbtour/main.dart';
import 'package:nbtour/services/api/config.dart';
import 'package:nbtour/services/models/reschedule_form_model.dart';

class RescheduleServices {
  static var client = http.Client();

  static Future<String> sendForm(
      String? currentTour, String? desireTour, String? changeEmployee) async {
    try {
      var url = Uri.parse('https://${Config.apiURL}${Config.form}');
      String token = sharedPreferences.getString('accesstoken')!;
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };

      final body = json.encode({
        'currentTour': currentTour,
        'desireTour': desireTour,
        'changeEmployee': changeEmployee,
      });

      var response = await client.post(url, headers: headers, body: body);
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        return "Send form success";
      } else {
        return json.decode(response.body)['msg'];
      }
    } catch (e) {
      return "Send form fail";
    }
  }

  static Future<String> updateRequestStatus(
    String? formId,
    String? status,
  ) async {
    try {
      var url = Uri.parse('https://${Config.apiURL}${Config.form}/$formId');

      String token = sharedPreferences.getString('accesstoken')!;
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };

      final body = json.encode({
        'status': status,
      });

      var response = await client.put(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        return "Update request success";
      } else {
        return json.decode(response.body)['msg'];
      }
    } catch (e) {
      return "Update request fail";
    }
  }

  static Future<List<RescheduleForm>?>? getFormList(String? userId) async {
    try {
      List<RescheduleForm> listForm = [];
      var url = Uri.parse(
          'https://${Config.apiURL}${Config.form}?changeEmployee=$userId');
      String token = sharedPreferences.getString('accesstoken')!;
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };

      final response = await client.get(url, headers: headers);
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        listForm = rescheduleFormsFromJson(responseData['forms']);
        return listForm;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<List<RescheduleForm>?>? getSentForm(String? userId) async {
    try {
      List<RescheduleForm> listForm = [];
      var url =
          Uri.parse('https://${Config.apiURL}${Config.form}?userId=$userId');
      String token = sharedPreferences.getString('accesstoken')!;
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };

      final response = await client.get(url, headers: headers);
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        listForm = rescheduleFormsFromJson(responseData['forms']);
        return listForm;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
