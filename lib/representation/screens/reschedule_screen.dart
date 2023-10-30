import 'package:flutter/material.dart';
import 'package:nbtour/services/api/form_service.dart';
import 'package:nbtour/services/api/tour_service.dart';
import 'package:nbtour/utils/constant/colors.dart';
import 'package:nbtour/utils/constant/dimension.dart';
import 'package:nbtour/utils/constant/text_style.dart';
import 'package:nbtour/main.dart';
import 'package:nbtour/services/models/tour_model.dart';

import 'package:nbtour/representation/widgets/button_widget/button_widget.dart';

class RescheduleTourGuideScreen extends StatefulWidget {
  const RescheduleTourGuideScreen({super.key, required this.tour});
  final Tour tour;
  @override
  State<RescheduleTourGuideScreen> createState() =>
      _RescheduleTourGuideScreenState();
}

Tour? rescheduleTour;
List<Tour>? thisUserTours;

Future<List<Tour>?> loadAvailableTour() async {
  try {
    List<Tour>? listScheduledTour = await TourService.getAllTours();
    if (listScheduledTour != null && listScheduledTour.isNotEmpty) {
      return listScheduledTour;
    } else {
      // Return an empty list when there are no scheduled tours.
      return [];
    }
  } catch (e) {
    return [];
  }
}

class _RescheduleTourGuideScreenState extends State<RescheduleTourGuideScreen> {
  late Future<List<Tour>?> _toursFuture;
  @override
  void initState() {
    super.initState();
    rescheduleTour = null;
    fetchTourOfUser(widget.tour.tourGuide!.id!);
    print(widget.tour.tourGuide!.name);
    _toursFuture = loadAvailableTour();
  }

  Future<List<Tour>?> fetchTourOfUser(String userId) async {
    thisUserTours = await TourService.getToursByTourGuideId(userId);
    if (thisUserTours!.isNotEmpty) {
      return thisUserTours;
    } else {
      return [];
    }
  }

  bool hasSchedulingConflict(Tour selectedTour, Tour otherTour) {
    // Convert the tour's departure and end times to DateTime objects
    DateTime selectedTourStartTime =
        DateTime.parse(selectedTour.departureDate!);
    DateTime selectedTourEndTime = DateTime.parse(selectedTour.endDate!);

    DateTime otherTourStartTime = DateTime.parse(otherTour.departureDate!);
    DateTime otherTourEndTime = DateTime.parse(otherTour.endDate!);

    // Check for conflicts
    if (selectedTourStartTime.isBefore(otherTourEndTime) &&
        selectedTourEndTime.isAfter(otherTourStartTime)) {
      // There is a scheduling conflict
      return true;
    }

    // No conflict
    return false;
  }

  bool isTourInPast(Tour tour) {
    // Convert the tour's departure and end times to DateTime objects

    DateTime tourEndTime = DateTime.parse(tour.endDate!);

    // Check for conflicts
    if (tourEndTime.isBefore(DateTime.now().add(const Duration(days: 1)))) {
      // There is a scheduling conflict
      return true;
    }

    // No conflict
    return false;
  }

