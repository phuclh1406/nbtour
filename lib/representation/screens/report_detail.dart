// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:intl/intl.dart';
// import 'package:lottie/lottie.dart';
// import 'package:nbtour/representation/screens/schedule_screen.dart';
// import 'package:nbtour/services/api/report_service.dart';
// import 'package:nbtour/services/api/tour_service.dart';
// import 'package:nbtour/services/models/report_model.dart';

// import 'package:nbtour/utils/constant/colors.dart';
// import 'package:nbtour/utils/constant/dimension.dart';
// import 'package:nbtour/utils/constant/text_style.dart';

// import 'package:nbtour/services/models/tour_model.dart';
// import 'package:nbtour/representation/screens/review_ride.dart';

// import 'package:nbtour/representation/screens/tab_screen.dart';

// import 'package:nbtour/representation/widgets/button_widget/rectangle_button_widget.dart';

// String userId = '';
// String tourId = '';

// class ReportDetail extends StatelessWidget {
//   const ReportDetail({super.key, required this.report});
//   final Reports report;

//   // final String tourId;
//   @override
//   Widget build(BuildContext context) {
//     // scheduleTour.scheduleTour!.tourRoute!.routeId!;
//     final size = MediaQuery.of(context).size;
//     Widget loadTour() {
//       return FutureBuilder<Reports?>(
//         future: ReportServices.getReportByReportId(report.reportId!),
//         builder: (BuildContext context, AsyncSnapshot<Reports?> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//                 child: Padding(
//               padding: const EdgeInsets.only(bottom: kMediumPadding * 6),
//               child: Lottie.asset('assets/animations/loading.json'),
//             ));
//           } else if (snapshot.hasData) {
//             Reports? report = snapshot.data!;

