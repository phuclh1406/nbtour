// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:mapbox_gl/mapbox_gl.dart';
// import 'package:nbtour/helper/shared_prefs.dart';
// import 'package:nbtour/models/schedule_model.dart';
// import 'package:nbtour/screens/location_test/prepare_ride.dart';
// import 'package:nbtour/screens/location_test/review_ride.dart';
// import 'package:nbtour/screens/location_test/turn_by_turn.dart';

// class Home extends StatefulWidget {
//   const Home({Key? key, required this.scheduleTour}) : super(key: key);
//   final Schedules scheduleTour;
//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   LatLng currentLocation = getCurrentLatLngFromSharedPrefs();
//   late String currentAddress;
//   late CameraPosition _initialCameraPosition;

//   @override
//   void initState() {
//     super.initState();
//     // Set initial camera position and current address
//     _initialCameraPosition = CameraPosition(target: currentLocation, zoom: 14);
//     currentAddress = getCurrentAddressFromSharedPrefs();
//     print(currentLocation);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Add MapboxMap here and enable user location
//           MapboxMap(
//             myLocationRenderMode: MyLocationRenderMode.GPS,
//             myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
//             accessToken: dotenv.env['MAPBOX_ACCESS_TOKEN'],
//             initialCameraPosition: _initialCameraPosition,
//             myLocationEnabled: true,
//             zoomGesturesEnabled: true,
//             trackCameraPosition: true,
//             doubleClickZoomEnabled: true,
//           ),
//           Positioned(
//             bottom: 0,
//             child: SizedBox(
//               width: MediaQuery.of(context).size.width,
//               child: Card(
//                 clipBehavior: Clip.antiAlias,
//                 child: Padding(
//                   padding: const EdgeInsets.all(15),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Text(
//                         'Hi there!',
//                         style: TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 20),
//                       const Text('You are currently here:'),
//                       Text(currentAddress,
//                           style: const TextStyle(color: Colors.indigo)),
//                       const SizedBox(height: 20),
//                       ElevatedButton(
//                         onPressed: () => Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (_) => const ReviewRide())),
//                         style: ElevatedButton.styleFrom(
//                             padding: const EdgeInsets.all(20)),
//                         child: const Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text('Where do you wanna go today?'),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
