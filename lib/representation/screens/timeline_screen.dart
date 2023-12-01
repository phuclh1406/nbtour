import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nbtour/main.dart';
import 'package:nbtour/representation/screens/driver/navigation.dart';
import 'package:nbtour/representation/widgets/button_widget/rectangle_button_widget.dart';
import 'package:nbtour/representation/widgets/timeline_widget.dart';
import 'package:nbtour/services/api/tour_service.dart';

import 'package:nbtour/services/api/tracking_service.dart';

import 'package:nbtour/services/models/tracking_station_model.dart';
import 'package:nbtour/utils/constant/colors.dart';
import 'package:nbtour/utils/constant/dimension.dart';
import 'package:nbtour/utils/constant/text_style.dart';

import 'package:nbtour/services/models/tour_model.dart';
import 'package:nbtour/utils/helper/asset_helper.dart';
import 'package:nbtour/utils/helper/image_helper.dart';
import 'package:vietmap_flutter_navigation/models/way_point.dart';

class TimelinesScreen extends StatefulWidget {
  const TimelinesScreen(
      {super.key, required this.tour, required this.wayPoints});
  final Tour tour;
  final List<WayPoint> wayPoints;
  @override
  State<TimelinesScreen> createState() => _TimelinesScreenState();
}

Tour? rescheduleTour;

class _TimelinesScreenState extends State<TimelinesScreen> {
  StreamSubscription? streamSubscription;
  // List<TrackingStations>? trackingList;
  Stream<List<TrackingStations>?>? trackingStream;
  String roleName = sharedPreferences.getString('role_name')!;
  Timer? timer;
  // Future<Tracking?> loadStations() async {
  //   try {
  //     Tracking? tracking = await TrackingServices.getTrackingStationsByTourId(
  //         widget.tour.tourId!);
  //     if (tracking != null) {
  //       return tracking;
  //     } else {
  //       // Return an empty list when there are no scheduled tours.
  //       return null;
  //     }
  //   } catch (e) {
  //     return null;
  //   }
  // }

  late Future<List<Tour>?> _toursFuture;
  @override
  void initState() {
    super.initState();
    trackingStream = Stream.periodic(const Duration(seconds: 5), (_) {
      return fetchTrackingStation();
    }).asyncMap((_) => fetchTrackingStation());

    rescheduleTour = null;
  }

  @override
  void dispose() {
    // Dispose of the timer when the widget is disposed
    timer?.cancel();
    super.dispose();
  }

  Future<List<TrackingStations>?> fetchTrackingStation() async {
    try {
      final updatedTrackingList =
          await TrackingServices.getTrackingStationsByTourId(
              widget.tour.tourId!);
      return updatedTrackingList;
    } catch (e) {
      // Handle error as needed
      return null;
    }
  }

  bool isRightTime() {
    DateTime departureDate =
        DateTime.parse(widget.tour.departureDate!.replaceAll('Z', '000'));
    DateTime endDate =
        DateTime.parse(widget.tour.endDate!.replaceAll('Z', '000'));
    DateTime now = DateTime.now();

    print('Departure Date: $departureDate');
    print('Current Date: ${now}');

    if (now.isAfter(departureDate) && now.isBefore(endDate)) {
      print('After departure date: true');
      return true;
    } else {
      print('Before departure date: false');
      return false;
    }
  }