  void _submit(String desireTour, String employee) async {
    String check = await RescheduleServices.sendForm(
        widget.tour.tourId, desireTour, employee);
    if (check == "Send form success") {
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Request is sent')));
        Navigator.of(context).pop();
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Request is denied')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Tour> filteredTour = [];
    List<String> addedTourIds = [];

    final tour = widget.tour;
    return FutureBuilder<List<Tour>?>(
        future: _toursFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: ColorPalette.primaryColor,
            ));
          } else if (snapshot.hasError) {
            return Text('Error loading data: ${snapshot.error}');
          } else {
            final tourList = snapshot.data ?? [];

            print(tourList.length);
            tourList.removeWhere((tour) {
              return thisUserTours!.any((userTour) {
                // Customize this condition based on how you want to compare the Tour objects
                return tour.tourGuide!.id ==
                    userTour.tourGuide!.id; // Assuming tourId is unique
              });
            });
            print(tourList.length);
            for (var i = 0; i < tourList.length; i++) {
              bool isCurrentTourPast = isTourInPast(widget.tour);
              bool isDesireTourInPast = isTourInPast(tourList[i]);
              bool shouldAddTour = true;

              for (var j = 0; j < thisUserTours!.length; j++) {
                bool isSameTourGuideId = tourList[i].tourGuide!.id! ==
                    thisUserTours![j].tourGuide!.id!;
                bool isTourConflictWithThisUserTours =
                    hasSchedulingConflict(tourList[i], thisUserTours![j]);

                if (isCurrentTourPast ||
                    isTourConflictWithThisUserTours ||
                    isDesireTourInPast ||
                    isSameTourGuideId) {
                  shouldAddTour = false; // Don't add this tour
                  break; // No need to check other user tours, so break the inner loop
                }
              }

              // Add the tour to filteredTour if it should be added and hasn't been added before
              if (shouldAddTour && !addedTourIds.contains(tourList[i].tourId)) {
                filteredTour.add(tourList[i]);
                addedTourIds.add(tourList[i].tourId!); // Track this tour ID
              }
            }

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: kMediumPadding, right: kMediumPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Reschedule',
                        style: TextStyles.defaultStyle.subTitleTextColor),
                    const SizedBox(height: kDefaultIconSize / 2),
                    Text(tour.tourName!, style: TextStyles.regularStyle.bold),
                    const SizedBox(height: kMediumPadding),
                    Expanded(
                      child: Column(
                        children: [
                          SizedBox(
                            child: SingleChildScrollView(
                              child: DropdownButtonFormField<Tour>(
                                alignment: AlignmentDirectional.bottomCenter,
                                isExpanded: true,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.tour_outlined),
                                  prefixIconColor:
                                      Color.fromARGB(255, 112, 111, 111),
                                  labelText:
                                      'Select the tour you want to switch',
                                  labelStyle: TextStyles.defaultStyle,
                                  hintText: 'Select tour',
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 246, 243, 243),
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(kMediumPadding / 2.5),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 62, 62, 62),
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(kMediumPadding / 2.5),
                                    ),
                                  ),
                                ),
                                onSaved: (value) {
                                  // _enteredEmail = value!;
                                },
                                items: filteredTour.map((tour) {
                                  return DropdownMenuItem<Tour>(
                                    value: tour,
                                    child: Text(tour.tourName!),
                                  );
                                }).toList(),
                                onChanged: (Tour? newValue) {
                                  setState(() {
                                    rescheduleTour = newValue!;
                                  });
                                },
                              ),
                            ),
                          ),
                          rescheduleTour != null
                              ? Expanded(
                                  child: SingleChildScrollView(
                                      physics: const BouncingScrollPhysics(),
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                              height: kMediumPadding),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text('Start time: ',
                                                      style: TextStyles
                                                          .defaultStyle
                                                          .subTitleTextColor),
                                                  Text(
                                                      rescheduleTour
                                                                  ?.departureDate !=
                                                              null
                                                          ? rescheduleTour!
                                                              .departureDate!
                                                              .substring(11, 19)
                                                          : "",
                                                      style: TextStyles
                                                          .defaultStyle),
                                                ],
                                              ),
                                              const SizedBox(
                                                  width: kDefaultIconSize / 2),
                                              const Text(' - ',
                                                  style:
                                                      TextStyles.defaultStyle),
                                              const SizedBox(
                                                  width: kDefaultIconSize / 2),
                                              Row(
                                                children: [
                                                  Text('End time: ',
                                                      style: TextStyles
                                                          .defaultStyle
                                                          .subTitleTextColor),
                                                  Text(
                                                      rescheduleTour?.endDate !=
                                                              null
                                                          ? rescheduleTour!
                                                              .endDate!
                                                              .substring(11, 19)
                                                          : "",
                                                      style: TextStyles
                                                          .defaultStyle),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                              height: kDefaultIconSize),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text('Route name: ',
                                                  style: TextStyles.defaultStyle
                                                      .subTitleTextColor),
                                              Text(
                                                  rescheduleTour?.tourRoute !=
                                                          null
                                                      ? rescheduleTour!
                                                          .tourRoute!.routeName!
                                                      : "",
                                                  style:
                                                      TextStyles.defaultStyle),
                                            ],
                                          ),
                                          const SizedBox(
                                              height: kDefaultIconSize),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text('Bus plate: ',
                                                  style: TextStyles.defaultStyle
                                                      .subTitleTextColor),
                                              Text(
                                                  rescheduleTour?.tourBus !=
                                                          null
                                                      ? rescheduleTour!
                                                          .tourBus!.busPlate!
                                                      : "",
                                                  style:
                                                      TextStyles.defaultStyle),
                                            ],
                                          ),
                                          const SizedBox(
                                              height: kDefaultIconSize),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text('Departure date: ',
                                                  style: TextStyles.defaultStyle
                                                      .subTitleTextColor),
                                              Text(
                                                  rescheduleTour
                                                              ?.departureDate !=
                                                          null
                                                      ? rescheduleTour!
                                                          .departureDate!
                                                          .substring(1, 10)
                                                      : "",
                                                  style:
                                                      TextStyles.defaultStyle),
                                            ],
                                          ),
                                          const SizedBox(
                                              height: kDefaultIconSize),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text('Tour Guide: ',
                                                  style: TextStyles.defaultStyle
                                                      .subTitleTextColor),
                                              Text(
                                                  rescheduleTour?.tourGuide !=
                                                          null
                                                      ? rescheduleTour!
                                                          .tourGuide!.name!
                                                      : "",
                                                  style:
                                                      TextStyles.defaultStyle),
                                            ],
                                          ),
                                          const SizedBox(
                                              height: kDefaultIconSize),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text('Email: ',
                                                  style: TextStyles.defaultStyle
                                                      .subTitleTextColor),
                                              Text(
                                                  rescheduleTour?.tourGuide !=
                                                          null
                                                      ? rescheduleTour!
                                                          .tourGuide!.email!
                                                      : "",
                                                  style:
                                                      TextStyles.defaultStyle),
                                            ],
                                          ),
                                          const SizedBox(
                                              height: kDefaultIconSize),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text('Driver: ',
                                                  style: TextStyles.defaultStyle
                                                      .subTitleTextColor),
                                              Text(
                                                  rescheduleTour?.driver != null
                                                      ? rescheduleTour!
                                                          .driver!.name!
                                                      : "",
                                                  style:
                                                      TextStyles.defaultStyle),
                                            ],
                                          ),
                                          const SizedBox(
                                              height: kDefaultIconSize),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text('Email: ',
                                                  style: TextStyles.defaultStyle
                                                      .subTitleTextColor),
                                              Text(
                                                  rescheduleTour?.driver != null
                                                      ? rescheduleTour!
                                                          .driver!.email!
                                                      : "",
                                                  style:
                                                      TextStyles.defaultStyle),
                                            ],
                                          ),
                                          const SizedBox(
                                              height: kDefaultIconSize),
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text('Tour description',
                                                style: TextStyles.regularStyle
                                                    .bold.subTitleTextColor),
                                          ),
                                          const SizedBox(
                                              height: kDefaultIconSize / 2),
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              rescheduleTour?.description !=
                                                      null
                                                  ? rescheduleTour!.description!
                                                  : "",
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  height: 1.5),
                                            ),
                                          ),
                                          const SizedBox(
                                              height: kDefaultIconSize),
                                          ButtonWidget(
                                            isIcon: false,
                                            title: 'Send request',
                                            ontap: () {
                                              _submit(
                                                  rescheduleTour!.tourId!,
                                                  rescheduleTour!
                                                      .tourGuide!.id!);
                                            },
                                            color: const Color.fromARGB(
                                                168, 0, 0, 0),
                                            textStyle: TextStyles
                                                .regularStyle.whiteTextColor,
                                          ),
                                          const SizedBox(
                                              height: kMediumPadding * 2),
                                        ],
                                      )),
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }
}
