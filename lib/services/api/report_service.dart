import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nbtour/main.dart';
import 'package:nbtour/services/api/config.dart';
import 'package:nbtour/services/models/report_model.dart';

class ReportServices {
  static var client = http.Client();

  static Future<String> sendReport(String? tourId, String? userId,
      String? title, String? description) async {
    try {
      var url = Uri.parse('https://${Config.apiURL}${Config.report}');
      String token = sharedPreferences.getString('accesstoken')!;

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };

      final body = json.encode({
        'tourId': tourId,
        'reportUserId': userId,
        'title': title,
        'description': description
      });
      var response = await client.post(url, headers: headers, body: body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        return 'Send report successfully';
      } else {
        return json.decode(response.body)['msg'];
      }
    } catch (e) {
      return "Send report fail";
    }
  }

  static Future<String> sendReportWithoutTourId(
      String? userId, String? title, String? description) async {
    try {
      var url = Uri.parse('https://${Config.apiURL}${Config.report}');
      String token = sharedPreferences.getString('accesstoken')!;

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };

      final body = json.encode(
          {'reportUserId': userId, 'title': title, 'description': description});
      var response = await client.post(url, headers: headers, body: body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        return 'Send report successfully';
      } else {
        return json.decode(response.body)['msg'];
      }
    } catch (e) {
      return "Send report fail";
    }
  }

  static Future<List<Reports>?> getReportListByReportUser(
      String? userId) async {
    try {
      var url = Uri.parse(
          'https://${Config.apiURL}${Config.report}?page=1&limit=10&reportUserId=$userId');
      String token = sharedPreferences.getString('accesstoken')!;
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };
      var response = await client.get(url, headers: headers);
      if (response.statusCode == 201 || response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var reportList = reportsFromJson(data['reports']);
        reportList =
            reportList.where((report) => report.status == 'Active').toList();
        return reportList;
      } else {
        return json.decode(response.body)['msg'];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<Reports?> getReportByReportId(String? reportId) async {
    try {
      var url = Uri.parse('https://${Config.apiURL}${Config.report}/$reportId');
      String token = sharedPreferences.getString('accesstoken')!;
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };
      var response = await client.get(url, headers: headers);
      if (response.statusCode == 201 || response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var report = Reports.fromJson(data['reports']);
        if (report.status == 'Active') {
          return report;
        }
        return null;
      } else {
        return json.decode(response.body)['msg'];
      }
    } catch (e) {
      return null;
    }
  }
}
