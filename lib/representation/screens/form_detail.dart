// // ignore_for_file: use_build_context_synchronously

// import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:flutter/material.dart';

// import 'package:nbtour/services/models/report_model.dart';
// import 'package:nbtour/services/models/reschedule_form_model.dart';

// import 'package:nbtour/services/models/tracking_station_model.dart';

// import 'package:nbtour/utils/constant/dimension.dart';
// import 'package:nbtour/utils/constant/text_style.dart';

// class RescheduleFormDetailScreen extends StatefulWidget {
//   const RescheduleFormDetailScreen({super.key, required this.form});
//   final RescheduleForm form;
//   @override
//   State<RescheduleFormDetailScreen> createState() =>
//       _RescheduleFormDetailScreenState();
// }

// List<TrackingStations>? futureList;
// List<TrackingStations> stationList = [];
// TrackingStations? selectedStation;
// String? bookingId;

// class _RescheduleFormDetailScreenState
//     extends State<RescheduleFormDetailScreen> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(248, 255, 255, 255),
//       body: SizedBox(
//         height: height,
//         child: SingleChildScrollView(
//           physics: const NeverScrollableScrollPhysics(),
//           child:
//               Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             Padding(
//               padding: const EdgeInsets.only(
//                   left: kMediumPadding, right: kMediumPadding),
//               child: SizedBox(
//                 height: MediaQuery.of(context).size.height * 0.7,
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Chi tiết',
//                           style: TextStyles.defaultStyle.subTitleTextColor),
//                       const SizedBox(height: kDefaultIconSize / 2),
//                       Text(widget.form.currentTour!.tourName!,
//                           style: TextStyles.regularStyle.bold),
//                       const SizedBox(height: kMediumPadding),
//                       Text('Nguời đề nghị: ',
//                           style: TextStyles.defaultStyle.subTitleTextColor),
//                       const SizedBox(
//                         height: kDefaultIconSize / 2,
//                       ),
//                       Text(
//                           widget.form.formUser != null
//                               ? widget.form.formUser!.name!
//                               : "",
//                           style: TextStyles.defaultStyle),
//                       const SizedBox(
//                         height: kDefaultIconSize / 2,
//                       ),
//                       Text(
//                           widget.form.formUser != null
//                               ? widget.form.formUser!.email!
//                               : "",
//                           style: TextStyles.defaultStyle),
//                       const SizedBox(height: kDefaultIconSize / 4),
//                       const Divider(),
//                       const SizedBox(height: kDefaultIconSize / 4),
//                       Text('Tour sẽ chuyển',
//                           style: TextStyles.defaultStyle.subTitleTextColor),
//                       const SizedBox(height: kDefaultIconSize / 2),
//                       Text(widget.form.desireTour!.tourName!,
//                           style: TextStyles.regularStyle.bold),
//                       const SizedBox(height: kMediumPadding),
//                       Text('Nguời chuyển: ',
//                           style: TextStyles.defaultStyle.subTitleTextColor),
//                       const SizedBox(
//                         height: kDefaultIconSize / 2,
//                       ),
//                       Text(
//                           widget.form.changeEmployee != null
//                               ? widget.form.changeEmployee!.
//                               : "",
//                           style: TextStyles.defaultStyle),
//                       const SizedBox(
//                         height: kDefaultIconSize / 2,
//                       ),
//                       Text(
//                           widget.form.formUser != null
//                               ? widget.form.formUser!.email!
//                               : "",
//                           style: TextStyles.defaultStyle),
//                           style: TextStyles.defaultStyle),
//                       const SizedBox(height: kDefaultIconSize / 4),
//                       const Divider(),
//                       const SizedBox(height: kDefaultIconSize / 4),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Text('Trạng thái đơn ',
//                               style: TextStyles.defaultStyle.subTitleTextColor),
//                           const Spacer(),
//                           if (widget.report.reportStatus == "Pending")
//                             Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Container(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: kDefaultPadding,
//                                         vertical: kDefaultPadding / 2),
//                                     decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(5),
//                                         color: const Color.fromARGB(
//                                             22, 158, 158, 158)),
//                                     child: Text(
//                                       widget.report.reportStatus!,
//                                       style: const TextStyle(
//                                           fontSize: 12,
//                                           fontWeight: FontWeight.w700),
//                                     )),
//                               ],
//                             ),
//                           if (widget.report.reportStatus == "Approved")
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: kDefaultPadding,
//                                   vertical: kDefaultPadding / 2),
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(5),
//                                   color: const Color.fromARGB(24, 76, 175, 79)),
//                               child: Text(
//                                 widget.report.reportStatus!,
//                                 style: const TextStyle(
//                                     color: Colors.green,
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w700),
//                               ),
//                             ),
//                           if (widget.report.reportStatus == "Rejected")
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: kDefaultPadding,
//                                   vertical: kDefaultPadding / 2),
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(5),
//                                   color: const Color.fromARGB(24, 244, 67, 54)),
//                               child: Text(
//                                 widget.report.reportStatus!,
//                                 style: const TextStyle(
//                                     color: Colors.red,
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w700),
//                               ),
//                             ),
//                           if (widget.report.reportStatus != "Pending" &&
//                               widget.report.reportStatus != "Approved" &&
//                               widget.report.reportStatus != "Rejected")
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: kDefaultPadding,
//                                   vertical: kDefaultPadding / 2),
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(5),
//                                   color:
//                                       const Color.fromARGB(19, 255, 235, 59)),
//                               child: const Text(
//                                 "Not defined",
//                                 style: TextStyle(
//                                     color: Colors.yellow,
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w700),
//                               ),
//                             ),
//                         ],
//                       ),
//                       const SizedBox(height: kDefaultIconSize / 2),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: kMediumPadding / 2),
//           ]),
//         ),
//       ),
//     );
//   }
// }
