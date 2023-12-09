// import 'package:flutter/material.dart';
// import 'package:nbtour/utils/constant/colors.dart';
// import 'package:nbtour/utils/helper/asset_helper.dart';
// import 'package:nbtour/utils/helper/image_helper.dart';
// import 'package:nbtour/main.dart';
// import 'package:nbtour/representation/screens/driver/navigation.dart';
// import 'package:vietmap_flutter_navigation/models/way_point.dart';

// Widget reviewRideBottomSheet(BuildContext context, String distance,
//     String routeName, List<WayPoint> wayPoints, String tourId) {
//   // Get source and destination addresses from sharedPreferences
//   // String sourceAddress = getSourceAndDestinationPlaceText('source');
//   // String destAddress = getSourceAndDestinationPlaceText('destination');
//   String roleName = sharedPreferences.getString("role_name")!;
//   return Positioned(
//     bottom: 0,
//     child: SizedBox(
//       width: MediaQuery.of(context).size.width,
//       child: Card(
//         clipBehavior: Clip.antiAlias,
//         child: Padding(
//           padding: const EdgeInsets.all(15),
//           child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(routeName,
//                     style: Theme.of(context)
//                         .textTheme
//                         .titleMedium
//                         ?.copyWith(color: Colors.black)),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 10),
//                   child: ListTile(
//                     tileColor: const Color.fromARGB(32, 255, 89, 0),
//                     leading: ImageHelper.loadFromAsset(AssetHelper.busIcon),
//                     title: const Text('Tour length',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         )),
//                     trailing: Text('$distance m',
//                         style: const TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: 18)),
//                   ),
//                 ),
//                 roleName == "Driver"
//                     ? ElevatedButton(
//                         onPressed: () => Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (_) => VietMapNavigationScreen(
//                                     wayPoints: wayPoints, tourId: tourId))),
//                         style: ElevatedButton.styleFrom(
//                             padding: const EdgeInsets.all(20),
//                             backgroundColor: ColorPalette.primaryColor),
//                         child: const Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text('Get direction',
//                                   style: TextStyle(color: Colors.white)),
//                             ]))
//                     : const SizedBox.shrink(),
//               ]),
//         ),
//       ),
//     ),
//   );
// }
