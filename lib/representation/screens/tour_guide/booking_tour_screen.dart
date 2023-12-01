import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:nbtour/main.dart';
import 'package:nbtour/representation/screens/review_ride.dart';
import 'package:nbtour/representation/screens/tour_guide/submit_booking_screen.dart';
import 'package:nbtour/representation/widgets/button_widget/rectangle_button_widget.dart';
import 'package:nbtour/services/api/tour_service.dart';
import 'package:nbtour/services/models/tour_model.dart';
import 'package:nbtour/utils/constant/colors.dart';
import 'package:nbtour/utils/constant/dimension.dart';
import 'package:nbtour/utils/constant/text_style.dart';
import 'package:nbtour/utils/helper/asset_helper.dart';
import 'package:nbtour/utils/helper/image_helper.dart';

class BookingTourScreen extends StatelessWidget {
  const BookingTourScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Tour? tour;

    String userId = sharedPreferences.getString('user_id')!;

    void openAddExpenseOverlay() {
      showModalBottomSheet(
        showDragHandle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        isScrollControlled: true,
        context: context,
        builder: (ctx) => SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: SubmitBookingScreen(tour: tour!)),
      );
    }

    Size screenSize = MediaQuery.of(context).size;
    return FutureBuilder<List<Tour>?>(
        future: TourService.getToursByTourGuideId(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
                    color: ColorPalette.primaryColor));
          } else if (snapshot.hasError) {
            return Center(
                child: Column(
              children: [
                ImageHelper.loadFromAsset(AssetHelper.error),
                const SizedBox(height: 10),
                Text(
                  snapshot.toString(),
                  style: TextStyles.regularStyle,
                )
              ],
            ));
          } else {
            List<Tour> filteredTours = snapshot.data!
                .where((tour) =>
                    tour.tourStatus == 'Started' ||
                    tour.tourStatus == 'Available' &&
                        (DateTime.parse(
                                    tour.departureDate!.replaceAll('Z', '000'))
                                .subtract(const Duration(minutes: 30))
                                .isBefore(DateTime.now()) &&
                            DateTime.now().isBefore(DateTime.parse(
                                tour.endDate!.replaceAll('Z', '000')))))
                .toList();

            print(filteredTours.length);
            if (filteredTours.isEmpty) {
              return const Center(child: Text('No tour available'));
            } else {
              tour = filteredTours[0];
            }
            return SizedBox(
              width: double.maxFinite,
              height: double.maxFinite,
              child: Stack(
                children: [
                  Positioned(
                      right: 0,
                      left: 0,
                      child: Container(
                        width: double.maxFinite,
                        height: screenSize.height / 2.2,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(tour!.tourImage![0].image!),
                                fit: BoxFit.cover)),
                      )),
                  // Positioned(
                  //   left: screenSize.width / 25,
                  //   top: screenSize.height / 17,
                  //   child: IconButton(
                  //       onPressed: () {
                  //         Navigator.of(context).pop();
                  //       },
                  //       icon: Container(
                  //         decoration: const BoxDecoration(
                  //             color: Colors.white,
                  //             borderRadius: BorderRadius.all(
                  //                 Radius.circular(kMediumPadding))),
                  //         child: IconButton(
                  //             onPressed: () {
                  //               Navigator.of(context).pop();
                  //             },
                  //             icon: const Icon(
                  //               Icons.arrow_back,
                  //               size: kDefaultIconSize * 1.2,
                  //             )),
                  //       )),
                  // ),
                  Positioned(
                    top: screenSize.height / 4,
                    child: Container(
                      width: screenSize.width,
                      height: screenSize.height,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(kMediumPadding * 1.5),
                              topRight: Radius.circular(kMediumPadding * 1.5))),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: kMediumPadding,
                            right: kMediumPadding,
                            top: kMediumPadding * 1.3),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tour!.tourName!,
                              style: TextStyles.defaultStyle.fontHeader.bold,
                            ),
                            SizedBox(
                              height: screenSize.height * 0.48,
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: kDefaultIconSize,
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          FontAwesomeIcons.busSimple,
                                          size: kDefaultIconSize,
                                          color: ColorPalette.primaryColor,
                                        ),
                                        const SizedBox(
                                          width: kDefaultIconSize / 1.5,
                                        ),
                                        Text(
                                          tour!
                                              .tourRoute!
                                              .routeSegment![0]
                                              .segmentDepartureStation!
                                              .stationName!,
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: kDefaultIconSize,
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          FontAwesomeIcons.clock,
                                          size: kDefaultIconSize,
                                          color: ColorPalette.primaryColor,
                                        ),
                                        const SizedBox(
                                          width: kDefaultIconSize / 1.5,
                                        ),
                                        Text(
                                          DateFormat.yMMMd().format(
                                              DateTime.parse(
                                                  tour!.departureDate!)),
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: kDefaultIconSize,
                                    ),
                                    const Text(
                                      'Vé khả dụng',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: kDefaultIconSize / 1.5,
                                    ),
                                    const Text(
                                      'Danh sách các loại vé khả dụng',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(
                                      height: kDefaultIconSize / 1.5,
                                    ),
                                    Wrap(
                                      children: List.generate(
                                          tour!.ticket.length, (index) {
                                        return Container(
                                          margin: const EdgeInsets.only(
                                              right: 5, bottom: 5),
                                          height: 60,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: const Color.fromARGB(
                                                  30, 255, 89, 0)),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: kMediumPadding),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  tour!
                                                      .ticket[index]
                                                      .ticketType!
                                                      .ticketTypeName!,
                                                  style:
                                                      TextStyles.defaultStyle,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                    const SizedBox(
                                      height: kDefaultIconSize,
                                    ),
                                    for (var ticket in tour!.ticket)
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              '${ticket.ticketType!.ticketTypeName}: ${ticket.ticketType!.price!.amount} vnđ',
                                              style: TextStyles.defaultStyle),
                                          Text(
                                              '(${ticket.ticketType!.description})',
                                              style: TextStyles.defaultStyle),
                                          const SizedBox(
                                            height: kDefaultIconSize / 1.5,
                                          ),
                                        ],
                                      ),
                                    const Text(
                                      'Mô tả',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: kDefaultIconSize / 2,
                                    ),
                                    Text(
                                      tour!.description!,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(
                                      height: kDefaultIconSize / 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
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
                            width: MediaQuery.of(context).size.width / 2 -
                                kMediumPadding / 1.7,
                            title: 'Xem đường',
                            ontap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => ReviewRideScreen(
                                            tour: tour!,
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
                            width: MediaQuery.of(context).size.width / 2 -
                                kMediumPadding / 1.7,
                            title: 'Đặt ngay',
                            ontap: openAddExpenseOverlay,
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
              ),
            );
          }
        });
  }
}