//             print(report);
//             if (report != null) {
//               return Stack(
//                 children: [
//                   SizedBox(
//                     width: size.width,
//                     height: size.height,
//                     child: SingleChildScrollView(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(
//                                 left: kMediumPadding / 2,
//                                 right: kMediumPadding / 2,
//                                 bottom: kMediumPadding * 2),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(report.title!,
//                                     style: const TextStyle(fontSize: 25)),
//                                 const Divider(),
//                                 const SizedBox(
//                                   height: kMediumPadding / 2,
//                                 ),
//                                 SingleChildScrollView(
//                                   scrollDirection: Axis.horizontal,
//                                   child: Row(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Container(
//                                         padding: const EdgeInsets.all(17),
//                                         decoration: BoxDecoration(
//                                             color: const Color.fromARGB(
//                                                 47, 255, 89, 0),
//                                             borderRadius:
//                                                 BorderRadius.circular(30)),
//                                         child: const Icon(
//                                           FontAwesomeIcons.calendarDays,
//                                           color: ColorPalette.primaryColor,
//                                         ),
//                                       ),
//                                       const SizedBox(
//                                         width: kMediumPadding,
//                                       ),
//                                       Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           if (report.createdAt != null)
//                                             Text(
//                                                 DateFormat.yMMMd().format(
//                                                     DateTime.parse(
//                                                         report.createdAt!)),
//                                                 style: TextStyles
//                                                     .regularStyle.bold),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                   height: kMediumPadding,
//                                 ),
//                                 SingleChildScrollView(
//                                   scrollDirection: Axis.horizontal,
//                                   child: Row(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       const Text('Responser: '),
//                                       const SizedBox(
//                                         width: kMediumPadding,
//                                       ),
//                                       Text(
//                                         report.responseUser != null
//                                             ? report.reportUser!.name!
//                                             : "",
//                                         style: const TextStyle(
//                                             fontSize: 15,
//                                             fontWeight: FontWeight.w700),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                   height: kMediumPadding,
//                                 ),
//                                 SingleChildScrollView(
//                                   scrollDirection: Axis.horizontal,
//                                   child: Row(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       ClipRRect(
//                                         borderRadius: BorderRadius.circular(30),
//                                         child: scheduleTour.driver != null
//                                             ? Image.network(
//                                                 scheduleTour.driver!.avatar!,
//                                                 width: 55,
//                                                 fit: BoxFit.fitWidth)
//                                             : const SizedBox.shrink(),
//                                       ),
//                                       const SizedBox(
//                                         width: kMediumPadding,
//                                       ),
//                                       Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           if (scheduleTour.driver != null)
//                                             scheduleTour.driver!.name != null
//                                                 ? Text(
//                                                     scheduleTour.driver!.name!,
//                                                     style: TextStyles
//                                                         .regularStyle.bold)
//                                                 : Text('Not assigned',
//                                                     style: TextStyles
//                                                         .regularStyle.bold),
//                                           const SizedBox(
//                                             height: kDefaultIconSize / 4,
//                                           ),
//                                           if (scheduleTour.driver != null)
//                                             scheduleTour.driver!.email != null
//                                                 ? Text(
//                                                     scheduleTour.driver!.email!,
//                                                     style:
//                                                         TextStyles.defaultStyle)
//                                                 : Text('',
//                                                     style: TextStyles
//                                                         .defaultStyle.bold),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                   height: kMediumPadding,
//                                 ),
//                                 Row(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     ClipRRect(
//                                       borderRadius: BorderRadius.circular(30),
//                                       child: Image.network(
//                                           scheduleTour.tourGuide!.avatar!,
//                                           width: 55,
//                                           fit: BoxFit.fitWidth),
//                                     ),
//                                     const SizedBox(
//                                       width: kMediumPadding,
//                                     ),
//                                     Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         if (scheduleTour.tourGuide != null)
//                                           scheduleTour.tourGuide!.name != null
//                                               ? Text(
//                                                   scheduleTour.tourGuide!.name!,
//                                                   style: TextStyles
//                                                       .regularStyle.bold)
//                                               : Text('Not assigned',
//                                                   style: TextStyles
//                                                       .regularStyle.bold),
//                                         const SizedBox(
//                                           height: kDefaultIconSize / 4,
//                                         ),
//                                         if (scheduleTour.tourGuide != null)
//                                           scheduleTour.tourGuide!.email != null
//                                               ? Text(
//                                                   scheduleTour
//                                                       .tourGuide!.email!,
//                                                   style:
//                                                       TextStyles.defaultStyle)
//                                               : Text('',
//                                                   style: TextStyles
//                                                       .defaultStyle.bold),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(
//                                   height: kMediumPadding,
//                                 ),
//                                 Text('About Tour',
//                                     style: TextStyles.regularStyle.bold),
//                                 const SizedBox(height: kDefaultPadding / 2),
//                                 Text(tour.description!,
//                                     style: const TextStyle(
//                                       fontSize: 16,
//                                       height: 1.5,
//                                     )),
//                                 const SizedBox(height: kMediumPadding),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     bottom: 0,
//                     left: 0,
//                     right: 0,
//                     child: Container(
//                       width:
//                           MediaQuery.of(context).size.width - kDefaultIconSize,
//                       color: const Color.fromARGB(255, 251, 250, 250),
//                       padding: const EdgeInsets.symmetric(
//                           vertical: kMediumPadding / 2),
//                       child: Row(
//                         children: [
//                           const SizedBox(
//                             width: kMediumPadding / 2,
//                           ),
//                           RectangleButtonWidget(
//                             width: MediaQuery.of(context).size.width / 2 -
//                                 kMediumPadding / 1.7,
//                             title: 'View route',
//                             ontap: () {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (ctx) => ReviewRideScreen(
//                                             tour: tour,
//                                           )));
//                             },
//                             buttonColor: ColorPalette.primaryColor,
//                             textStyle: TextStyles.defaultStyle.whiteTextColor,
//                             isIcon: true,
//                             borderColor: ColorPalette.primaryColor,
//                             icon: const Icon(
//                               FontAwesomeIcons.diamondTurnRight,
//                               color: Colors.white,
//                               size: kDefaultIconSize + 3,
//                             ),
//                           ),
//                           const SizedBox(width: kDefaultIconSize / 4),
//                           RectangleButtonWidget(
//                             width: MediaQuery.of(context).size.width / 2 -
//                                 kMediumPadding / 1.7,
//                             title: 'Reschedule tour',
//                             ontap: _openAddExpenseOverlay,
//                             buttonColor: Colors.white,
//                             textStyle: TextStyles.defaultStyle.primaryTextColor,
//                             isIcon: true,
//                             borderColor: ColorPalette.primaryColor,
//                             icon: const Icon(
//                               Icons.change_circle_rounded,
//                               color: ColorPalette.primaryColor,
//                               size: kDefaultIconSize + 3,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             } else {
//               return const Text('No tour found.');
//             }
//           } else if (snapshot.hasError) {
//             // Display an error message if the future completed with an error
//             return Text('Error: ${snapshot.error}');
//           } else {
//             return const SizedBox
//                 .shrink(); // Return an empty container or widget if data is null
//           }
//         },
//       );
//     }

//     return Scaffold(
//         appBar: AppBar(
//           scrolledUnderElevation: 0,
//           backgroundColor: Colors.white,
//           title: Text(
//             'Tour Detail',
//             style: TextStyles.defaultStyle.fontHeader.bold,
//           ),
//           actions: <Widget>[
//             IconButton(
//                 onPressed: () {
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (ctx) => const TabsScreen()));
//                 },
//                 icon: const Icon(Icons.home))
//           ],
//         ),
//         body: loadTour());
//   }
// }
