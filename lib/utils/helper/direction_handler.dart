// import 'package:mapbox_gl/mapbox_gl.dart';
// import 'package:nbtour/data/restaurant.dart';
// import 'package:nbtour/main.dart';
// import 'package:nbtour/services/mapbox/map_box_directions.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// Future<Map> getDirectionsAPIResponse(
//     LatLng sourceLatLng, LatLng destinationLatLng) async {
//   final response =
//       await getCyclingRouteUsingMapbox(sourceLatLng, destinationLatLng);
//   Map geometry = response['routes'][0]['geometry'];
//   num duration = response['routes'][0]['duration'];
//   num distance = response['routes'][0]['distance'];

//   Map modifiedResponse = {
//     "geometry": geometry,
//     "duration": duration,
//     "distance": distance,
//   };
//   return modifiedResponse;
// }

// void saveDirectionsAPIResponse(int index, String response) {
//   sharedPreferences.setString('restaurant--$index', response);
// }
