import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nbtour/main.dart';
import 'package:nbtour/services/api/config.dart';
import 'package:nbtour/services/models/booking_model.dart';

class BookingServices {
  static var client = http.Client();
  static Future<List<Booking>?> getUserList(String tourId) async {
    try {
      List<Booking>? listBooking = [];
      var url = Uri.parse(
          'https://${Config.apiURL}${Config.getBookingUserList}?page=1&limit=10&tourId=$tourId');
      String token = sharedPreferences.getString('accesstoken')!;
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };

      final response = await client.get(url, headers: headers);
      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        listBooking = bookingsFromJson(responseData['bookings']);

        return listBooking;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<String> checkInCustomer(String id, bool isAttended) async {
    try {
      var url = Uri.parse(
          'https://${Config.apiURL}${Config.getBookingUserList}/$id?isAttended=$isAttended');
      String token = sharedPreferences.getString('accesstoken')!;
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };
      final response = await client.put(url, headers: headers);
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        return "Check-in success";
      } else {
        return "Check-in Fail";
      }
    } catch (e) {
      return "Check-in Fail";
    }
  }
}