  void showAlertFail(String response) {
    AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.error,
      title: 'Khởi hành thất bại',
      desc: response,
      btnOkOnPress: () {},
      btnOkText: 'Thực hiện lại',
    ).show();
  }

  void showSuccessDialog() {
    AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.error,
      title: 'Hoàn thành',
      desc: 'Chuyến đi đã hoàn thành',
      btnOkOnPress: () {},
      btnOkText: 'Thực hiện lại',
    ).show();
  }

  void showConfirmDialog(String tourId, String tourName) {
    AwesomeDialog(
            context: context,
            animType: AnimType.scale,
            dialogType: DialogType.question,
            title: 'Xác nhận khởi hành',
            desc:
                'Sau khi bấm xác nhận, bạn không thể hoàn thành chuyến đi cho tới khi cập bến tất cả các trạm!',
            btnOkOnPress: () {
              _onStartTour(tourId, tourName);
            },
            btnOkText: 'Xác nhận',
            btnCancelText: 'Quay lại',
            btnCancelOnPress: () {})
        .show();
  }

  void _onStartTour(String tourId, String tourName) async {
    try {
      String response =
          await TourService.updateTourStatus(tourId, "Started", tourName);
      if (response == "Update success") {
        sharedPreferences.remove("tracking_tour_id");
        sharedPreferences.setString("tracking_tour_id", tourId);
      } else {
        showAlertFail('Không thể bắt đầu');
      }
    } catch (e) {
      showAlertFail(e.toString());
    }
  }

  void _onFinishTour(String tourId, String tourName) async {
    try {
      List<TrackingStations>? trackingList =
          await TrackingServices.getTrackingStationsByTourId(tourId);
      if (trackingList != []) {
        for (var tracking in trackingList!) {
          print(tracking.status);
          if (tracking.status == "Arrived") {
            String response = await TourService.updateTourStatus(
                tourId, "Finished", tourName);
            if (response == "Update success") {
              sharedPreferences.remove("tracking_tour_id");
            } else {
              showSuccessDialog();
            }
          } else {
            showAlertFail(
                'Chỉ có thể hoàn thành chuyến đi khi qua tất cả các trạm');
          }
        }
      } else {
        showAlertFail('Không thể hoàn thành tour');
      }
    } catch (e) {
      showAlertFail(e.toString());
    }
  }

  Widget trackingStation() {
    try {
      bool isTime = isRightTime();
      print(isTime);
      return StreamBuilder<List<TrackingStations>?>(
          stream: trackingStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                color: ColorPalette.primaryColor,
              ));
            } else if (snapshot.hasError) {
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
              final trackingList = snapshot.data;

              return SafeArea(
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: kMediumPadding, right: kMediumPadding),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.tour.tourName!,
                                style: TextStyles.regularStyle.bold),
                            const SizedBox(height: kDefaultIconSize),
                            Text(widget.tour.tourRoute!.routeName!,
                                style: TextStyles.regularStyle.bold),
                            const SizedBox(height: kDefaultIconSize),
                            Text('${widget.tour.tourRoute!.distance!}m',
                                style: TextStyles.regularStyle.bold),
                            trackingList!.isNotEmpty
                                ? trackingList[0].tourDetail!.tourStatus ==
                                        "Started"
                                    ? Center(
                                        child: Lottie.asset(
                                            'assets/animations/running.json'),
                                      )
                                    : const SizedBox.shrink()
                                : const Text('No tracking found'),
                            const SizedBox(height: kDefaultIconSize),
                            Text('Current',
                                style: TextStyles.regularStyle.bold),
                            for (var i = 0; i < trackingList.length; i++)
                              TimelinesWidget(
                                  isFirst: i == 0 ? true : false,
                                  isLast: i == trackingList.length - 1
                                      ? true
                                      : false,
                                  isPast: trackingList[i].status == "Arrived"
                                      ? true
                                      : false,
                                  stationDescription: trackingList[i]
                                      .tourDetailStation!
                                      .address!,
                                  stationName: trackingList[i]
                                      .tourDetailStation!
                                      .stationName!),
                            const SizedBox(height: kMediumPadding * 2),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        width: MediaQuery.of(context).size.width -
                            kDefaultIconSize,
                        color: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            vertical: kMediumPadding / 2),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: kMediumPadding / 2,
                            ),
                            roleName == 'Driver'
                                ? RectangleButtonWidget(
                                    width:
                                        MediaQuery.of(context).size.width / 2 -
                                            kMediumPadding / 1.7,
                                    title: trackingList[0]
                                                .tourDetail!
                                                .tourStatus !=
                                            "Started"
                                        ? "Bắt đầu"
                                        : "Hoàn thành",
                                    ontap: () {
                                      if (isTime) {
                                        if (trackingList[0]
                                                    .tourDetail!
                                                    .tourStatus ==
                                                'Available' ||
                                            trackingList[0]
                                                    .tourDetail!
                                                    .tourStatus ==
                                                'Started') {
                                          trackingList[0]
                                                      .tourDetail!
                                                      .tourStatus ==
                                                  'Available'
                                              ? showConfirmDialog(
                                                  widget.tour.tourId!,
                                                  widget.tour.tourName!)
                                              : _onFinishTour(
                                                  widget.tour.tourId!,
                                                  widget.tour.tourName!);
                                        }
                                        if (trackingList[0]
                                                .tourDetail!
                                                .tourStatus ==
                                            'Finished') {
                                          showAlertFail(
                                              'Chuyến đi này đã hoàn thành');
                                        }
                                      } else {
                                        showAlertFail(
                                            'Không thể bắt đầu khi chưa tới giờ khởi hành');
                                      }
                                    },
                                    buttonColor: (trackingList[0]
                                                        .tourDetail!
                                                        .tourStatus ==
                                                    'Available' ||
                                                trackingList[0]
                                                        .tourDetail!
                                                        .tourStatus ==
                                                    'Started') &&
                                            isTime
                                        ? ColorPalette.primaryColor
                                        : ColorPalette.subTitleColor,
                                    textStyle:
                                        TextStyles.defaultStyle.whiteTextColor,
                                    isIcon: true,
                                    borderColor: (trackingList[0]
                                                        .tourDetail!
                                                        .tourStatus ==
                                                    'Available' ||
                                                trackingList[0]
                                                        .tourDetail!
                                                        .tourStatus ==
                                                    'Started') &&
                                            isTime
                                        ? ColorPalette.primaryColor
                                        : ColorPalette.subTitleColor,
                                    icon: trackingList[0]
                                                .tourDetail!
                                                .tourStatus !=
                                            "Started"
                                        ? const Icon(
                                            Icons.play_arrow_rounded,
                                            color: Colors.white,
                                            size: kDefaultIconSize + 3,
                                          )
                                        : const Icon(
                                            Icons.stop,
                                            color: Colors.white,
                                            size: kDefaultIconSize + 3,
                                          ),
                                  )
                                : RectangleButtonWidget(
                                    width:
                                        MediaQuery.of(context).size.width / 2 -
                                            kMediumPadding / 1.7,
                                    title: trackingList[0]
                                                .tourDetail!
                                                .tourStatus !=
                                            "Started"
                                        ? "Bắt đầu"
                                        : "Hoàn thành",
                                    ontap: () {},
                                    buttonColor: ColorPalette.subTitleColor,
                                    textStyle:
                                        TextStyles.defaultStyle.whiteTextColor,
                                    isIcon: true,
                                    borderColor: ColorPalette.subTitleColor,
                                    icon: trackingList[0]
                                                .tourDetail!
                                                .tourStatus !=
                                            "Started"
                                        ? const Icon(
                                            Icons.play_arrow_rounded,
                                            color: Colors.white,
                                            size: kDefaultIconSize + 3,
                                          )
                                        : const Icon(
                                            Icons.stop,
                                            color: Colors.white,
                                            size: kDefaultIconSize + 3,
                                          ),
                                  ),
                            const SizedBox(width: kDefaultIconSize / 4),
                            RectangleButtonWidget(
                              width: MediaQuery.of(context).size.width / 2 -
                                  kMediumPadding / 1.7,
                              title: 'Chỉ dẫn',
                              ontap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (ctx) => VietMapNavigationScreen(
                                          tourId: widget.tour.tourId!,
                                          wayPoints: widget.wayPoints,
                                        )));
                              },
                              buttonColor: Colors.white,
                              textStyle:
                                  TextStyles.defaultStyle.primaryTextColor,
                              isIcon: true,
                              borderColor: ColorPalette.primaryColor,
                              icon: const Icon(
                                Icons.directions,
                                color: ColorPalette.primaryColor,
                                size: kDefaultIconSize + 3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          });
    } catch (e) {
      return Center(
          child: Column(
        children: [
          ImageHelper.loadFromAsset(AssetHelper.error),
          const SizedBox(height: 10),
          Text(
            e.toString(),
            style: TextStyles.regularStyle,
          )
        ],
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return trackingStation();
  }
}
