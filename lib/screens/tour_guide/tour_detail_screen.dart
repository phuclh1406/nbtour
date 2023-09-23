import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nbtour/constant/colors.dart';
import 'package:nbtour/constant/dimension.dart';
import 'package:nbtour/constant/text_style.dart';

import 'package:nbtour/models/schedule_model.dart';
import 'package:nbtour/models/tour_model.dart';
import 'package:nbtour/screens/tab_screen.dart';

import 'package:nbtour/services/tour_service.dart';
import 'package:nbtour/widgets/button_widget.dart';

import 'package:nbtour/widgets/oval_button_widget.dart';

String userId = '';

class TourGuideTourDetailScreen extends StatelessWidget {
  const TourGuideTourDetailScreen({super.key, required this.scheduleTour});
  final Schedules scheduleTour;

  // final String tourId;
  @override
  Widget build(BuildContext context) {
    print(
        '12312312321321321321312 ${scheduleTour.scheduleTourguild!.toString()}');
    final size = MediaQuery.of(context).size;
    Widget loadTour() {
      return FutureBuilder<Tour?>(
        future: TourService.getTourByTourId(scheduleTour.scheduleTour!.tourId!),
        builder: (BuildContext context, AsyncSnapshot<Tour?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: Padding(
              padding: EdgeInsets.only(top: kMediumPadding),
              child: CircularProgressIndicator(),
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
                      Image.network(tour.tourImage![0].image!,
                          width: size.width, fit: BoxFit.fitWidth),
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
                              ontap: () {},
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
                              ontap: () {},
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
                                      Text(
                                          'Departure date: ${tour.departureDate!.substring(0, 10)}',
                                          style: TextStyles.defaultStyle.bold),
                                      const SizedBox(
                                        height: kDefaultIconSize,
                                      ),
                                      Text(
                                          'Start time: ${tour.departureDate!.substring(11, 19)}',
                                          style: TextStyles
                                              .defaultStyle.subTitleTextColor),
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
                                      Text(
                                        tour.departureStation!.stationName!,
                                        style: TextStyles.defaultStyle.bold,
                                        maxLines: 3,
                                      ),
                                      const SizedBox(
                                        height: kDefaultIconSize / 4,
                                      ),
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
                                      Text(
                                          'Bus Plate: ${scheduleTour.scheduleBus!.busPlate!}',
                                          style: TextStyles.defaultStyle.bold),
                                      const SizedBox(
                                        height: kDefaultIconSize,
                                      ),
                                      Text(
                                          scheduleTour
                                                  .scheduleBus!.isDoubleDecker!
                                              ? 'Double Decker Bus (${scheduleTour.scheduleBus!.numberSeat} seats)'
                                              : 'One Decker Bus (${scheduleTour.scheduleBus!.numberSeat} seats)',
                                          style: TextStyles
                                              .defaultStyle.subTitleTextColor),
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
                                    child: Image.network(
                                        scheduleTour.scheduleDriver!.avatar!,
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
                                      scheduleTour.scheduleTourguild!.name !=
                                              null
                                          ? Text(
                                              'Driver: ${scheduleTour.scheduleDriver!.name!}',
                                              style:
                                                  TextStyles.defaultStyle.bold)
                                          : Text('Not assigned',
                                              style:
                                                  TextStyles.defaultStyle.bold),
                                      const SizedBox(
                                        height: kDefaultIconSize,
                                      ),
                                      scheduleTour.scheduleDriver!.email != null
                                          ? Text(
                                              scheduleTour
                                                  .scheduleDriver!.email!,
                                              style: TextStyles.defaultStyle
                                                  .subTitleTextColor)
                                          : Text('',
                                              style:
                                                  TextStyles.defaultStyle.bold),
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
                                      scheduleTour.scheduleTourguild!.avatar!,
                                      width: 55,
                                      fit: BoxFit.fitWidth),
                                ),
                                const SizedBox(
                                  width: kMediumPadding,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    scheduleTour.scheduleTourguild!.name != null
                                        ? Text(
                                            'Tour Guide: ${scheduleTour.scheduleTourguild!.name!}',
                                            style: TextStyles.defaultStyle.bold)
                                        : Text('Not assigned',
                                            style:
                                                TextStyles.defaultStyle.bold),
                                    const SizedBox(
                                      height: kDefaultIconSize,
                                    ),
                                    scheduleTour.scheduleTourguild!.email !=
                                            null
                                        ? Text(
                                            scheduleTour
                                                .scheduleTourguild!.email!,
                                            style: TextStyles
                                                .defaultStyle.subTitleTextColor)
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
                            Center(
                              child: ButtonWidget(
                                  title: 'Back to home screen',
                                  ontap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (ctx) =>
                                                const TabsScreen()));
                                  },
                                  color: ColorPalette.primaryColor,
                                  textStyle: TextStyles
                                      .regularStyle.bold.whiteTextColor,
                                  isIcon: false),
                            ),
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
            )),
        body: loadTour());
  }
}
