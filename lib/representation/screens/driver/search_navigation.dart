// import 'dart:developer';

// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:nbtour/utils/components/bottom_sheet_address_info.dart';
// import 'package:nbtour/utils/components/floating_search_bar.dart';
// import 'package:nbtour/services/models/domain/repositories/vietmap_api_repositories.dart';
// import 'package:nbtour/services/models/domain/usecases/get_location_from_latlng_usecase.dart';
// import 'package:nbtour/services/models/domain/usecases/get_place_detail_usecase.dart';
// import 'package:nbtour/services/models/vietnam_map/vietmap_place_model.dart';
// import 'package:nbtour/services/models/vietnam_map/vietmap_reverse_model.dart';
// import 'package:vietmap_flutter_navigation/embedded/controller.dart';
// import 'package:vietmap_flutter_navigation/helpers.dart';
// import 'package:vietmap_flutter_navigation/models/options.dart';
// import 'package:vietmap_flutter_navigation/models/route_progress_event.dart';
// import 'package:vietmap_flutter_navigation/models/way_point.dart';
// import 'package:flutter/material.dart';
// import 'dart:async';

// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:vietmap_flutter_navigation/navigation_plugin.dart';
// import 'package:vietmap_flutter_navigation/views/banner_instruction.dart';
// import 'package:vietmap_flutter_navigation/views/bottom_action.dart';
// import 'package:vietmap_flutter_navigation/views/navigation_view.dart';

// class SearchNavigation extends StatefulWidget {
//   const SearchNavigation({super.key});

//   @override
//   State<SearchNavigation> createState() => _SearchNavigationState();
// }

// class _SearchNavigationState extends State<SearchNavigation> {
//   MapNavigationViewController? _controller;
//   late MapOptions _navigationOption;
//   final _vietmapNavigationPlugin = VietMapNavigationPlugin();
//   String apiKey = dotenv.env['VIETMAP_API_KEY']!;
//   List<WayPoint> wayPoints = [
//     WayPoint(name: "origin point", latitude: 10.759091, longitude: 106.675817),
//     WayPoint(
//         name: "destination point", latitude: 10.762528, longitude: 106.653099)
//   ];
//   Widget instructionImage = const SizedBox.shrink();
//   String guideDirection = "";
//   Widget recenterButton = const SizedBox.shrink();
//   RouteProgressEvent? routeProgressEvent;
//   bool _isRouteBuilt = false;
//   bool _isRunning = false;
//   FocusNode focusNode = FocusNode();
//   @override
//   void initState() {
//     super.initState();

//     initialize();
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
//       Geolocator.requestPermission();
//     });
//   }

//   Future<void> initialize() async {
//     Geolocator.getPositionStream().listen((Position position) {
//       // Handle the location updates here
//       print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
//     });
//     if (!mounted) return;

//     _navigationOption = _vietmapNavigationPlugin.getDefaultOptions();
//     _navigationOption.simulateRoute = true;

//     _navigationOption.apiKey = dotenv.env['VIETMAP_API_KEY']!;
//     _navigationOption.mapStyle =
//         "https://maps.vietmap.vn/api/maps/light/styles.json?apikey=$apiKey";
//     _navigationOption.customLocationCenterIcon =
//         await VietMapHelper.getBytesFromAsset('assets/download.jpeg');
//     _vietmapNavigationPlugin.setDefaultOptions(_navigationOption);
//   }

