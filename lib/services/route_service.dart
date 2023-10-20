import 'dart:convert';

import 'package:nbtour/models/route_model.dart';
import 'package:http/http.dart' as http;
import 'package:nbtour/services/config.dart';
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
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
      var data = jsonDecode(response.body);
      var route = Routes.fromJson(data['route'][0]);

      print(route);
      return route;
    } else {
      return null;
    }
  }
}
