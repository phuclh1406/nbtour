import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nbtour/main.dart';
import 'package:nbtour/services/api/config.dart';
import 'package:nbtour/services/models/tracking_model.dart';

class TrackingServices {
  static var client = http.Client();
  Future<String> trackingWithCoordinates(
      String tourId, double lat, double long, String status) async {
    var url = Uri.https(Config.apiURL, Config.trackingCoordinates);
    String token = sharedPreferences.getString("accesstoken")!;
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final body = json.encode({
      'tourId': tourId,
      'latitude': lat,
      'longitude': long,
      'status': status,
    });
    final response = await client.post(url, headers: headers, body: body);
    print(response.body);
    if (response.statusCode == 200) {
      return 'create success';
    } else {
      return 'create fail';
    }
  }

  Future<String> trackingWithStations(
      String tourId, double lat, double long, String status) async {
    var url = Uri.https(Config.apiURL, Config.trackingStations);
    String token = sharedPreferences.getString("accesstoken")!;
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final body = json.encode({
      'tourId': tourId,
      'latitude': lat,
      'longitude': long,
      'status': status,
    });
    final response = await client.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return 'create success';
    } else {
      return 'create fail';
    }
  }

  Future<Tracking?> getTrackingByTourId(String tourId) async {
    var url = Uri.parse(
        'https://${Config.apiURL}${Config.trackingCoordinates}?tourId=$tourId');
    String token = sharedPreferences.getString('accesstoken')!;
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final response = await client.get(url, headers: headers);
    final responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      return Tracking.fromJson(responseData['trackings'][0]);
    } else {
      return null;
    }
  }

  Future<List<Tracking>?> getListTracking() async {
    var url = Uri.https(Config.apiURL, Config.trackingCoordinates);
    String token = sharedPreferences.getString('accesstoken')!;
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final response = await client.get(url, headers: headers);
    final responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      return trackingsFromJson(responseData['trackings']);
    } else {
      return [];
    }
  }

  Future<String> updateTrackingWithCoordinates(
      String trackingId, double lat, double long, String status) async {
    var url = Uri.https(Config.apiURL, Config.trackingCoordinates);
    String token = sharedPreferences.getString("accesstoken")!;
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final body = json.encode({
      'trackingId': trackingId,
      'latitude': lat,
      'longitude': long,
      'status': status,
    });
    final response = await client.put(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return "update success";
    } else {
      return "update fail";
    }
  }
}