//   MapOptions? options;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         top: false,
//         child: Stack(
//           children: [
//             NavigationView(
//               mapOptions: _navigationOption,
//               onNewRouteSelected: (p0) {
//                 log(p0.toString());
//               },
//               onMapCreated: (p0) {
//                 _controller = p0;
//               },
//               onMapMove: () => _showRecenterButton(),
//               onRouteBuilt: (p0) {
//                 setState(() {
//                   EasyLoading.dismiss();
//                   _isRouteBuilt = true;
//                 });
//               },
//               onMapRendered: () async {
//                 _controller?.setCenterIcon(
//                     await VietMapHelper.getBytesFromAsset(
//                         'assets/download.jpeg'));
//               },
//               onMapLongClick: (WayPoint? point) async {
//                 if (_isRunning) return;
//                 EasyLoading.show();
//                 var data =
//                     await GetLocationFromLatLngUseCase(VietmapApiRepositories())
//                         .call(LocationPoint(
//                             lat: point?.latitude ?? 0,
//                             long: point?.longitude ?? 0));
//                 EasyLoading.dismiss();
//                 data.fold((l) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text('Có lỗi xảy ra')));
//                 }, (r) => _showBottomSheetInfo(r));
//               },
//               onMapClick: (WayPoint? point) async {
//                 if (_isRunning) return;
//                 if (focusNode.hasFocus) {
//                   FocusScope.of(context).requestFocus(FocusNode());
//                   return;
//                 }
//                 EasyLoading.show();
//                 var data =
//                     await GetLocationFromLatLngUseCase(VietmapApiRepositories())
//                         .call(LocationPoint(
//                             lat: point?.latitude ?? 0,
//                             long: point?.longitude ?? 0));
//                 EasyLoading.dismiss();
//                 data.fold((l) {
//                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//                       content:
//                           Text('Không tìm thấy địa điểm gần vị trí bạn chọn')));
//                 }, (r) => _showBottomSheetInfo(r));
//               },
//               onRouteProgressChange: (RouteProgressEvent routeProgressEvent) {
//                 setState(() {
//                   this.routeProgressEvent = routeProgressEvent;
//                 });

