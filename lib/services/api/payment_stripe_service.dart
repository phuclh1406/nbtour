import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class PaymentStripeServices {
  static var client = http.Client();

  static paymentStripe(String? amount) async {
    try {
      var url = Uri.parse('https://api.stripe.com/v1/payment_intents');

      final headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer ${dotenv.env['STRIPE_KEY']}'
      };

      Map<String, dynamic> body = {"amount": amount, "currency": "VND"};

      var response = await client.post(url, headers: headers, body: body);

      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200 && response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        return json.decode(response.body);
      }
    } catch (e) {
      return "Payment fail";
    }
  }
}
