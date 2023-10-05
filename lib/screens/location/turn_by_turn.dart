// import 'package:flutter/material.dart';
// import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
// import 'package:nbtour/helper/shared_prefs.dart';
// import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';

// class TurnByTurn extends StatefulWidget {
//   const TurnByTurn({Key? key, required this.kTripEndPoints}) : super(key: key);

//   final List<LatLng> kTripEndPoints;

//   @override
//   State<TurnByTurn> createState() => _TurnByTurnState();
// }

// class _TurnByTurnState extends State<TurnByTurn> {
//   // Waypoints to mark trip start and end
//   // LatLng source = getTripLatLngFromSharedPrefs('source');
//   // LatLng destination = getTripLatLngFromSharedPrefs('destination');
//   // late WayPoint sourceWaypoint, destinationWaypoint;

//   var wayPoints = <WayPoint>[];

//   // Config variables for Mapbox Navigation
//   late MapBoxNavigation directions;
//   late MapBoxOptions _options;
//   late double? distanceRemaining, durationRemaining;
//   late MapBoxNavigationViewController _controller;
//   final bool isMultipleStop = false;
//   String instruction = "";
//   bool arrived = false;
//   bool routeBuilt = false;
//   bool isNavigating = false;

//   @override
//   void initState() {
//     super.initState();
//     initialize();
//   }

//   Future<void> initialize() async {
//     if (!mounted) return;

//     // Setup directions and options
//     directions = MapBoxNavigation.instance;
//     _options = MapBoxOptions(
//         zoom: 18.0,
//         voiceInstructionsEnabled: true,
//         bannerInstructionsEnabled: true,
//         mode: MapBoxNavigationMode.drivingWithTraffic,
//         isOptimized: true,
//         units: VoiceUnits.metric,
//         simulateRoute: true,
//         language: "en");

//     for (var i = 0; i < widget.kTripEndPoints.length; i++) {
//       wayPoints.add(WayPoint(
//           name: widget.kTripEndPoints[i].toString(),
//           latitude: widget.kTripEndPoints[i].latitude,
//           longitude: widget.kTripEndPoints[i].longitude));
//     }

//     print('This is for testttttttttttttttttttt ${MapBoxNavigation.instance}');

//     // Start the trip
//     MapBoxNavigation.instance.registerRouteEventListener(_onRouteEvent);
//     await directions.startNavigation(wayPoints: wayPoints, options: _options);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Text('');
//   }

//   Future<void> _onRouteEvent(e) async {
//     distanceRemaining = await MapBoxNavigation.instance.getDistanceRemaining();
//     durationRemaining = await MapBoxNavigation.instance.getDurationRemaining();

//     switch (e.eventType) {
//       case MapBoxEvent.progress_change:
//         var progressEvent = e.data as RouteProgressEvent;
//         arrived = progressEvent.arrived!;
//         if (progressEvent.currentStepInstruction != null) {
//           instruction = progressEvent.currentStepInstruction!;
//         }
//         break;
//       case MapBoxEvent.route_building:
//       case MapBoxEvent.route_built:
//         routeBuilt = true;
//         break;
//       case MapBoxEvent.route_build_failed:
//         routeBuilt = false;
//         break;
//       case MapBoxEvent.navigation_running:
//         isNavigating = true;
//         break;
//       case MapBoxEvent.on_arrival:
//         arrived = true;
//         if (!isMultipleStop) {
//           await Future.delayed(const Duration(seconds: 3));
//           await _controller.finishNavigation();
//         } else {}
//         break;
//       case MapBoxEvent.navigation_finished:
//       case MapBoxEvent.navigation_cancelled:
//         routeBuilt = false;
//         isNavigating = false;
//         break;
//       default:
//         break;
//     }
//     //refresh UI
//     setState(() {});
//   }
// }
