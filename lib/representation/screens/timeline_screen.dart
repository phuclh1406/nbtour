import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  void _onStartTour(String tourId, String tourName) async {
    String response =
        await TourService.updateTourStatus(tourId, "Started", tourName);
    if (response == "Update success") {
      sharedPreferences.remove("tracking_tour_id");
      sharedPreferences.setString("tracking_tour_id", tourId);

      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Tour is started')));
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response)));
      }
    }
  }

  void _onFinishTour(String tourId, String tourName) async {
    List<TrackingStations>? trackingList =
        await TrackingServices.getTrackingStationsByTourId(tourId);
    if (trackingList != []) {
      for (var tracking in trackingList!) {
        print(tracking.status);
        if (tracking.status == "Arrived") {
          String response =
              await TourService.updateTourStatus(tourId, "Finished", tourName);
          if (response == "Update success") {
            sharedPreferences.remove("tracking_tour_id");

            if (context.mounted) {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tour is finished')));
            }
          } else {
            if (context.mounted) {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(response)));
            }
          }
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Required arrived all stations')));
          }
        }
      }
    } else {
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("error")));
      }
    }
  }

  Widget trackingStation() {
    return StreamBuilder<List<TrackingStations>?>(
        stream: trackingStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: ColorPalette.primaryColor,
            ));
          } else if (snapshot.hasError) {
            return Text('Error loading data: ${snapshot.error}');
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
                          Text('Current', style: TextStyles.regularStyle.bold),
                          for (var i = 0; i < trackingList.length; i++)
                            TimelinesWidget(
                                isFirst: i == 0 ? true : false,
                                isLast:
                                    i == trackingList.length - 1 ? true : false,
                                isPast: trackingList[i].status == "Arrived"
                                    ? true
                                    : false,
                                stationDescription:
                                    trackingList[i].tourDetailStation!.address!,
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
                      width:
                          MediaQuery.of(context).size.width - kDefaultIconSize,
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: kMediumPadding / 2),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: kMediumPadding / 2,
                          ),
                          RectangleButtonWidget(
                            width: MediaQuery.of(context).size.width / 2 -
                                kMediumPadding / 1.7,
                            title: trackingList[0].tourDetail!.tourStatus !=
                                    "Started"
                                ? "Start tour"
                                : "End tour",
                            ontap: () {
                              trackingList[0].tourDetail!.tourStatus !=
                                      "Started"
                                  ? _onStartTour(widget.tour.tourId!,
                                      widget.tour.tourName!)
                                  : _onFinishTour(widget.tour.tourId!,
                                      widget.tour.tourName!);
                            },
                            buttonColor: ColorPalette.primaryColor,
                            textStyle: TextStyles.defaultStyle.whiteTextColor,
                            isIcon: true,
                            borderColor: ColorPalette.primaryColor,
                            icon: trackingList[0].tourDetail!.tourStatus !=
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
                            title: 'View direction',
                            ontap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (ctx) => VietMapNavigationScreen(
                                        tourId: widget.tour.tourId!,
                                        wayPoints: widget.wayPoints,
                                      )));
                            },
                            buttonColor: Colors.white,
                            textStyle: TextStyles.defaultStyle.primaryTextColor,
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
  }

  @override
  Widget build(BuildContext context) {
    return trackingStation();
  }
}
