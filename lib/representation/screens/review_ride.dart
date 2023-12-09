import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:just_audio/just_audio.dart';
import 'package:location/location.dart';
import 'package:nbtour/representation/screens/timeline_screen.dart';
import 'package:nbtour/services/api/route_service.dart';
import 'package:nbtour/services/api/tracking_service.dart';
import 'package:nbtour/services/models/tour_model.dart';
import 'package:nbtour/utils/constant/colors.dart';
import 'package:nbtour/utils/constant/dimension.dart';
import 'package:nbtour/utils/constant/text_style.dart';
import 'package:nbtour/main.dart';
import 'package:nbtour/services/models/point_of_interest_model.dart';
import 'package:nbtour/services/models/route_model.dart';
import 'package:nbtour/services/models/station_model.dart';
import 'package:nbtour/services/models/tracking_model.dart';
import 'package:nbtour/utils/helper/asset_helper.dart';
import 'package:nbtour/utils/helper/image_helper.dart';

import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
import 'package:vietmap_flutter_navigation/models/way_point.dart';
import 'dart:math' as math;

class ReviewRideScreen extends StatefulWidget {
  const ReviewRideScreen({Key? key, required this.tour}) : super(key: key);

  final Tour tour;

  @override
  State<ReviewRideScreen> createState() => _ReviewRideScreenState();
}

List<PointOfInterest> _kTripPoints = [];
List<Stations> _kTripStations = [];
List<LatLng> _kTripRoute = [];
UserLocation? userLocation;
List<PointOfInterest>? pointList = [];
Timer? timer;
const double pi = 3.1415926535897932;

class _ReviewRideScreenState extends State<ReviewRideScreen> {
  VietmapController? controller;
  double? deviationLat;
  double? deviationLong;
  String apiKey = dotenv.env['VIETMAP_API_KEY']!;
  List<Marker> temp = [];
  late List<LatLng> geometry;
  bool isPlay = true;
  List<WayPoint> wayPoints = [];
  final player = AudioPlayer();
  bool isLined = false;
  LatLng targetPoint = const LatLng(0, 0);
  void initializeLocationAndSave() async {
    // Ensure all permissions are collected for Locations
    Location location = Location();
    bool? serviceEnabled;
    PermissionStatus? permissionGranted;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
    }

    // Get the current user location
    LocationData locationData = await location.getLocation();

    // Get the current user address

