import 'package:flutter/material.dart';
import 'package:nbtour/constant/colors.dart';
import 'package:nbtour/constant/dimension.dart';
import 'package:nbtour/constant/text_style.dart';
import 'package:nbtour/models/data_source.dart';
import 'package:nbtour/models/tour_model.dart';
import 'package:nbtour/screens/driver/tour_screen.dart';
import 'package:nbtour/services/tour_service.dart';
import 'package:nbtour/widgets/button_widget/button_widget.dart';

class RescheduleTourGuideScreen extends StatefulWidget {
  const RescheduleTourGuideScreen({super.key, required this.tour});
  final Tour tour;
  @override
  State<RescheduleTourGuideScreen> createState() =>
      _RescheduleTourGuideScreenState();
}

final _form = GlobalKey<FormState>();
List<Tour>? tourList = [];
Tour? rescheduleTour;
void _submit(BuildContext context) async {
  final isValid = _form.currentState!.validate();

  if (!isValid) {
    return;
  }
  _form.currentState!.save();
  // final signInResult = await AuthServices()
  //     .signInWithUserNameAndPassword(_enteredEmail, _enteredPassword);

  // if (signInResult == 200) {
  //   String roleName = await getUser();
  //   String userId = await getUserId();
  //   print('12312312321321321321321 $roleName');
  //   if (roleName == 'TourGuide' || roleName == 'Driver') {
  //     Navigator.push(
  //         context, MaterialPageRoute(builder: (ctx) => const TabsScreen()));
  //   } else {
  //     AuthServices().googleSignOut();
  //     final prefs = await SharedPreferences.getInstance();
  //     prefs.clear();
  //     ScaffoldMessenger.of(context).clearSnackBars();
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text(
  //             'This account doesn\'t have permission to access in this application')));
  //   }
  // } else {
  //   ScaffoldMessenger.of(context).clearSnackBars();
  //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       content: Text('Email is not existed or password is not correct')));
  // }
}

Future<List<Tour>?> loadAvailableTour() async {
  try {
    List<Tour>? listScheduledTour = await TourService.getAllTours();
    if (listScheduledTour != null && listScheduledTour.isNotEmpty) {
      tourList = listScheduledTour;
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
    _toursFuture = loadAvailableTour();
  }

  @override
  Widget build(BuildContext context) {
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
                                  labelText: 'Select the tour you want to go',
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
                                items: tourList.map((tour) {
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
                                              _submit(context);
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
