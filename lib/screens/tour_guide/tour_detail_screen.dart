import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:nbtour/constant/colors.dart';
import 'package:nbtour/constant/dimension.dart';
import 'package:nbtour/constant/text_style.dart';
import 'package:nbtour/helper/asset_helper.dart';
import 'package:nbtour/helper/image_helper.dart';
import 'package:nbtour/models/tour_model.dart';
import 'package:nbtour/screens/tour_guide/review_ride.dart';
import 'package:nbtour/screens/reschedule_screen.dart';
import 'package:nbtour/screens/tab_screen.dart';

import 'package:nbtour/services/tour_service.dart';

import 'package:nbtour/widgets/button_widget/oval_button_widget.dart';

String userId = '';
String tourId = '';

class TourGuideTourDetailScreen extends StatelessWidget {
  const TourGuideTourDetailScreen({super.key, required this.scheduleTour});
  final Tour scheduleTour;

  // final String tourId;
  @override
  Widget build(BuildContext context) {
    void _openAddExpenseOverlay() {
      showModalBottomSheet(
        showDragHandle: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) => SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: RescheduleTourGuideScreen(tour: scheduleTour)),
      );
    }

    // scheduleTour.scheduleTour!.tourRoute!.routeId!;
    final size = MediaQuery.of(context).size;
    Widget loadTour() {
      return FutureBuilder<Tour?>(
        future: TourService.getTourByTourId(scheduleTour.tourId!),
        builder: (BuildContext context, AsyncSnapshot<Tour?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: Padding(
              padding: EdgeInsets.only(top: kMediumPadding),
              child: CircularProgressIndicator(
                color: ColorPalette.primaryColor,
              ),
            ));
          } else if (snapshot.hasData) {
            Tour? tour = snapshot.data!;

            print(tour);
            if (tour != null) {
              return SizedBox(
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
                                loadingBuilder: (context, child,
                                        loadingProgress) =>
                                    (loadingProgress == null)
                                        ? child
                                        : const CircularProgressIndicator(),
                                errorBuilder: (context, error, stackTrace) =>
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
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            const SizedBox(
                              width: kMediumPadding,
                            ),
                            OvalButtonWidget(
                              title: 'Show direction',
                              ontap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) =>
                                            ReviewRideTourGuideScreen(
                                                routeId:
                                                    tour.tourRoute!.routeId!,
                                                tourId: tour.tourId!,
                                                tourName: tour.tourName!)));
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
                            const SizedBox(width: kDefaultIconSize / 2),
                            OvalButtonWidget(
                              title: 'View in your schedule',
                              ontap: () {},
                              buttonColor: Colors.white,
                              textStyle:
                                  TextStyles.defaultStyle.primaryTextColor,
                              isIcon: true,
                              borderColor: ColorPalette.primaryColor,
                              icon: const Icon(
                                FontAwesomeIcons.calendarDays,
                                color: ColorPalette.primaryColor,
                                size: kDefaultIconSize + 3,
                              ),
                            ),
                            const SizedBox(width: kDefaultIconSize / 2),
                            OvalButtonWidget(
                              title: 'Reschedule',
                              ontap: _openAddExpenseOverlay,
                              buttonColor: Colors.white,
                              textStyle:
                                  TextStyles.defaultStyle.primaryTextColor,
                              isIcon: true,
                              borderColor: ColorPalette.primaryColor,
                              icon: const Icon(
                                Icons.change_circle_rounded,
                                color: ColorPalette.primaryColor,
                                size: kDefaultIconSize + 3,
                              ),
                            ),
                            const SizedBox(width: kMediumPadding),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: kMediumPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(tour.tourName!,
                                style: const TextStyle(fontSize: 25)),
                            const SizedBox(height: kMediumPadding / 2),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            47, 255, 89, 0),
                                        borderRadius:
                                            BorderRadius.circular(10)),
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
                                            'Departure date: ${tour.departureDate!.substring(0, 10)}',
                                            style:
                                                TextStyles.defaultStyle.bold),
                                      const SizedBox(
                                        height: kDefaultIconSize / 4,
                                      ),
                                      if (tour.departureDate != null)
                                        Text(
                                            'Start time: ${tour.departureDate!.substring(11, 19)}',
                                            style: TextStyles.defaultStyle
                                                .subTitleTextColor),
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
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      color:
                                          const Color.fromARGB(47, 255, 89, 0),
                                      borderRadius: BorderRadius.circular(10)),
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
                                      if (tour.departureStation != null)
                                        Text(
                                          tour.departureStation!.stationName!,
                                          style: TextStyles.defaultStyle.bold,
                                          maxLines: 3,
                                        ),
                                      const SizedBox(
                                        height: kDefaultIconSize / 4,
                                      ),
                                      if (tour.departureStation != null)
                                        Text(
                                          tour.departureStation!.description!,
                                          style: TextStyles
                                              .defaultStyle.subTitleTextColor,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            47, 255, 89, 0),
                                        borderRadius:
                                            BorderRadius.circular(10)),
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
                                            'Bus Plate: ${scheduleTour.tourBus!.busPlate!}',
                                            style:
                                                TextStyles.defaultStyle.bold),
                                      const SizedBox(
                                        height: kDefaultIconSize / 4,
                                      ),
                                      if (scheduleTour.tourBus != null)
                                        Text(
                                            scheduleTour
                                                    .tourBus!.isDoubleDecker!
                                                ? 'Double Decker Bus (${scheduleTour.tourBus!.numberSeat} seats)'
                                                : 'One Decker Bus (${scheduleTour.tourBus!.numberSeat} seats)',
                                            style: TextStyles.defaultStyle
                                                .subTitleTextColor),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
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
                                                'Driver: ${scheduleTour.driver!.name!}',
                                                style: TextStyles
                                                    .defaultStyle.bold)
                                            : Text('Not assigned',
                                                style: TextStyles
                                                    .defaultStyle.bold),
                                      const SizedBox(
                                        height: kDefaultIconSize / 4,
                                      ),
                                      if (scheduleTour.driver != null)
                                        scheduleTour.driver!.email != null
                                            ? Text(scheduleTour.driver!.email!,
                                                style: TextStyles.defaultStyle
                                                    .subTitleTextColor)
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
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                      scheduleTour.tourGuide!.avatar!,
                                      width: 55,
                                      fit: BoxFit.fitWidth),
                                ),
                                const SizedBox(
                                  width: kMediumPadding,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (scheduleTour.tourGuide != null)
                                      scheduleTour.tourGuide!.name != null
                                          ? Text(
                                              'Tour Guide: ${scheduleTour.tourGuide!.name!}',
                                              style:
                                                  TextStyles.defaultStyle.bold)
                                          : Text('Not assigned',
                                              style:
                                                  TextStyles.defaultStyle.bold),
                                    const SizedBox(
                                      height: kDefaultIconSize / 4,
                                    ),
                                    if (scheduleTour.tourGuide != null)
                                      scheduleTour.tourGuide!.email != null
                                          ? Text(scheduleTour.tourGuide!.email!,
                                              style: TextStyles.defaultStyle
                                                  .subTitleTextColor)
                                          : Text('',
                                              style:
                                                  TextStyles.defaultStyle.bold),
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
              );
            } else {
              return const Text('No tour found.');
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
