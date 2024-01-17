import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nbtour/main.dart';
import 'package:nbtour/services/api/config.dart';
import 'package:nbtour/services/models/invoice_model.dart';
import 'package:nbtour/services/models/reschedule_form_model.dart';

class InvoiceServices {
  static var client = http.Client();

  static Future<List<Invoices>?>? getInvoiceList(
      String? userId, bool? isPaidToManager) async {
    try {
      List<Invoices> listInvoices = [];
      var url = Uri.parse(
          'https://${Config.apiURL}${Config.invoices}?tourGuideId=$userId&isPaidToManager=$isPaidToManager');
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
        listInvoices = invoicesFromJson(responseData['schedules']);
        return listInvoices;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
