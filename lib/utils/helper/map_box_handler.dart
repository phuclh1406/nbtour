// import 'dart:convert';

// import 'package:mapbox_gl/mapbox_gl.dart';
// import 'package:nbtour/services/mapbox/map_box_directions.dart';
// import 'package:nbtour/services/mapbox/mapbox_rev_geocoding.dart';
// import 'package:nbtour/services/mapbox/mapbox_search.dart';

// // ----------------------------- Mapbox Search Query -----------------------------
// String getValidatedQueryFromQuery(String query) {
//   // Remove whitespaces
//   String validatedQuery = query.trim();
//   return validatedQuery;
// }

// Future<List<Map<String, dynamic>>> getParsedResponseForQuery(
//     String value) async {
//   List<Map<String, dynamic>> parsedResponses = [];

//   // If empty query, send a blank response
//   String query = getValidatedQueryFromQuery(value);
//   if (query == '') return parsedResponses;

//   // Else search and then send a response
//   var response = await getSearchResultsFromQueryUsingMapbox(query);

//   if (response is Map<String, dynamic>) {
//     // Handle the response as a Map, assuming it contains the expected data
//     List features = response['features'];
//     for (var feature in features) {
//       Map<String, dynamic> responseMap = {
//         'name': feature['text'],
//         'address': feature['place_name'].split(', ')[1],
//         'place': feature['place_name'],
//         'location': LatLng(feature['center'][1], feature['center'][0])
//       };
//       parsedResponses.add(responseMap);
//     }
//   } else {
//     // Handle the case where the response is not in the expected format
//     throw Exception('Invalid response format');
//   }

//   return parsedResponses;
// }

// // ----------------------------- Mapbox Reverse Geocoding -----------------------------
// Future<Map<String, dynamic>> getParsedReverseGeocoding(LatLng latLng) async {
//   try {
//     // Make the API request and get the response as a Map
//     Map<String, dynamic> response =
//         await getReverseGeocodingGivenLatLngUsingMapbox(latLng);

//     // Check if the response contains the expected data
//     if (response != null && response.containsKey('features')) {
//       Map feature = response['features'][0];
//       Map<String, dynamic> revGeocode = {
//         'name': feature['text'],
//         'address': feature['place_name'].split(', ')[1],
//         'place': feature['place_name'],
//         'location': latLng
//       };
//       return revGeocode;
//     } else {
//       // Handle the case where the response is not in the expected format
//       throw Exception('Invalid response format');
//     }
//   } catch (e) {
//     // Handle any other exceptions that may occur during the process
//     print('Error: $e');
//     return {}; // Or you can return an error state or message here
//   }
// }

// // ----------------------------- Mapbox Directions API -----------------------------
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
//   print(modifiedResponse);
//   return modifiedResponse;
// }

// LatLng getCenterCoordinatesForPolyline(Map geometry) {
//   List coordinates = geometry['coordinates'];
//   int pos = (coordinates.length / 2).round();
//   return LatLng(coordinates[pos][1], coordinates[pos][0]);
// }
