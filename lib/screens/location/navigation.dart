import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nbtour/components/bottom_sheet_address_info.dart';
import 'package:nbtour/components/floating_search_bar.dart';
import 'package:nbtour/constant/colors.dart';
import 'package:nbtour/constant/dimension.dart';
import 'package:nbtour/constant/text_style.dart';
import 'package:nbtour/helper/shared_prefs.dart';
import 'package:nbtour/main.dart';
import 'package:nbtour/models/domain/repositories/vietmap_api_repositories.dart';
import 'package:nbtour/models/domain/usecases/get_location_from_latlng_usecase.dart';
import 'package:nbtour/models/domain/usecases/get_place_detail_usecase.dart';
import 'package:nbtour/models/vietnam_map/vietmap_place_model.dart';
import 'package:nbtour/models/vietnam_map/vietmap_reverse_model.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
import 'package:vietmap_flutter_navigation/embedded/controller.dart';
import 'package:vietmap_flutter_navigation/helpers.dart';
import 'package:vietmap_flutter_navigation/models/options.dart';
import 'package:vietmap_flutter_navigation/models/route_progress_event.dart';
import 'package:vietmap_flutter_navigation/models/way_point.dart';
import 'package:vietmap_flutter_navigation/navigation_plugin.dart';
import 'package:vietmap_flutter_navigation/views/banner_instruction.dart';
import 'package:vietmap_flutter_navigation/views/bottom_action.dart';
import 'package:vietmap_flutter_navigation/views/navigation_view.dart';

class VietMapNavigationScreen extends StatefulWidget {
  const VietMapNavigationScreen(
      {super.key, required this.wayPoints, required this.tourId});
  final List<WayPoint> wayPoints;
  final String tourId;
  @override
  State<VietMapNavigationScreen> createState() =>
      _VietMapNavigationScreenState();
}

