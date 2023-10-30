import 'dart:convert';

import 'package:nbtour/services/api/config.dart';
import 'package:nbtour/services/models/route_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RouteService {
  static var client = http.Client();
  static Future<Routes?> getRouteByRouteId(String routeId) async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('accesstoken')!;
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    var url = Uri.parse('https://${Config.apiURL}${Config.getRoute}/$routeId');
    var response = await client.get(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var route = Routes.fromJson(data['route'][0]);
      return route;
    } else {
      return null;
    }
  }
}
