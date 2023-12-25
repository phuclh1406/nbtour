import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nbtour/main.dart';
import 'package:nbtour/services/api/config.dart';
import 'package:nbtour/services/models/tracking_model.dart';
import 'package:nbtour/services/models/tracking_station_model.dart';

class TrackingServices {
  static var client = http.Client();
  static Future<String> trackingWithCoordinates(
      String tourId, double lat, double long) async {
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
    });
    final response = await client.post(url, headers: headers, body: body);

    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      return 'create success';
    } else {
      return json.decode(response.body)['msg'];
    }
  }

  static Future<Tracking?> getTrackingByTourId(String tourId) async {
    try {
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
    } catch (e) {
      return null;
    }
  }

  static Future<List<TrackingStations>?> getTrackingStationsByTourId(
      String tourId) async {
    var url = Uri.parse(
        'https://${Config.apiURL}${Config.trackingStations}?tourId=$tourId');
    final headers = {
      'Content-Type': 'application/json',
    };

    final response = await client.get(url, headers: headers);
    final responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      return trackingStationsFromJson(responseData['tourDetails']);
    } else {
      return null;
    }
  }

  static Future<String> trackingStations(String tourDetailId) async {
    try {
      var url = Uri.parse(
          'https://${Config.apiURL}${Config.trackingStations}/$tourDetailId');
      final headers = {
        'Content-Type': 'application/json',
      };

      final body = json.encode({'status': 'Arrived'});

      final response = await client.put(url, headers: headers, body: body);
      final responseData = json.decode(response.body);
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        return 'Tracking success';
      } else {
        return json.decode(responseData['msg']);
      }
    } catch (e) {
      return 'Tracking fail';
    }
  }

  static Future<List<Tracking>?> getListTracking() async {
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

  static Future<List<Tracking>?> getListTrackingWithTourId(
      String tourId) async {
    var url = Uri.https(
        'https://${Config.apiURL}${Config.trackingCoordinates}?tourId=$tourId');
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

  static Future<String> updateTrackingWithCoordinates(
      String trackingId, double lat, double long, String status) async {
    var url = Uri.parse(
        'https://${Config.apiURL}${Config.trackingCoordinates}/$trackingId');
    String token = sharedPreferences.getString("accesstoken")!;
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final body = json.encode({
      'latitude': lat,
      'longitude': long,
      'status': status,
    });

    final response = await client.put(url, headers: headers, body: body);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      return "update success";
    } else {
      return json.decode(response.body)['msg'];
    }
  }
}
