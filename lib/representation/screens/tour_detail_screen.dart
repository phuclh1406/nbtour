import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:nbtour/representation/screens/schedule_screen.dart';
import 'package:nbtour/services/api/tour_service.dart';

import 'package:nbtour/utils/constant/colors.dart';
import 'package:nbtour/utils/constant/dimension.dart';
import 'package:nbtour/utils/constant/text_style.dart';
import 'package:nbtour/utils/helper/asset_helper.dart';
import 'package:nbtour/utils/helper/image_helper.dart';
import 'package:nbtour/services/models/tour_model.dart';
import 'package:nbtour/representation/screens/review_ride.dart';
import 'package:nbtour/representation/screens/reschedule_screen.dart';
import 'package:nbtour/representation/screens/tab_screen.dart';

import 'package:nbtour/representation/widgets/button_widget/rectangle_button_widget.dart';

String userId = '';
String tourId = '';

class TourDetailScreen extends StatelessWidget {
  const TourDetailScreen({super.key, required this.scheduleTour});
  final Tour scheduleTour;

  // final String tourId;
  @override
  Widget build(BuildContext context) {
    void _openAddExpenseOverlay() {
      showModalBottomSheet(
        showDragHandle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        isScrollControlled: true,
        context: context,
        builder: (ctx) => SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: RescheduleScreen(tour: scheduleTour)),
      );
    }

