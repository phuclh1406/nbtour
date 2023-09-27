// import 'package:flutter/material.dart';
// import 'package:mapbox_gl/mapbox_gl.dart';
// import 'package:nbtour/helper/map_box_handler.dart';
// import 'package:nbtour/helper/shared_prefs.dart';
// import 'package:nbtour/screens/location_test/review_ride.dart';

// Widget reviewRideFaButton(BuildContext context) {
//   return FloatingActionButton.extended(
//       icon: const Icon(Icons.local_taxi),
//       onPressed: () async {
//         // Get directions API response and pass to modified response
//         LatLng sourceLatLng = getTripLatLngFromSharedPrefs('source');
//         LatLng destinationLatLng = getTripLatLngFromSharedPrefs('destination');
//         Map modifiedResponse =
//             await getDirectionsAPIResponse(sourceLatLng, destinationLatLng);
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (_) =>
//                     ReviewRide(modifiedResponse: modifiedResponse)));
//       },
//       label: const Text('Review Ride'));
// }
