import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nbtour/main.dart';
import 'package:nbtour/services/api/config.dart';
import 'package:nbtour/services/models/booking_model.dart';
import 'package:nbtour/services/models/booking_ticket_model.dart';
import 'package:nbtour/services/models/station_model.dart';
import 'package:nbtour/services/models/ticket_model.dart';
import 'package:nbtour/services/models/tracking_station_model.dart';
import 'package:nbtour/services/models/user_model.dart';

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
      print(tourId);
      print(response.statusCode);
      print(response.body);

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

  static Future<String> checkInCustomer(String id) async {
    try {
      String formatId = id.substring(11);
      var url =
          Uri.parse('https://${Config.apiURL}${Config.checkInQr}/$formatId');
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

  static Future<String> bookingOffline(
      int price,
      TrackingStations departureStation,
      String tourId,
      String email,
      String userName,
      String phone,
      List<BookingTickets> ticketList) async {
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
              "ticketTypeId": ticketList[i].bookingDetailTicket!.ticketTypeId!,
              "tourId": tourId,
              "priceId": ticketList[i].bookingDetailTicket!.price!.priceId,
              "quantity": ticketList[i].quantity
            }
        ]
      });

      final response = await client.post(url, headers: headers, body: body);
      if (response.statusCode == 201) {
        print(json.decode(response.body)['bookingId']);
        return json.decode(response.body)['bookingId'];
      } else {
        return json.decode(response.body)['msg'];
      }
    } catch (e) {
      return "Booking fail";
    }
  }
}