    // scheduleTour.scheduleTour!.tourRoute!.routeId!;
    final size = MediaQuery.of(context).size;
    Widget loadTour() {
      return FutureBuilder<Tour?>(
        future: TourService.getTourByTourId(scheduleTour.tourId!),
        builder: (BuildContext context, AsyncSnapshot<Tour?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: Padding(
              padding: const EdgeInsets.only(bottom: kMediumPadding * 6),
              child: Lottie.asset('assets/animations/loading.json'),
            ));
          } else if (snapshot.hasData) {
            Tour? tour = snapshot.data!;

            print(tour);
            if (tour != null) {
              return Stack(
                children: [
                  SizedBox(
                    width: size.width,
                    height: size.height,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (tour.tourImage != null)
                            tour.tourImage!.isNotEmpty
                                ? Image.network(
                                    tour.tourImage![0].image!,
                                    width: size.width,
                                    fit: BoxFit.fitWidth,
                                    loadingBuilder:
                                        (context, child, loadingProgress) =>
                                            (loadingProgress == null)
                                                ? child
                                                : const Text(''),
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            ImageHelper.loadFromAsset(
                                                AssetHelper.announcementImage,
                                                width: size.width,
                                                fit: BoxFit.fitWidth),
                                  )
                                : ImageHelper.loadFromAsset(
                                    AssetHelper.announcementImage,
                                    width: size.width,
                                    fit: BoxFit.fitWidth),
                          const SizedBox(
                            height: kMediumPadding / 1.5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: kMediumPadding / 2,
                                right: kMediumPadding / 2,
                                bottom: kMediumPadding * 2),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(tour.tourName!,
                                    style: const TextStyle(fontSize: 25)),
                                const Divider(),
                                const SizedBox(
                                  height: kMediumPadding / 2,
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(17),
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                47, 255, 89, 0),
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        child: const Icon(
                                          FontAwesomeIcons.calendarDays,
                                          color: ColorPalette.primaryColor,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: kMediumPadding,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (tour.departureDate != null)
                                            Text(
                                                '${DateFormat.yMMMd().format(DateTime.parse(tour.departureDate!))} - ${DateFormat.yMMMd().format(DateTime.parse(tour.endDate!))}',
                                                style: TextStyles
                                                    .regularStyle.bold),
                                          const SizedBox(
                                            height: kDefaultIconSize / 4,
                                          ),
                                          if (tour.departureDate != null)
                                            Text(
                                                '${DateFormat.Hm().format(DateTime.parse(tour.departureDate!))} - ${DateFormat.Hm().format(DateTime.parse(tour.endDate!))}',
                                                style: TextStyles.defaultStyle),
                                          const SizedBox(
                                            height: kDefaultIconSize / 4,
                                          ),
                                          RectangleButtonWidget(
                                              title: "View in calendar",
                                              ontap: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (ctx) =>
                                                            ScheduleScreen(
                                                                initDate: DateTime
                                                                    .parse(tour
                                                                        .departureDate!))));
                                              },
                                              buttonColor:
                                                  ColorPalette.primaryColor,
                                              textStyle: TextStyles.defaultStyle
                                                  .whiteTextColor.bold,
                                              isIcon: true,
                                              borderColor:
                                                  ColorPalette.primaryColor,
                                              icon: const Icon(
                                                Icons.calendar_month,
                                                color: Colors.white,
                                                size: kDefaultIconSize,
                                              ))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: kMediumPadding,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(17),
                                      decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              47, 255, 89, 0),
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: const Icon(
                                        Icons.location_pin,
                                        color: ColorPalette.primaryColor,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: kMediumPadding,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (tour.tourRoute!.routeSegment![0]
                                                  .segmentDepartureStation !=
                                              null)
                                            Text(
                                              tour
                                                  .tourRoute!
                                                  .routeSegment![0]
                                                  .segmentDepartureStation!
                                                  .stationName!,
                                              style:
                                                  TextStyles.regularStyle.bold,
                                              maxLines: 3,
                                            ),
                                          const SizedBox(
                                            height: kDefaultIconSize / 4,
                                          ),
                                          if (tour.departureStation != null)
                                            Text(
                                              tour.departureStation!
                                                  .description!,
                                              style: TextStyles.defaultStyle,
                                              overflow: TextOverflow.clip,
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: kMediumPadding,
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(17),
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                47, 255, 89, 0),
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        child: const Icon(
                                          FontAwesomeIcons.busSimple,
                                          color: ColorPalette.primaryColor,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: kMediumPadding,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (scheduleTour.tourBus != null)
                                            Text(
                                                scheduleTour.tourBus!.busPlate!,
                                                style: TextStyles
                                                    .regularStyle.bold),
                                          const SizedBox(
                                            height: kDefaultIconSize / 4,
                                          ),
                                          if (scheduleTour.tourBus != null)
                                            Text(
                                                scheduleTour.tourBus!
                                                        .isDoubleDecker!
                                                    ? 'Double Decker Bus (${scheduleTour.tourBus!.numberSeat} seats)'
                                                    : 'One Decker Bus (${scheduleTour.tourBus!.numberSeat} seats)',
                                                style: TextStyles.defaultStyle),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: kMediumPadding,
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(30),
                                        child: scheduleTour.driver != null
                                            ? Image.network(
                                                scheduleTour.driver!.avatar!,
                                                width: 55,
                                                fit: BoxFit.fitWidth)
                                            : const SizedBox.shrink(),
                                      ),
                                      const SizedBox(
                                        width: kMediumPadding,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (scheduleTour.driver != null)
                                            scheduleTour.driver!.name != null
                                                ? Text(
                                                    scheduleTour.driver!.name!,
                                                    style: TextStyles
                                                        .regularStyle.bold)
                                                : Text('Not assigned',
                                                    style: TextStyles
                                                        .regularStyle.bold),
                                          const SizedBox(
                                            height: kDefaultIconSize / 4,
                                          ),
                                          if (scheduleTour.driver != null)
                                            scheduleTour.driver!.email != null
                                                ? Text(
                                                    scheduleTour.driver!.email!,
                                                    style:
                                                        TextStyles.defaultStyle)
                                                : Text('',
                                                    style: TextStyles
                                                        .defaultStyle.bold),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: kMediumPadding,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: Image.network(
                                          scheduleTour.tourGuide!.avatar!,
                                          width: 55,
                                          fit: BoxFit.fitWidth),
                                    ),
                                    const SizedBox(
                                      width: kMediumPadding,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (scheduleTour.tourGuide != null)
                                          scheduleTour.tourGuide!.name != null
                                              ? Text(
                                                  scheduleTour.tourGuide!.name!,
                                                  style: TextStyles
                                                      .regularStyle.bold)
                                              : Text('Not assigned',
                                                  style: TextStyles
                                                      .regularStyle.bold),
                                        const SizedBox(
                                          height: kDefaultIconSize / 4,
                                        ),
                                        if (scheduleTour.tourGuide != null)
                                          scheduleTour.tourGuide!.email != null
                                              ? Text(
                                                  scheduleTour
                                                      .tourGuide!.email!,
                                                  style:
                                                      TextStyles.defaultStyle)
                                              : Text('',
                                                  style: TextStyles
                                                      .defaultStyle.bold),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: kMediumPadding,
                                ),
                                Text('About Tour',
                                    style: TextStyles.regularStyle.bold),
                                const SizedBox(height: kDefaultPadding / 2),
                                Text(tour.description!,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        height: 1.5,
                                        color: ColorPalette.subTitleColor)),
                                const SizedBox(height: kMediumPadding),
                              ],
                            ),
                          ),
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
                      color: const Color.fromARGB(255, 251, 250, 250),
                      padding: const EdgeInsets.symmetric(
                          vertical: kMediumPadding / 2),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: kMediumPadding / 2,
                          ),
                          RectangleButtonWidget(
                            title: 'View route',
                            ontap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => ReviewRideScreen(
                                            tour: tour,
                                          )));
                            },
                            buttonColor: ColorPalette.primaryColor,
                            textStyle: TextStyles.defaultStyle.whiteTextColor,
                            isIcon: true,
                            borderColor: ColorPalette.primaryColor,
                            icon: const Icon(
                              FontAwesomeIcons.diamondTurnRight,
                              color: Colors.white,
                              size: kDefaultIconSize + 3,
                            ),
                          ),
                          const SizedBox(width: kDefaultIconSize / 4),
                          RectangleButtonWidget(
                            title: 'Reschedule this tour',
                            ontap: _openAddExpenseOverlay,
                            buttonColor: Colors.white,
                            textStyle: TextStyles.defaultStyle.primaryTextColor,
                            isIcon: true,
                            borderColor: ColorPalette.primaryColor,
                            icon: const Icon(
                              Icons.change_circle_rounded,
                              color: ColorPalette.primaryColor,
                              size: kDefaultIconSize + 3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const Text('No tour found.');
            }
          } else if (snapshot.hasError) {
            // Display an error message if the future completed with an error
            return Text('Error: ${snapshot.error}');
          } else {
            return const SizedBox
                .shrink(); // Return an empty container or widget if data is null
          }
        },
      );
    }

    return Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            'Tour Detail',
            style: TextStyles.defaultStyle.fontHeader.bold,
          ),
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (ctx) => const TabsScreen()));
                },
                icon: const Icon(Icons.home))
          ],
        ),
        body: loadTour());
  }
}