//                 _setInstructionImage(routeProgressEvent.currentModifier,
//                     routeProgressEvent.currentModifierType);
//               },
//               onArrival: () {
//                 _isRunning = false;
//                 ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Bạn đã tới đích')));
//               },
//             ),
//             Positioned(
//                 top: MediaQuery.of(context).viewPadding.top,
//                 left: 0,
//                 child: BannerInstructionView(
//                   routeProgressEvent: routeProgressEvent,
//                   instructionIcon: instructionImage,
//                 )),
//             Positioned(
//                 bottom: 0,
//                 child: BottomActionView(
//                   recenterButton: recenterButton,
//                   controller: _controller,
//                   onOverviewCallback: _showRecenterButton,
//                   onStopNavigationCallback: _onStopNavigation,
//                   routeProgressEvent: routeProgressEvent,
//                 )),
//             _isRunning
//                 ? const SizedBox.shrink()
//                 : Positioned(
//                     top: MediaQuery.of(context).viewPadding.top + 20,
//                     child: FloatingSearchBar(
//                       focusNode: focusNode,
//                       onSearchItemClick: (p0) async {
//                         EasyLoading.show();
//                         VietmapPlaceModel? data;
//                         var res = await GetPlaceDetailUseCase(
//                                 VietmapApiRepositories())
//                             .call(p0.refId ?? '');
//                         res.fold((l) {
//                           EasyLoading.dismiss();
//                           return;
//                         }, (r) {
//                           data = r;
//                         });
//                         wayPoints.clear();
//                         var location = await Geolocator.getCurrentPosition();
//                         wayPoints.add(WayPoint(
//                             name: 'destination',
//                             latitude: location.latitude,
//                             longitude: location.longitude));
//                         if (data?.lat != null) {
//                           wayPoints.add(WayPoint(
//                               name: '',
//                               latitude: data?.lat,
//                               longitude: data?.lng));
//                         }
//                         _controller?.buildRoute(wayPoints: wayPoints);
//                       },
//                     )),
//             _isRouteBuilt && !_isRunning
//                 ? Positioned(
//                     bottom: 20,
//                     left: 0,
//                     child: SizedBox(
//                       width: MediaQuery.of(context).size.width,
//                       child: Row(
//                         mainAxisSize: MainAxisSize.max,
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           ElevatedButton(
//                               style: ButtonStyle(
//                                   shape: MaterialStateProperty.all<
//                                           RoundedRectangleBorder>(
//                                       RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(18.0),
//                                           side: const BorderSide(
//                                               color: Colors.blue)))),
//                               onPressed: () {
//                                 _isRunning = true;
//                                 routeProgressEvent = routeProgressEvent;
//                                 _controller?.startNavigation();
//                               },
//                               child: const Text('Bắt đầu')),
//                           ElevatedButton(
//                               style: ButtonStyle(
//                                   shape: MaterialStateProperty.all<
//                                           RoundedRectangleBorder>(
//                                       RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(18.0),
//                                           side: const BorderSide(
//                                               color: Colors.blue)))),
//                               onPressed: () {
//                                 _controller?.clearRoute();
//                                 setState(() {
//                                   _isRouteBuilt = false;
//                                 });
//                               },
//                               child: const Text('Xoá tuyến đường')),
//                         ],
//                       ),
//                     ),
//                   )
//                 : const SizedBox.shrink()
//           ],
//         ),
//       ),
//     );
//   }

//   _showRecenterButton() {
//     recenterButton = TextButton(
//         onPressed: () {
//           _controller?.recenter();
//           setState(() {
//             recenterButton = const SizedBox.shrink();
//           });
//         },
//         child: Container(
//             height: 50,
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(50),
//                 color: Colors.white,
//                 border: Border.all(color: Colors.black45, width: 1)),
//             child: Row(
//               children: const [
//                 Icon(
//                   Icons.keyboard_double_arrow_up_sharp,
//                   color: Colors.lightBlue,
//                   size: 35,
//                 ),
//                 Text(
//                   'Về giữa',
//                   style: TextStyle(fontSize: 18, color: Colors.lightBlue),
//                 )
//               ],
//             )));
//     setState(() {});
//   }

//   _setInstructionImage(String? modifier, String? type) {
//     if (modifier != null && type != null) {
//       List<String> data = [
//         type.replaceAll(' ', '_'),
//         modifier.replaceAll(' ', '_')
//       ];
//       String path = 'assets/navigation_symbol/${data.join('_')}.svg';
//       setState(() {
//         instructionImage = SvgPicture.asset(path, color: Colors.white);
//       });
//     }
//   }

//   _onStopNavigation() {
//     setState(() {
//       routeProgressEvent = null;
//       _isRunning = false;
//     });
//   }

//   _showBottomSheetInfo(VietmapReverseModel data) {
//     showModalBottomSheet(
//         isScrollControlled: true,
//         context: context,
//         builder: (_) => AddressInfo(
//               data: data,
//               buildRoute: () async {
//                 EasyLoading.show();
//                 wayPoints.clear();
//                 var location = await Geolocator.getCurrentPosition();

//                 wayPoints.add(WayPoint(
//                     name: 'destination',
//                     latitude: location.latitude,
//                     longitude: location.longitude));
//                 if (data.lat != null) {
//                   wayPoints.add(WayPoint(
//                       name: '', latitude: data.lat, longitude: data.lng));
//                 }
//                 _controller?.buildRoute(wayPoints: wayPoints);
//                 if (!mounted) return;
//                 Navigator.pop(context);
//               },
//               buildAndStartRoute: () async {
//                 EasyLoading.show();
//                 wayPoints.clear();
//                 var location = await Geolocator.getCurrentPosition();
//                 wayPoints.add(WayPoint(
//                     name: 'destination',
//                     latitude: location.latitude,
//                     longitude: location.longitude));
//                 if (data.lat != null) {
//                   wayPoints.add(WayPoint(
//                       name: '', latitude: data.lat, longitude: data.lng));
//                 }
//                 _controller?.buildAndStartNavigation(
//                     wayPoints: wayPoints,
//                     profile: DrivingProfile.drivingTraffic);
//                 setState(() {
//                   _isRunning = true;
//                 });
//                 if (!mounted) return;
//                 Navigator.pop(context);
//               },
//             ));
//   }

//   @override
//   void dispose() {
//     _controller?.onDispose();
//     super.dispose();
//   }
// }
