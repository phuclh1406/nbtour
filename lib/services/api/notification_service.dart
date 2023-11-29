import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nbtour/main.dart';
import 'package:nbtour/services/api/config.dart';
import 'package:nbtour/services/models/notification.dart';

class NotificationServices {
  static var client = http.Client();
  static Future<List<NotificationModel>?> getNotificationList(
      String? userId) async {
    try {
      List<NotificationModel>? notiList = [];
      var url = Uri.parse(
          'https://${Config.apiURL}${Config.notification}?userId=$userId');
      String token = sharedPreferences.getString('accesstoken')!;
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };

      final response = await client.get(url, headers: headers);
      final responseData = json.decode(response.body);

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        notiList = notificationsFromJson(responseData['notifications']);

        return notiList;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
