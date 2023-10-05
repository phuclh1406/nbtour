import 'package:flutter/material.dart';

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
  late VietmapController? controller;
  List<WayPoint> wayPoints = [];
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
                  wayPoints.add(WayPoint(
                      name: detail.routeDetailStation?.stationName,
                      latitude:
                          double.parse(detail.routeDetailStation!.latitude!),
                      longitude:
                          double.parse(detail.routeDetailStation!.longitude!)));
                  _kTripEndPoints.add(
                    LatLng(double.parse(detail.routeDetailStation!.latitude!),
                        double.parse(detail.routeDetailStation!.longitude!)),
                  );
                }

                if (detail.routeDetailStation != null) {
                  if (detail.routeDetailStep != null) {
                    for (var step in detail.routeDetailStep!) {
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
                        styleString:
                            'https://run.mocky.io/v3/64ad9ec6-2715-4d56-a335-dedbfe5bc46d',
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
        controller?.addSymbol(
          SymbolOptions(
            geometry: _kTripEndPoints[i],
            iconSize: 0.075,
            iconImage: "assets/icons/$iconImage.png",
          ),
        );
      } else {
        iconImage = "circle";
        controller?.addSymbol(
          SymbolOptions(
            geometry: _kTripEndPoints[i],
            iconSize: 0.075,
            iconImage: "assets/icons/$iconImage.png",
          ),
        );
      }
    }
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
