import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nbtour/main.dart';
import 'package:nbtour/services/api/config.dart';
import 'package:nbtour/services/models/booking_model.dart';
import 'package:nbtour/services/models/ticket_model.dart';

import 'package:nbtour/services/models/tracking_station_model.dart';

class BookingServices {
  static var client = http.Client();
  static Future<List<Booking>?> getUserList(String tourId) async {
    try {
      List<Booking>? listBooking = [];
      var url = Uri.parse(
          'https://${Config.apiURL}${Config.getBookingUserList}?page=1&limit=60&tourId=$tourId');
      String token = sharedPreferences.getString('accesstoken')!;
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };

      final response = await client.get(url, headers: headers);
      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        listBooking = bookingsFromJson(responseData['bookings']);
        listBooking = listBooking
            .where((booking) =>
                booking.bookingStatus != 'Draft' ||
                booking.bookingStatus != 'Canceled')
            .toList();

        return listBooking;
      } else {
        return [];
      }
    } catch (e) {
      return null;
    }
  }

  static Future<String> checkInCustomer(String id, String tourId) async {
    try {
      var url = Uri.parse(
          'https://${Config.apiURL}${Config.checkInQr}/$id/checkin?tourId=$tourId');
      String token = sharedPreferences.getString('accesstoken')!;
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };

      final response = await client.put(url, headers: headers);

      if (response.statusCode == 200) {
        return "Check-in success";
      } else {
        return json.decode(response.body)['msg'];
      }
    } catch (e) {
      return "Check-in Fail";
    }
  }

  static Future<Booking?> getBookingByBookingDetailId(String? id) async {
    try {
      var url = Uri.parse('https://${Config.apiURL}${Config.booking}/$id');
      String token = sharedPreferences.getString('accesstoken')!;
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };

      final response = await client.get(url, headers: headers);

      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var booking = Booking.fromJson(data['booking']);
        if (booking.status != 'Draft' && booking.status != 'Canceled') {
          return booking;
        }
        return null;
      } else {
        return json.decode(response.body)['msg'];
      }
    } catch (e) {
      return null;
    }
  }

  static Future<String> bookingOffline(
      int price,
      TrackingStations departureStation,
      String tourId,
      String email,
      String userName,
      String phone,
      List<Tickets> ticketList) async {
    try {
      var url = Uri.parse('https://${Config.apiURL}${Config.bookingOffline}');
      String token = sharedPreferences.getString('accesstoken')!;
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };

      final body = json.encode({
        'totalPrice': price,
        'departureStationId': departureStation.tourDetailStation!.stationId,
        'user': {'email': email, 'userName': userName, 'phone': phone},
        'tickets': [
          for (var i = 0; i < ticketList.length; i++)
            {
              "ticketId": ticketList[i].ticketId,
              "ticketTypeId": ticketList[i].ticketType!.ticketTypeId,
              "tourId": tourId,
              "priceId": ticketList[i].ticketType!.price!.priceId,
              "quantity": ticketList[i].quantity
            }
        ]
      });

      print(body);

      final response = await client.post(url, headers: headers, body: body);
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 201) {
        return json.decode(response.body)['bookingId'];
      } else {
        return json.decode(response.body)['msg'];
      }
    } catch (e) {
      return "Booking fail";
    }
  }
}