class _VietMapNavigationScreenState extends State<VietMapNavigationScreen> {
  MapNavigationViewController? _controller;
  late MapOptions _navigationOption;
  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );
  final _vietmapNavigationPlugin = VietMapNavigationPlugin();

  bool isBuild = false;
  List<WayPoint> wayPoints = [];
  List<WayPoint> currentWayPoints = [];
  Widget instructionImage = const SizedBox.shrink();
  String guideDirection = "";
  Widget recenterButton = const SizedBox.shrink();
  RouteProgressEvent? routeProgressEvent;
  bool _isRouteBuilt = false;
  bool _isRunning = false;
  FocusNode focusNode = FocusNode();
  int currentWayPointIndex = 0;
  String stationName = '';

  String? checkTourId = '';

  @override
  void initState() {
    super.initState();
    // _getCurrentLocation();

    initialize();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Geolocator.requestPermission();
    });
  }

  // Future<Position> _getCurrentLocation() async {
  //   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     return Future.error('Location services are disabled');
  //   }

  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     if (permission == LocationPermission.denied) {
  //       return Future.error('Location permissions are denied');
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     return Future.error(
  //         'Location permissions are permanently denied, we can not request');
  //   }

  //   return await Geolocator.getCurrentPosition();
  // }

  Future<void> initialize() async {
    Geolocator.getPositionStream().listen((Position position) {
      // Handle the location updates here
      print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
    });
    if (!mounted) return;

    _navigationOption = _vietmapNavigationPlugin.getDefaultOptions();
    _navigationOption.simulateRoute = true;

    _navigationOption.apiKey =
        'c3d0f188ff669f89042771a20656579073cffec5a8a69747';
    _navigationOption.mapStyle =
        "https://run.mocky.io/v3/64ad9ec6-2715-4d56-a335-dedbfe5bc46d";
    _navigationOption.customLocationCenterIcon =
        await VietMapHelper.getBytesFromAsset('assets/download.jpeg');
    _vietmapNavigationPlugin.setDefaultOptions(_navigationOption);
  }

  void _startNavigationForNextWayPoints() {
    try {
      checkTourId = sharedPreferences.getString("tourCheck");
      sharedPreferences.remove("tourCheck");
      sharedPreferences.setString("tourCheck", widget.tourId);
      print('Check controllerrrrrrrrrrrrrr ${_controller.toString()}');
      print(
          'Check routeProgresssssssssssssssss ${routeProgressEvent.toString()}');
      _controller?.initialize();
      if (widget.tourId == checkTourId) {
        int? index = sharedPreferences.getInt("currentWayPointIndex");

        if (index != null) {
          if (index < widget.wayPoints.length) {
            currentWayPoints.clear();

            currentWayPoints.add(WayPoint(
                name: "PECC4", latitude: 12.247837, longitude: 109.195004));
            currentWayPoints.add(widget.wayPoints[index]);

            setState(() {
              _isRunning = true;
              _isRouteBuilt = false;
              stationName = widget.wayPoints[index].name!;
            });

            _controller?.buildAndStartNavigation(
              wayPoints: currentWayPoints,
              profile: DrivingProfile.drivingTraffic,
            );
            currentWayPointIndex = index;
            sharedPreferences.setInt("currentWayPointIndex", index);
          } else {
            _controller?.buildRoute(
              wayPoints: currentWayPoints,
              profile: DrivingProfile.drivingTraffic,
            );
            sharedPreferences.remove('currentWayPointIndex');
            setState(() {
              _isRunning = true;
              routeProgressEvent = null;
            });
            _controller?.finishNavigation();
            _controller?.clearRoute();
            // All waypoints have been processed
            currentWayPointIndex = 0;
            currentWayPoints.clear();
            sharedPreferences.remove("currentWayPointIndex");
            sharedPreferences.remove("tourCheck");
          }
        } else {
          if (currentWayPointIndex < widget.wayPoints.length) {
            currentWayPoints.clear();

            currentWayPoints.add(WayPoint(
                name: "PECC4", latitude: 12.247837, longitude: 109.195004));
            currentWayPoints.add(widget.wayPoints[currentWayPointIndex]);

            setState(() {
              _isRunning = true;
              _isRouteBuilt = false;
              stationName = widget.wayPoints[currentWayPointIndex].name!;
            });

            _controller?.buildAndStartNavigation(
              wayPoints: currentWayPoints,
              profile: DrivingProfile.drivingTraffic,
            );
            sharedPreferences.setInt(
                "currentWayPointIndex", currentWayPointIndex);
          } else {
            _controller?.buildRoute(
              wayPoints: currentWayPoints,
              profile: DrivingProfile.drivingTraffic,
            );
            sharedPreferences.remove('currentWayPointIndex');
            setState(() {
              _isRunning = true;
              routeProgressEvent = null;
            });
            _controller?.finishNavigation();
            _controller?.clearRoute();
            // All waypoints have been processed
            currentWayPointIndex = 0;
            currentWayPoints.clear();
            sharedPreferences.remove("currentWayPointIndex");
            sharedPreferences.remove("tourCheck");
          }
        }
      } else {
        if (currentWayPointIndex < widget.wayPoints.length) {
          currentWayPoints.clear();
          currentWayPoints.add(WayPoint(
              name: "PECC4", latitude: 12.247837, longitude: 109.195004));
          currentWayPoints.add(widget.wayPoints[currentWayPointIndex]);

          setState(() {
            _isRunning = true;
            _isRouteBuilt = false;
            stationName = widget.wayPoints[currentWayPointIndex].name!;
          });
          _controller?.buildAndStartNavigation(
            wayPoints: currentWayPoints,
            profile: DrivingProfile.drivingTraffic,
          );
          sharedPreferences.setInt(
              "currentWayPointIndex", currentWayPointIndex);
        } else {
          _controller?.buildRoute(
            wayPoints: currentWayPoints,
            profile: DrivingProfile.drivingTraffic,
          );
          sharedPreferences.remove('currentWayPointIndex');
          setState(() {
            _isRunning = true;
            routeProgressEvent = null;
          });
          _controller?.finishNavigation();
          _controller?.clearRoute();
          // All waypoints have been processed
          currentWayPointIndex = 0;
          currentWayPoints.clear();
          sharedPreferences.remove("currentWayPointIndex");
          sharedPreferences.remove("tourCheck");
        }
      }
    } catch (e) {
      Text('');
    }
  }

  Widget _buildWaypointButton(int index) {
    return Center(
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: const BorderSide(color: Colors.blue),
            ),
          ),
        ),
        onPressed: () {
          currentWayPointIndex = index;
          setState(() {
            stationName = widget.wayPoints[index].name!;
            isBuild = true;
            _isRunning = true;
            _isRouteBuilt = false;
          });
          currentWayPoints.clear();
          currentWayPoints.add(WayPoint(
              name: "PECC4", latitude: 12.247837, longitude: 109.195004));
          currentWayPoints.add(WayPoint(
              name: widget.wayPoints[index].name,
              latitude: widget.wayPoints[index].latitude,
              longitude: widget.wayPoints[index].longitude));
          _controller?.buildAndStartNavigation(
              wayPoints: currentWayPoints,
              profile: DrivingProfile.drivingTraffic);
          sharedPreferences.setInt("currentWayPointIndex", index);
          sharedPreferences.setString("tourCheck", widget.tourId);
        },
        child: Text(
            'Show direction to station ${index + 1}: ${widget.wayPoints[index].name}'),
      ),
    );
  }

  MapOptions? options;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            NavigationView(
              mapOptions: _navigationOption,
              onNewRouteSelected: (p0) {
                log(p0.toString());
              },
              onMapCreated: (p0) {
                _controller = p0;
              },
              onMapMove: () => _showRecenterButton(),
              onRouteBuilt: (p0) {
                setState(() {
                  EasyLoading.dismiss();
                  _isRouteBuilt = true;
                });
              },
              onMapRendered: () async {
                _controller?.setCenterIcon(
                    await VietMapHelper.getBytesFromAsset(
                        'assets/download.jpeg'));
              },
              onMapLongClick: (WayPoint? point) async {
                if (_isRunning) return;
                EasyLoading.show();
                var data =
                    await GetLocationFromLatLngUseCase(VietmapApiRepositories())
                        .call(LocationPoint(
                            lat: point?.latitude ?? 0,
                            long: point?.longitude ?? 0));
                EasyLoading.dismiss();
                data.fold((l) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Có lỗi xảy ra')));
                }, (r) => _showBottomSheetInfo(r));
              },
              // onMapClick: (WayPoint? point) async {
              //   if (_isRunning) return;
              //   if (focusNode.hasFocus) {
              //     FocusScope.of(context).requestFocus(FocusNode());
              //     return;
              //   }
              //   EasyLoading.show();
              //   var data =
              //       await GetLocationFromLatLngUseCase(VietmapApiRepositories())
              //           .call(LocationPoint(
              //               lat: point?.latitude ?? 0,
              //               long: point?.longitude ?? 0));
              //   EasyLoading.dismiss();
              //   data.fold((l) {
              //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              //         content:
              //             Text('Không tìm thấy địa điểm gần vị trí bạn chọn')));
              //   }, (r) => _showBottomSheetInfo(r));
              // },
              onRouteProgressChange: (RouteProgressEvent routeProgressEvent) {
                print(
                    "This is route progress eventtttttttt $routeProgressEvent");
                setState(() {
                  this.routeProgressEvent = routeProgressEvent;
                });
                _setInstructionImage(routeProgressEvent.currentModifier,
                    routeProgressEvent.currentModifierType);
              },
              onArrival: () {
                setState(() {
                  _isRunning = false;
                  routeProgressEvent = null;
                });
                currentWayPointIndex += 1;
                sharedPreferences.setInt(
                    "currentWayPointIndex", currentWayPointIndex);
                sharedPreferences.setString("tourCheck", widget.tourId);

                _startNavigationForNextWayPoints();
              },
            ),

            Positioned(
                top: MediaQuery.of(context).viewPadding.top,
                left: 0,
                child: BannerInstructionView(
                  routeProgressEvent: routeProgressEvent,
                  instructionIcon: instructionImage,
                )),
            Positioned(
                bottom: 0,
                child: BottomActionView(
                  recenterButton: recenterButton,
                  controller: _controller,
                  onOverviewCallback: _showRecenterButton,
                  onStopNavigationCallback: _onStopNavigation,
                  routeProgressEvent: routeProgressEvent,
                )),

            _isRunning
                ? Positioned(
                    top: MediaQuery.of(context).size.height / 2 -
                        kMediumPadding * 9.3,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.transparent)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Going to",
                            style: TextStyle(
                                color: ColorPalette.primaryColor,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: kDefaultPadding / 2,
                          ),
                          Text(
                            stationName,
                            style: TextStyles.defaultStyle,
                          ),
                        ],
                      ),
                    ))
                : !isBuild
                    ? Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (var i = 0; i < widget.wayPoints.length; i++)
                                _buildWaypointButton(i),
                              Center(
                                  child: ElevatedButton(
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                            side: const BorderSide(
                                                color: Colors.blue)))),
                                onPressed: () {
                                  setState(() {
                                    isBuild = true;
                                  });
                                  _startNavigationForNextWayPoints();
                                },
                                child: const Text('Start navigation'),
                              )),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),

            // _isRunning
            //     ? const SizedBox.shrink()
            //     : Positioned(
            //         top: MediaQuery.of(context).viewPadding.top + 20,
            //         child: FloatingSearchBar(
            //           focusNode: focusNode,
            //           onSearchItemClick: (p0) async {
            //             EasyLoading.show();
            //             VietmapPlaceModel? data;
            //             var res = await GetPlaceDetailUseCase(
            //                     VietmapApiRepositories())
            //                 .call(p0.refId ?? '');
            //             res.fold((l) {
            //               EasyLoading.dismiss();
            //               return;
            //             }, (r) {
            //               data = r;
            //             });
            //             wayPoints.clear();
            //             var location = await Geolocator.getCurrentPosition();
            //             wayPoints.add(WayPoint(
            //                 name: 'destination',
            //                 latitude: location.latitude,
            //                 longitude: location.longitude));
            //             if (data?.lat != null) {
            //               wayPoints.add(WayPoint(
            //                   name: '',
            //                   latitude: data?.lat,
            //                   longitude: data?.lng));
            //             }
            //             _controller?.buildRoute(wayPoints: wayPoints);
            //           },
            //         )),

            _isRouteBuilt && !_isRunning
                ? Positioned(
                    bottom: 20,
                    left: 0,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          side: const BorderSide(
                                              color: Colors.blue)))),
                              onPressed: () {
                                _isRunning = true;
                                routeProgressEvent = routeProgressEvent;
                                _startNavigationForNextWayPoints();
                              },
                              child: const Text('Bắt đầu')),
                          ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: const BorderSide(color: Colors.blue),
                                ),
                              ),
                            ),
                            onPressed: () {
                              _controller?.clearRoute();
                              sharedPreferences.remove('currentWayPointIndex');
                              setState(() {
                                _isRunning = false;
                                _isRouteBuilt = false;
                                isBuild = false;
                                routeProgressEvent = null;
                              });
                              _controller?.finishNavigation();
                              _controller?.clearRoute();
                              // All waypoints have been processed
                              currentWayPointIndex = 0;
                              currentWayPoints.clear();
                              sharedPreferences.remove("currentWayPointIndex");
                              sharedPreferences.remove("tourCheck");
                            },
                            child: const Text('Xoá tuyến đường'),
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  _showRecenterButton() {
    sharedPreferences.setString("tourCheck", widget.tourId);
    recenterButton = TextButton(
        onPressed: () {
          _controller?.recenter();
          setState(() {
            recenterButton = const SizedBox.shrink();
          });
        },
        child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.white,
                border: Border.all(color: Colors.black45, width: 1)),
            child: const Row(
              children: [
                Icon(
                  Icons.keyboard_double_arrow_up_sharp,
                  color: Colors.lightBlue,
                  size: 35,
                ),
                Text(
                  'Về giữa',
                  style: TextStyle(fontSize: 18, color: Colors.lightBlue),
                )
              ],
            )));
    setState(() {});
  }

  _setInstructionImage(String? modifier, String? type) {
    if (modifier != null && type != null) {
      List<String> data = [
        type.replaceAll(' ', '_'),
        modifier.replaceAll(' ', '_')
      ];
      String path = 'assets/navigation_symbol/${data.join('_')}.svg';
      setState(() {
        instructionImage = SvgPicture.asset(path, color: Colors.white);
      });
    }
  }

  _onStopNavigation() {
    setState(() {
      _isRunning = false;
      routeProgressEvent = null;
    });
  }

  _showBottomSheetInfo(VietmapReverseModel data) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (_) => AddressInfo(
              data: data,
              buildRoute: () async {
                EasyLoading.show();
                wayPoints.clear();
                var location = await Geolocator.getCurrentPosition();

                wayPoints.add(WayPoint(
                    name: 'destination',
                    latitude: location.latitude,
                    longitude: location.longitude));
                if (data.lat != null) {
                  wayPoints.add(WayPoint(
                      name: '', latitude: data.lat, longitude: data.lng));
                }
                _controller?.buildRoute(wayPoints: currentWayPoints);
                if (!mounted) return;
                Navigator.pop(context);
              },
              buildAndStartRoute: () async {
                EasyLoading.show();
                wayPoints.clear();
                var location = await Geolocator.getCurrentPosition();
                wayPoints.add(WayPoint(
                    name: 'destination',
                    latitude: location.latitude,
                    longitude: location.longitude));
                if (data.lat != null) {
                  wayPoints.add(WayPoint(
                      name: '', latitude: data.lat, longitude: data.lng));
                }
                _controller?.buildAndStartNavigation(
                    wayPoints: currentWayPoints,
                    profile: DrivingProfile.drivingTraffic);
                setState(() {
                  _isRunning = true;
                });
                if (!mounted) return;
                Navigator.pop(context);
              },
            ));
  }

  @override
  void dispose() {
    _controller?.onDispose();
    super.dispose();
  }
}