    // Store the user location in sharedPreferences
    sharedPreferences.setDouble('latitude', locationData.latitude!);
    sharedPreferences.setDouble('longitude', locationData.longitude!);
  }

  // Mapbox Maps SDK related

  // Directions API response related
  // late String distance;
  // late String dropOffTime;
  // late Map geometry;

  @override
  void initState() {
    super.initState();
    initializeLocationAndSave();
  }

  void openStationsOverlay(Tour tour) {
    showModalBottomSheet(
      showDragHandle: true,
      elevation: 0,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,

          // child: TimelinesScreen(route: route)),
          child: TimelinesScreen(
            tour: tour,
            wayPoints: wayPoints,
          )),
    );
  }

  void _onMapCreated(VietmapController controller) {
    this.controller = controller;
  }

  // _onSymboltapped(Stations station) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(station.stationName!),
  //         content: Text(station.description!),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text("Close"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Widget loadRoute() {
    return FutureBuilder<Routes?>(
      future: RouteService.getRouteByRouteId(widget.tour.tourRoute!.routeId!),
      builder: (BuildContext context, AsyncSnapshot<Routes?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: Padding(
            padding: EdgeInsets.only(top: kMediumPadding),
            child: CircularProgressIndicator(color: ColorPalette.primaryColor),
          ));
        } else if (snapshot.hasData) {
          Routes? route = snapshot.data;
          wayPoints = [];
          Map<String, dynamic> geoJsonData =
              Map<String, Object>.from(route!.geoJson!);

          List<LatLng> coordinates =
              (geoJsonData['geometry']['coordinates'] as List)
                  .map((coord) => LatLng(coord[1], coord[0]))
                  .toList();

          geometry = coordinates;
          _kTripStations = [];
          targetPoint = LatLng(
              double.parse(
                  route.routeSegment![0].segmentDepartureStation!.latitude!),
              double.parse(
                  route.routeSegment![0].segmentDepartureStation!.longitude!));
          wayPoints.add(WayPoint(
              name: route.routeSegment![0].segmentDepartureStation!.stationName,
              latitude: double.parse(
                  route.routeSegment![0].segmentDepartureStation!.latitude!),
              longitude: double.parse(
                  route.routeSegment![0].segmentDepartureStation!.longitude!)));
          if (route != null) {
            if (route.routeSegment != null) {
              _kTripStations
                  .add(route.routeSegment![0].segmentDepartureStation!);
              // wayPoints.add(WayPoint(
              //     name: route
              //         .routeSegment![0].segmentDepartureStation!.stationName,
              //     latitude: double.parse(route
              //         .routeSegment![0].segmentDepartureStation!.latitude!),
              //     longitude: double.parse(route
              //         .routeSegment![0].segmentDepartureStation!.longitude!)));
              for (var segment in route.routeSegment!) {
                if (segment.segmentRoutePoiDetail != null) {
                  for (var poi in segment.segmentRoutePoiDetail!) {
                    pointList!.add(poi.routePoiDetailPoi!);
                    wayPoints.add(WayPoint(
                        name: poi.routePoiDetailPoi!.poiName,
                        latitude:
                            double.parse(poi.routePoiDetailPoi!.latitude!),
                        longitude:
                            double.parse(poi.routePoiDetailPoi!.longitude!)));
                    _kTripPoints.add(poi.routePoiDetailPoi!);
                  }
                }
                // if (segment.segmentDepartureStation != null) {
                //   wayPoints.add(WayPoint(
                //       name: segment.segmentDepartureStation?.stationName,
                //       latitude: double.parse(
                //           segment.segmentDepartureStation!.latitude!),
                //       longitude: double.parse(
                //           segment.segmentDepartureStation!.longitude!)));
                // }
                if (segment.segmentEndStation != null) {
                  wayPoints.add(WayPoint(
                      name: segment.segmentEndStation?.stationName,
                      latitude:
                          double.parse(segment.segmentEndStation!.latitude!),
                      longitude:
                          double.parse(segment.segmentEndStation!.longitude!)));

                  _kTripStations.add(segment.segmentEndStation!);
                }
              }
            }

            if (route != null) {
              return SafeArea(
                child: Stack(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: VietmapGL(
                        // onMapClick: (point, coordinates) => {
                        //   for (int i = 0; i < _kTripStations.length; i++)
                        //     {
                        //       deviationLat = (coordinates.latitude -
                        //               double.parse(
                        //                   _kTripStations[i].latitude!)) *
                        //           (coordinates.latitude -
                        //               double.parse(
                        //                   _kTripStations[i].latitude!)),
                        //       deviationLong = (coordinates.longitude -
                        //               double.parse(
                        //                   _kTripStations[i].longitude!)) *
                        //           (coordinates.latitude -
                        //               double.parse(
                        //                   _kTripStations[i].latitude!)),
                        //       if (deviationLat! < 1 && deviationLong! < 1)
                        //         {_onSymboltapped(_kTripStations[i])}
                        //     }
                        // },
                        trackCameraPosition: true,
                        zoomGesturesEnabled: true,
                        initialCameraPosition:
                            CameraPosition(target: targetPoint, zoom: 15),
                        onMapCreated: _onMapCreated,
                        onStyleLoadedCallback: _onStyleLoadedCallback,
                        myLocationTrackingMode:
                            MyLocationTrackingMode.TrackingGPS,
                        minMaxZoomPreference: const MinMaxZoomPreference(6, 25),
                        styleString:
                            'https://maps.vietmap.vn/api/maps/light/styles.json?apikey=$apiKey',
                        myLocationEnabled: true,
                      ),
                    ),
                    Positioned(
                      bottom: kDefaultIconSize / 2,
                      left: kDefaultIconSize / 2,
                      right: kDefaultIconSize / 2,
                      child: FloatingActionButton.small(
                        onPressed: () {
                          openStationsOverlay(widget.tour);
                        },
                        backgroundColor: ColorPalette.primaryColor,
                        focusColor: const Color.fromARGB(255, 220, 216, 216),
                        child: Text(
                          'Xem chi tiết tuyến đường',
                          style: TextStyles.regularStyle.whiteTextColor,
                        ),
                      ),
                    ),
                    // Positioned(
                    //     bottom: kDefaultIconSize / 2,
                    //     left: kDefaultIconSize / 2,
                    //     right: kDefaultIconSize / 2,
                    //     child: Container(
                    //       padding: const EdgeInsets.all(kMediumPadding / 2),
                    //       decoration: BoxDecoration(
                    //           color: Colors.white,
                    //           borderRadius: BorderRadius.circular(5)),
                    //       height: kMediumPadding * 5,
                    //       child: SingleChildScrollView(
                    //         child: Wrap(
                    //           direction: Axis.vertical,
                    //           spacing: kDefaultIconSize / 2,
                    //           children: [
                    //             for (var i = 0; i < _kTripStations.length; i++)
                    //               Text(
                    //                 'Station ${i + 1}: ${_kTripStations[i].stationName!}',
                    //                 style: TextStyles
                    //                     .defaultStyle.bold.subTitleTextColor,
                    //               ),
                    //           ],
                    //         ),
                    //       ),
                    //     )),
                    Positioned(
                        top: kMediumPadding,
                        left: kMediumPadding / 2,
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(kMediumPadding))),
                          child: IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                size: kDefaultIconSize,
                              )),
                        )),
                    // Positioned(
                    //     top: kMediumPadding,
                    //     right: kMediumPadding / 2,
                    //     child: FloatingActionButton(
                    //         backgroundColor: Colors.white,
                    //         shape: const CircleBorder(),
                    //         onPressed: () {
                    //           if (isPlay) {
                    //             player.pause();
                    //           } else {
                    //             player.play();
                    //           }
                    //           setState(() {
                    //             isPlay = !isPlay;
                    //           });
                    //         },
                    //         child: isPlay
                    //             ? const Icon(
                    //                 Icons.stop,
                    //                 size: kDefaultIconSize * 1.5,
                    //                 color: Colors.black,
                    //               )
                    //             : const Icon(
                    //                 Icons.play_arrow_rounded,
                    //                 size: kDefaultIconSize * 1.5,
                    //                 color: Colors.black,
                    //               ))),
                    // Positioned(
                    //     top: kMediumPadding + kDefaultIconSize * 3.5,
                    //     right: kMediumPadding / 2,
                    //     child: FloatingActionButton(
                    //         backgroundColor: Colors.white,
                    //         shape: const CircleBorder(),
                    //         onPressed: () {},
                    //         child: const Icon(
                    //           Icons.language_outlined,
                    //           size: kDefaultIconSize * 2,
                    //           color: Colors.black,
                    //         ))),
                  ],
                ),
              );
            } else {
              return const Text('No schedules found.');
            }
          } else {
            return const Text('No schedules found.');
          }
        } else if (snapshot.hasError) {
          // Display an error message if the future completed with an error
          return Center(
              child: Column(
            children: [
              ImageHelper.loadFromAsset(AssetHelper.error),
              const SizedBox(height: 10),
              Text(
                snapshot.error.toString(),
                style: TextStyles.regularStyle,
              )
            ],
          ));
        } else {
          return const SizedBox(); // Return an empty container or widget if data is null
        }
      },
    );
  }

  _onStyleLoadedCallback() async {
    geometry = geometry;
    print('This is geometry $geometry');

    // for (int i = 0; i < geometry.length; i++) {
    //   controller?.addSymbol(
    //     SymbolOptions(
    //       geometry: LatLng(geometry[i].latitude, geometry[i].longitude),
    //       iconSize: 0.15,
    //       iconImage: "assets/icons/station.png",
    //       textSize: 20,
    //     ),
    //   );
    // }

    for (int i = 0; i < geometry.length; i++) {
      if (i < geometry.length - 1) {
        if (i % 2 == 0) {
          LatLng from = geometry[i];
          LatLng to = geometry[i + 1];
          addArrowMarker(from, to);
        }
      }
    }

    for (int i = 0; i < _kTripPoints.length; i++) {
      controller?.addSymbol(
        SymbolOptions(
          geometry: LatLng(double.parse(_kTripPoints[i].latitude!),
              double.parse(_kTripPoints[i].longitude!)),
          iconSize: 0.15,
          iconImage: "assets/icons/point_of_interest_icon.png",
          textSize: 20,
        ),
      );
    }

    for (int i = 0; i < _kTripStations.length; i++) {
      controller?.addSymbol(
        SymbolOptions(
          geometry: LatLng(double.parse(_kTripStations[i].latitude!),
              double.parse(_kTripStations[i].longitude!)),
          iconSize: 0.15,
          iconImage: "assets/icons/station.png",
          textSize: 20,
        ),
      );
    }

    if (controller != null) {
      List<LatLng> polylineCoordinates = [];

      // Add each coordinate to the `polylineCoordinates` list
      for (LatLng point in geometry) {
        polylineCoordinates.add(point);
      }

      if (polylineCoordinates.isNotEmpty) {
        final polylineResult = controller?.addPolyline(
          PolylineOptions(
            geometry: polylineCoordinates, // List of LatLng coordinates
            polylineColor: ColorPalette.primaryColor, // Line color (blue)
            polylineWidth: 3.0, // Line width
          ),
        );

        if (polylineResult != null) {
          print('Polyline added successfully.');
        } else {
          print('Failed to add the polyline to the map.');
        }
      } else {
        print('No coordinates provided for the polyline.');
      }
    } else {
      print('Map is not ready or VietmapController is not initialized.');
    }
  }

  String getDirection(double bearing) {
    if ((bearing >= 335 && bearing < 360) || (bearing >= 0 && bearing < 22.5)) {
      return "up"; // Up arrow
    } else if (bearing >= 22.5 && bearing < 67.5) {
      return "up-right"; // Up-right arrow
    } else if (bearing >= 67.5 && bearing < 112.5) {
      return "right"; // Right arrow
    } else if (bearing >= 112.5 && bearing < 157.5) {
      return "down-right"; // Down-right arrow
    } else if (bearing >= 157.5 && bearing < 202.5) {
      return "down"; // Down arrow
    } else if (bearing >= 202.5 && bearing < 247.5) {
      return "down-left"; // Down-left arrow
    } else if (bearing >= 247.5 && bearing < 292) {
      return "left"; // Left arrow
    } else {
      return "up-left"; // Up-left arrow
    }
  }

  void addArrowMarker(LatLng from, LatLng to) {
    double bearing = getBearing(from, to);

    // Determine the direction based on the bearing
    String direction = getDirection(bearing);

    // Add custom arrow markers based on direction

    controller?.addSymbol(
      SymbolOptions(
        geometry: to,
        iconSize: 0.075,
        iconImage:
            "assets/icons/$direction.png", // Replace with the actual arrow images
        textSize: 20,
      ),
    );
  }

  double getBearing(LatLng from, LatLng to) {
    double lat1 = from.latitude * pi / 180.0;
    double lon1 = from.longitude * pi / 180.0;
    double lat2 = to.latitude * pi / 180.0;
    double lon2 = to.longitude * pi / 180.0;

    double angle = -math.atan2(
        math.sin(lon1 - lon2) * math.cos(lat2),
        math.cos(lat1) * math.sin(lat2) -
            math.sin(lat1) * math.cos(lat2) * math.cos(lon1 - lon2));

    if (angle < 0.0) angle += 2 * pi;

    // Convert the angle to degrees.
    angle = angle * (180 / pi);

    return angle;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loadRoute(),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
