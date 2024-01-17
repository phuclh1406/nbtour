import 'package:flutter/material.dart';
import 'package:nbtour/services/models/reschedule_form_model.dart';
import 'package:nbtour/services/models/tour_model.dart';
import 'package:nbtour/services/models/tour_schedule_model.dart';
import 'package:nbtour/services/models/tracking_station_model.dart';

import 'package:nbtour/utils/constant/dimension.dart';
import 'package:nbtour/utils/constant/text_style.dart';

class RescheduleDetailScreen extends StatefulWidget {
  const RescheduleDetailScreen(
      {super.key,
      required this.currentSchedule,
      required this.desireSchedule,
      required this.rescheduleForm});
  final TourSchedule? currentSchedule;
  final TourSchedule? desireSchedule;
  final RescheduleForm? rescheduleForm;
  @override
  State<RescheduleDetailScreen> createState() => _RescheduleDetailScreenState();
}

List<TrackingStations>? futureList;
List<TrackingStations> stationList = [];
TrackingStations? selectedStation;
String? bookingId;

class _RescheduleDetailScreenState extends State<RescheduleDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color.fromARGB(248, 255, 255, 255),
      body: SizedBox(
        height: height,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: kMediumPadding, right: kMediumPadding),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: SingleChildScrollView(
                    child: Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Chuyến mới: ', style: TextStyles.regularStyle.bold),
                      const SizedBox(height: kDefaultIconSize / 2),
                      Text(
                        widget.currentSchedule!.scheduleTour!.tourName != null
                            ? widget.currentSchedule!.scheduleTour!.tourName!
                            : "",
                        style: TextStyles.regularStyle,
                        maxLines: 3,
                      ),
                      const SizedBox(height: kDefaultIconSize / 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('Khởi hành: ',
                                  style: TextStyles
                                      .defaultStyle.subTitleTextColor),
                              Text(
                                  widget.currentSchedule!.departureDate != null
                                      ? widget.currentSchedule!.departureDate!
                                          .substring(11, 19)
                                      : "",
                                  style: TextStyles.defaultStyle),
                            ],
                          ),
                          const SizedBox(width: kDefaultIconSize / 2),
                          const Text(' - ', style: TextStyles.defaultStyle),
                          const SizedBox(width: kDefaultIconSize / 2),
                          Row(
                            children: [
                              Text('Kết thúc: ',
                                  style: TextStyles
                                      .defaultStyle.subTitleTextColor),
                              Text(
                                  widget.currentSchedule!.departureDate != null
                                      ? widget.currentSchedule!.departureDate!
                                          .substring(11, 19)
                                      : "",
                                  style: TextStyles.defaultStyle),
                            ],
                          ),
                        ],
                      ),
                      // const SizedBox(height: kDefaultIconSize / 2),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   children: [
                      //     Text('Tuyến: ',
                      //         style: TextStyles.defaultStyle.subTitleTextColor),
                      //     Text(
                      //         widget.currentTour?.tourSchedule![0].departureDate != null
                      //             ? widget.currentTour!.tourSchedule![0].departureDate!.routeName!
                      //             : "",
                      //         style: TextStyles.defaultStyle),
                      //   ],
                      // ),
                      const SizedBox(height: kDefaultIconSize / 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Biển số xe: ',
                              style: TextStyles.defaultStyle.subTitleTextColor),
                          Text(
                              widget.currentSchedule!.scheduleBus!.busPlate !=
                                      null
                                  ? widget
                                      .currentSchedule!.scheduleBus!.busPlate!
                                  : "",
                              style: TextStyles.defaultStyle),
                        ],
                      ),
                      const SizedBox(height: kDefaultIconSize / 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Ngày khởi hành: ',
                              style: TextStyles.defaultStyle.subTitleTextColor),
                          Text(
                              widget.currentSchedule!.departureDate != null
                                  ? widget.currentSchedule!.departureDate!
                                      .substring(0, 10)
                                  : "",
                              style: TextStyles.defaultStyle),
                        ],
                      ),
                      const SizedBox(height: kDefaultIconSize / 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Hướng dẫn viên: ',
                              style: TextStyles.defaultStyle.subTitleTextColor),
                          Text(
                              widget.currentSchedule!.tourGuide != null
                                  ? widget.currentSchedule!.tourGuide!.name!
                                  : "",
                              style: TextStyles.defaultStyle),
                        ],
                      ),
                      const SizedBox(height: kDefaultIconSize / 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Email: ',
                              style: TextStyles.defaultStyle.subTitleTextColor),
                          Text(
                              widget.currentSchedule!.tourGuide != null
                                  ? widget.currentSchedule!.tourGuide!.email!
                                  : "",
                              style: TextStyles.defaultStyle),
                        ],
                      ),
                      const SizedBox(height: kDefaultIconSize / 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Tài xế: ',
                              style: TextStyles.defaultStyle.subTitleTextColor),
                          Text(
                              widget.currentSchedule?.driver != null
                                  ? widget.currentSchedule!.driver!.name!
                                  : "",
                              style: TextStyles.defaultStyle),
                        ],
                      ),
                      const SizedBox(height: kDefaultIconSize / 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Email: ',
                              style: TextStyles.defaultStyle.subTitleTextColor),
                          Text(
                              widget.currentSchedule?.driver != null
                                  ? widget.currentSchedule!.driver!.email!
                                  : "",
                              style: TextStyles.defaultStyle),
                        ],
                      ),
                      const SizedBox(height: kDefaultIconSize / 4),
                      const Divider(),
                      const SizedBox(height: kDefaultIconSize / 4),
                      Text('Chuyến cũ: ', style: TextStyles.regularStyle.bold),
                      const SizedBox(height: kDefaultIconSize / 2),
                      Text(
                        widget.desireSchedule!.scheduleTour!.tourName != null
                            ? widget.desireSchedule!.scheduleTour!.tourName!
                            : "",
                        style: TextStyles.regularStyle,
                        maxLines: 3,
                      ),
                      const SizedBox(height: kDefaultIconSize / 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('Khởi hành: ',
                                  style: TextStyles
                                      .defaultStyle.subTitleTextColor),
                              Text(
                                  widget.desireSchedule!.departureDate != null
                                      ? widget.desireSchedule!.departureDate!
                                          .substring(11, 19)
                                      : "",
                                  style: TextStyles.defaultStyle),
                            ],
                          ),
                          const SizedBox(width: kDefaultIconSize / 2),
                          const Text(' - ', style: TextStyles.defaultStyle),
                          const SizedBox(width: kDefaultIconSize / 2),
                          Row(
                            children: [
                              Text('Kết thúc: ',
                                  style: TextStyles
                                      .defaultStyle.subTitleTextColor),
                              Text(
                                  widget.desireSchedule!.endDate != null
                                      ? widget.desireSchedule!.endDate!
                                          .substring(11, 19)
                                      : "",
                                  style: TextStyles.defaultStyle),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: kDefaultIconSize / 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Biển số xe: ',
                              style: TextStyles.defaultStyle.subTitleTextColor),
                          Text(
                              widget.desireSchedule!.scheduleBus != null
                                  ? widget
                                      .desireSchedule!.scheduleBus!.busPlate!
                                  : "",
                              style: TextStyles.defaultStyle),
                        ],
                      ),
                      const SizedBox(height: kDefaultIconSize / 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Ngày khởi hành: ',
                              style: TextStyles.defaultStyle.subTitleTextColor),
                          Text(
                              widget.desireSchedule?.departureDate != null
                                  ? widget.desireSchedule!.departureDate!
                                      .substring(0, 10)
                                  : "",
                              style: TextStyles.defaultStyle),
                        ],
                      ),
                      const SizedBox(height: kDefaultIconSize / 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Hướng dẫn viên: ',
                              style: TextStyles.defaultStyle.subTitleTextColor),
                          Text(
                              widget.desireSchedule?.tourGuide != null
                                  ? widget.desireSchedule!.tourGuide!.name!
                                  : "",
                              style: TextStyles.defaultStyle),
                        ],
                      ),
                      const SizedBox(height: kDefaultIconSize / 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Email: ',
                              style: TextStyles.defaultStyle.subTitleTextColor),
                          Text(
                              widget.desireSchedule?.tourGuide != null
                                  ? widget.desireSchedule!.tourGuide!.email!
                                  : "",
                              style: TextStyles.defaultStyle),
                        ],
                      ),
                      const SizedBox(height: kDefaultIconSize / 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Tài xế: ',
                              style: TextStyles.defaultStyle.subTitleTextColor),
                          Text(
                              widget.desireSchedule?.driver != null
                                  ? widget.desireSchedule!.driver!.name!
                                  : "",
                              style: TextStyles.defaultStyle),
                        ],
                      ),
                      const SizedBox(height: kDefaultIconSize / 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Email: ',
                              style: TextStyles.defaultStyle.subTitleTextColor),
                          Text(
                              widget.desireSchedule?.driver != null
                                  ? widget.desireSchedule!.driver!.email!
                                  : "",
                              style: TextStyles.defaultStyle),
                        ],
                      ),
                      const SizedBox(height: kDefaultIconSize / 4),
                      const Divider(),
                      const SizedBox(height: kDefaultIconSize / 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Trạng thái đơn ',
                              style: TextStyles.defaultStyle.subTitleTextColor),
                          const Spacer(),
                          if (widget.rescheduleForm!.status == "Pending")
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: kDefaultPadding,
                                        vertical: kDefaultPadding / 2),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: const Color.fromARGB(
                                            22, 158, 158, 158)),
                                    child: Text(
                                      widget.rescheduleForm!.status ?? '',
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700),
                                    )),
                              ],
                            ),
                          if (widget.rescheduleForm!.status == "Approved")
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: kDefaultPadding,
                                  vertical: kDefaultPadding / 2),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: const Color.fromARGB(24, 76, 175, 79)),
                              child: Text(
                                widget.rescheduleForm!.status!,
                                style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          if (widget.rescheduleForm!.status == "Rejected")
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: kDefaultPadding,
                                  vertical: kDefaultPadding / 2),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: const Color.fromARGB(24, 244, 67, 54)),
                              child: Text(
                                widget.rescheduleForm!.status ?? '',
                                style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          if (widget.rescheduleForm!.status != "Pending" &&
                              widget.rescheduleForm!.status != "Approved" &&
                              widget.rescheduleForm!.status != "Rejected")
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: kDefaultPadding,
                                  vertical: kDefaultPadding / 2),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color:
                                      const Color.fromARGB(19, 255, 235, 59)),
                              child: const Text(
                                "Not defined",
                                style: TextStyle(
                                    color: Colors.yellow,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                )),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
