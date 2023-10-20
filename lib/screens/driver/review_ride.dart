import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:location/location.dart';
import 'package:nbtour/constant/colors.dart';
import 'package:nbtour/constant/dimension.dart';
import 'package:nbtour/constant/text_style.dart';
import 'package:nbtour/main.dart';
import 'package:nbtour/models/route_model.dart';
import 'package:nbtour/widgets/map_widget/review_ride_bottom_sheet.dart';
import 'package:nbtour/services/route_service.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
import 'package:vietmap_flutter_navigation/models/way_point.dart';

class ReviewRideDriverScreen extends StatefulWidget {
  const ReviewRideDriverScreen(
      {Key? key,
      required this.tourId,
      required this.tourName,
      required this.routeId})
      : super(key: key);

  final String routeId;
  final String tourId;
  final String tourName;

  @override
  State<ReviewRideDriverScreen> createState() => _ReviewRideDriverScreenState();
}

List<LatLng> _kTripEndPoints = [];
UserLocation? userLocation;

class _ReviewRideDriverScreenState extends State<ReviewRideDriverScreen> {
  late VietmapController? controller;
  List<Marker> temp = [];
  late Map geometry;
  List<WayPoint> wayPoints = [];
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
    _kTripEndPoints = [];
  }

  Widget loadRoute() {
    print(' This is routeIddddddddddddd ${widget.routeId}');
    return FutureBuilder<Routes?>(
      future: RouteService.getRouteByRouteId(widget.routeId),
      builder: (BuildContext context, AsyncSnapshot<Routes?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: Padding(
            padding: EdgeInsets.only(top: kMediumPadding),
            child: CircularProgressIndicator(color: ColorPalette.primaryColor),
          ));
        } else if (snapshot.hasData) {
          Routes? route = snapshot.data;

          geometry = Map<String, Object>.from(route!.geoJson!);

          targetPoint = LatLng(
              double.parse(
                  route.routeSegment![0].segmentDepartureStation!.latitude!),
              double.parse(
                  route.routeSegment![0].segmentDepartureStation!.longitude!));
          if (route != null) {
            if (route.routeSegment != null) {
              _kTripEndPoints.add(
                LatLng(
                    double.parse(route
                        .routeSegment![0].segmentDepartureStation!.latitude!),
                    double.parse(route
                        .routeSegment![0].segmentDepartureStation!.longitude!)),
              );
              for (var segment in route.routeSegment!) {
                if (segment.segmentDepartureStation != null) {
                  wayPoints.add(WayPoint(
                      name: segment.segmentDepartureStation?.stationName,
                      latitude: double.parse(
                          segment.segmentDepartureStation!.latitude!),
                      longitude: double.parse(
                          segment.segmentDepartureStation!.longitude!)));
                }
                if (segment.segmentEndStation != null) {
                  wayPoints.add(WayPoint(
                      name: segment.segmentEndStation?.stationName,
                      latitude:
                          double.parse(segment.segmentEndStation!.latitude!),
                      longitude:
                          double.parse(segment.segmentEndStation!.longitude!)));
                  _kTripEndPoints.add(
                    LatLng(double.parse(segment.segmentEndStation!.latitude!),
                        double.parse(segment.segmentEndStation!.longitude!)),
                  );
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
                        zoomGesturesEnabled: true,
                        initialCameraPosition:
                            CameraPosition(target: targetPoint, zoom: 15),
                        onMapCreated: _onMapCreated,
                        onStyleLoadedCallback: _onStyleLoadedCallback,
                        myLocationTrackingMode:
                            MyLocationTrackingMode.TrackingGPS,
                        minMaxZoomPreference: const MinMaxZoomPreference(6, 25),
                        styleString:
                            'https://run.mocky.io/v3/64ad9ec6-2715-4d56-a335-dedbfe5bc46d',
                        myLocationEnabled: true,
                      ),
                    ),
                    reviewRideBottomSheet(context, route.distance.toString(),
                        widget.tourName, wayPoints, widget.tourId),
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
          return Text('Error: ${snapshot.error}');
        } else {
          return const SizedBox(); // Return an empty container or widget if data is null
        }
      },
    );
  }

  // _initialiseDirectionsResponse() {
  //   geometry = widget.modifiedResponse['geometry'];
  // }

  void _onMapCreated(VietmapController controller) {
    this.controller = controller;
  }

  _onStyleLoadedCallback() async {
    geometry = geometry;
    print('This is geometry $geometry');
    for (int i = 0; i < _kTripEndPoints.length; i++) {
      controller?.addSymbol(
        SymbolOptions(
          geometry: _kTripEndPoints[i],
          iconSize: 0.15,
          iconImage: "assets/icons/station.png",
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back)),
        title: Text(
          'Review Ride',
          style: TextStyles.defaultStyle.bold.fontHeader,
        ),
      ),
      body: loadRoute(),
      floatingActionButton:
          Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        Container(
          margin: const EdgeInsets.only(bottom: kMediumPadding * 8),
          child: FloatingActionButton(
            splashColor: Colors.transparent,
            highlightElevation: 0,
            backgroundColor: Colors.white,
            tooltip: 'Add polyline',
            onPressed: () {
              if (!isLined) {
                if (controller != null) {
                  List<LatLng> polylineCoordinates = [];

                  // Add each coordinate to the `polylineCoordinates` list
                  for (LatLng point in _kTripEndPoints) {
                    polylineCoordinates.add(point);
                  }

                  if (polylineCoordinates.isNotEmpty) {
                    final polylineResult = controller?.addPolyline(
                      PolylineOptions(
                        geometry:
                            polylineCoordinates, // List of LatLng coordinates
                        polylineColor: Colors.blue, // Line color (blue)
                        polylineWidth: 3.0, // Line width
                      ),
                    );

                    isLined = true;

                    if (polylineResult != null) {
                      print('Polyline added successfully.');
                    } else {
                      print('Failed to add the polyline to the map.');
                    }
                  } else {
                    print('No coordinates provided for the polyline.');
                  }
                } else {
                  print(
                      'Map is not ready or VietmapController is not initialized.');
                }
              } else {
                if (controller != null) {
                  controller?.clearLines();

                  isLined = false;
                } else {
                  print(
                      'Map is not ready or VietmapController is not initialized.');
                }
              }
            },
            child: const Icon(
              Icons.polyline,
            ),
          ),
        ),
      ]),
    );
  }
}
