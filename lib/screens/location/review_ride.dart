import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:nbtour/constant/colors.dart';
import 'package:nbtour/constant/dimension.dart';
import 'package:nbtour/constant/text_style.dart';
import 'package:nbtour/helper/commons.dart';
import 'package:nbtour/helper/map_box_handler.dart';
import 'package:nbtour/helper/shared_prefs.dart';
import 'package:nbtour/main.dart';
import 'package:nbtour/models/route_model.dart';
import 'package:nbtour/models/schedule_model.dart';
import 'package:nbtour/models/tour_model.dart';
import 'package:nbtour/screens/tour_guide/tour_screen.dart';
import 'package:nbtour/widgets/map_widget/review_ride_bottom_sheet.dart';
import 'package:nbtour/services/route_service.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';

class ReviewRide extends StatefulWidget {
  const ReviewRide(
      {Key? key,
      required this.tourId,
      required this.tourName,
      required this.routeId})
      : super(key: key);

  final String routeId;
  final String tourId;
  final String tourName;

  @override
  State<ReviewRide> createState() => _ReviewRideState();
}

List<LatLng> _kTripEndPoints = [];

class _ReviewRideState extends State<ReviewRide> {
  late VietmapController controller;
  LatLng targetPoint = const LatLng(0, 0);
  void initializeLocationAndSave() async {
    // Ensure all permissions are collected for Locations
    Location _location = Location();
    bool? _serviceEnabled;
    PermissionStatus? _permissionGranted;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
    }

    // Get the current user location
    LocationData _locationData = await _location.getLocation();
    LatLng currentLocation =
        LatLng(_locationData.latitude!, _locationData.longitude!);

    // Get the current user address

    // Store the user location in sharedPreferences
    sharedPreferences.setDouble('latitude', _locationData.latitude!);
    sharedPreferences.setDouble('longitude', _locationData.longitude!);
  }

  // Mapbox Maps SDK related

  // Directions API response related
  // late String distance;
  // late String dropOffTime;
  // late Map geometry;

// Convert listCoordinates into the required format
  var geometry = {
    "coordinates": [],
    "type": "LineString",
  };
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
          targetPoint = LatLng(
              double.parse(
                  route!.routeDetail![0].routeDetailStation!.latitude!),
              double.parse(
                  route.routeDetail![0].routeDetailStation!.longitude!));

          if (route != null) {
            if (route.routeDetail != null) {
              for (var detail in route.routeDetail!) {
                if (detail.routeDetailStation != null) {
                  for (var step in detail.routeDetailStep!) {
                    if (step != null) {
                      _kTripEndPoints.add(
                        LatLng(double.parse(step.latitude!),
                            double.parse(step.longitude!)),
                      );
                    }
                  }
                }
              }
            }

            print(route);
            if (route != null) {
              return SafeArea(
                child: Stack(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: VietmapGL(
                        zoomGesturesEnabled: true,
                        trackCameraPosition: true,
                        initialCameraPosition:
                            CameraPosition(target: targetPoint, zoom: 15),
                        onMapCreated: _onMapCreated,
                        onStyleLoadedCallback: _onStyleLoadedCallback,
                        myLocationTrackingMode:
                            MyLocationTrackingMode.TrackingGPS,
                        minMaxZoomPreference: const MinMaxZoomPreference(6, 25),
                        styleString: '',
                      ),
                    ),
                    reviewRideBottomSheet(context, route.distance.toString(),
                        widget.tourName, _kTripEndPoints),
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

  _onMapCreated(VietmapController controller) async {
    this.controller = controller;
    List<LatLng> polylineCoordinates = [];

    // Add each coordinate to the `polylineCoordinates` list
    for (LatLng point in _kTripEndPoints) {
      polylineCoordinates.add(point);
    }
    controller.addPolyline(
      PolylineOptions(
        geometry: polylineCoordinates, // List of LatLng coordinates
        polylineColor: Colors.blue, // Line color
        polylineWidth: 3.0, // Line width
      ),
    );
    // controller.addLine(
    //   LineOptions(
    //     geometry: _kTripEndPoints,
    //     lineColor: Colors.indigo.toHexStringRGB(), // Line color
    //     lineWidth: 3.0, // Line width
    //   ),
    // );
  }

  _onStyleLoadedCallback() async {
    List<List<double>> coordinates = _kTripEndPoints
        .map((latLng) => [latLng.latitude, latLng.longitude])
        .toList();

    geometry = {"coordinates": coordinates, "type": "LineString"};
    print(_kTripEndPoints);
    print('This is geometry $geometry');
    for (int i = 0; i < _kTripEndPoints.length; i++) {
      String iconImage = '';
      if (i == 0) {
        iconImage = "circle";
        await controller.addSymbol(
          SymbolOptions(
            geometry: _kTripEndPoints[i],
            iconSize: 0.075,
            iconImage: "assets/icons/$iconImage.png",
          ),
        );
      } else {
        await controller.addSymbol(
          SymbolOptions(
            geometry: _kTripEndPoints[i],
          ),
        );
      }
    }
    // _addSourceAndLineLayer();
  }

  // _addSourceAndLineLayer() async {
  //   List<List<double>> coordinates = _kTripEndPoints
  //       .map((latLng) => [latLng.latitude, latLng.longitude])
  //       .toList();

  //   geometry = {"coordinates": coordinates, "type": "LineString"};
  //   print(_kTripEndPoints);
  //   print('This is geometry $geometry');
  //   final fills = {
  //     "type": "FeatureCollection",
  //     "features": [
  //       {
  //         "type": "Feature",
  //         "id": 0,
  //         "properties": <String, dynamic>{},
  //         "geometry": geometry,
  //       },
  //     ],
  //   };

  //   // Add new source and lineLayer
  //   await controller.addSource("fills", GeojsonSourceProperties(data: fills));
  //   await controller.addLineLayer(
  //     "fills",
  //     "lines",
  //     LineLayerProperties(
  //       lineColor: Colors.indigo.toHexStringRGB(),
  //       lineCap: "round",
  //       lineJoin: "round",
  //       lineWidth: 3,
  //     ),
  //   );
  // }

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
    );
  }
}
