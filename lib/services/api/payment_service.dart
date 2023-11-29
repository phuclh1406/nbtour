import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nbtour/services/api/config.dart';

class PaymentServices {
  static var client = http.Client();

  static Future<String> paymentOffline(String? bookingid) async {
    try {
      var url = Uri.parse(
          'https://${Config.apiURL}${Config.paymentOffline}?bookingId=$bookingid');

      final headers = {
        'Content-Type': 'application/json',
      };
      var response = await client.put(url, headers: headers);

      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200 && response.statusCode == 201) {
        return json.decode(response.body)['msg'];
      } else {
        return json.decode(response.body)['msg'];
      }
    } catch (e) {
      return "Payment fail";
    }
  }
}
