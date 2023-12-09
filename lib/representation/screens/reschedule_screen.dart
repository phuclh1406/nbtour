import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:nbtour/representation/screens/tab_screen.dart';
import 'package:nbtour/services/api/form_service.dart';
import 'package:nbtour/services/api/tour_service.dart';
import 'package:nbtour/utils/constant/colors.dart';
import 'package:nbtour/utils/constant/dimension.dart';
import 'package:nbtour/utils/constant/text_style.dart';
import 'package:nbtour/main.dart';
import 'package:nbtour/services/models/tour_model.dart';

import 'package:nbtour/representation/widgets/button_widget/button_widget.dart';
import 'package:nbtour/utils/helper/asset_helper.dart';
import 'package:nbtour/utils/helper/image_helper.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class RescheduleScreen extends StatefulWidget {
  const RescheduleScreen({super.key, required this.tour});
  final Tour tour;
  @override
  State<RescheduleScreen> createState() => _RescheduleScreenState();
}

Tour? rescheduleTour;
List<Tour>? thisUserTours;
List<Tour>? otherUserTours;

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

class _RescheduleScreenState extends State<RescheduleScreen> {
  late Future<List<Tour>?> _toursFuture;
  String roleName = sharedPreferences.getString('role_name')!;
  @override
  void initState() {
    super.initState();
    rescheduleTour = null;
    if (sharedPreferences.getString("role_name") == "TourGuide") {
      fetchTourOfUser(widget.tour.tourGuide!.id!);
    } else {
      fetchTourOfUser(widget.tour.driver!.id!);
    }

    _toursFuture = loadAvailableTour();
  }

  Future<List<Tour>?> fetchTourOfOtherUser(String userId) async {
    if (sharedPreferences.getString("role_name") == "TourGuide") {
      otherUserTours = await TourService.getToursByTourGuideId(userId);
    } else {
      otherUserTours = await TourService.getToursByDriverId(userId);
    }
    if (otherUserTours!.isNotEmpty) {
      print('${otherUserTours!.length}');
      return otherUserTours;
    } else {
      return [];
    }
  }

  Future<List<Tour>?> fetchTourOfUser(String userId) async {
    if (sharedPreferences.getString("role_name") == "TourGuide") {
      thisUserTours = await TourService.getToursByTourGuideId(userId);
    } else {
      thisUserTours = await TourService.getToursByDriverId(userId);
    }
    thisUserTours?.removeWhere((tour) => tour.tourId == widget.tour.tourId);
    if (thisUserTours!.isNotEmpty) {
      print('${thisUserTours!.length}');
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

    DateTime tourEndTime = DateTime.parse(tour.endDate!.replaceAll('Z', '000'));

    // Check for conflicts
    if (tourEndTime.isBefore(DateTime.now())) {
      // There is a scheduling conflict
      return true;
    }

    // No conflict
    return false;
  }

  void _submit(String desireTour, String employee) async {
    try {
      List<Tour>? otherTours;
      bool shouldSendForm = true;
      otherTours = [];
      if (roleName == 'TourGuide') {
        otherTours = await TourService.getToursByTourGuideId(employee);
      } else {
        otherTours = await TourService.getToursByDriverId(employee);
      }

      otherTours?.removeWhere((tour) => tour.tourId == desireTour);

      for (var tour in otherTours!) {
        bool isSchedulingConflict = hasSchedulingConflict(widget.tour, tour);
        if (isSchedulingConflict == true) {
          showAlertFail(
              'Ca làm việc này gây trùng lịch cho một nhân viên khác. Vui lòng chọn ca khác!');
          shouldSendForm = false;
          break;
        }
      }
      if (shouldSendForm) {
        String check = await RescheduleServices.sendForm(
            widget.tour.tourId, desireTour, employee);
        if (check == "Send form success") {
          showAlertSuccess();
        } else {
          showAlertFail(check);
        }
      }
    } catch (e) {
      showAlertFail(e.toString());
    }
  }

  void showAlertSuccess() {
    AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.success,
      title: 'Gửi đơn thành công',
      btnOkOnPress: () {},
      btnOkText: 'Xác nhận',
      btnCancelText: 'Về trang chủ',
      btnCancelOnPress: () {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (ctx) => const TabsScreen()));
      },
    ).show();
  }

  void showConfirmDialog(String desireTour, String employee) {
    AwesomeDialog(
            context: context,
            animType: AnimType.scale,
            dialogType: DialogType.question,
            title: 'Xác nhận gửi đơn',
            desc:
                'Xác nhận đã kiểm tra thông tin của tour này! Hành động này không thể hoàn tác sau khi bấm Xác nhận',
            btnOkOnPress: () {
              _submit(desireTour, employee);
            },
            btnOkText: 'Xác nhận',
            btnCancelText: 'Quay lại',
            btnCancelOnPress: () {})
        .show();
  }

  void showAlertFail(String response) {
    AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.error,
      title: 'Gửi đơn thất bại',
      desc: response,
      btnOkOnPress: () {},
      btnOkText: 'Thực hiện lại',
      btnCancelText: 'Về trang chủ',
      btnCancelOnPress: () {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (ctx) => const TabsScreen()));
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    List<Tour> filteredTour = [];
    List<String> addedTourIds = [];
    try {
      final tour = widget.tour;
      return FutureBuilder<List<Tour>?>(
          future: _toursFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: Padding(
                padding: EdgeInsets.only(bottom: kMediumPadding * 6),
                child:
                    CircularProgressIndicator(color: ColorPalette.primaryColor),
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
              final tourList = snapshot.data ?? [];

              print('${tourList.length} lengtthhhhhhhhhhhh');
              if (sharedPreferences.getString("role_name") == "TourGuide") {
                tourList.removeWhere((tour) {
                  return thisUserTours!.any((userTour) {
                    // Customize this condition based on how you want to compare the Tour objects

                    return tour.tourGuide?.id == userTour.tourGuide?.id;

                    // Assuming tourId is unique
                  });
                });

                tourList.removeWhere((tour) => tour.tourStatus != "Available");
                print(tourList.length);
              } else {
                tourList.removeWhere((tour) {
                  return thisUserTours!.any((userTour) {
                    // Customize this condition based on how you want to compare the Tour objects
                    return tour.driver?.id ==
                        userTour.driver?.id; // Assuming tourId is unique
                  });
                });
                tourList.removeWhere((tour) => tour.tourStatus != "Available");
              }
              tourList
                  .removeWhere((tour) => tour.tourId == widget.tour.tourId!);
              for (var i = 0; i < tourList.length; i++) {
                bool isCurrentTourPast = isTourInPast(widget.tour);
                bool isDesireTourInPast = isTourInPast(tourList[i]);
                bool isTourListScheduled = tourList[i].isScheduled! != true;
                bool shouldAddTour = true;

                for (var j = 0; j < thisUserTours!.length; j++) {
                  bool isSameEmployeeId =
                      sharedPreferences.getString("role_name") == "TourGuide"
                          ? tourList[i].tourGuide?.id! ==
                              thisUserTours![j].tourGuide?.id!
                          : tourList[i].driver?.id! ==
                              thisUserTours![j].driver?.id!;
                  bool isTourConflictWithThisUserTours =
                      hasSchedulingConflict(tourList[i], thisUserTours![j]);

                  if (isCurrentTourPast ||
                      isTourListScheduled ||
                      isTourConflictWithThisUserTours ||
                      isDesireTourInPast ||
                      isSameEmployeeId) {
                    shouldAddTour = false; // Don't add this tour
                    break; // No need to check other user tours, so break the inner loop
                  }
                }

                // Add the tour to filteredTour if it should be added and hasn't been added before
                if (shouldAddTour &&
                    !addedTourIds.contains(tourList[i].tourId)) {
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
                      Text('Chuyển lịch',
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
                                        'Chọn một tour bạn muốn chuyển đến',
                                    labelStyle: TextStyles.defaultStyle,
                                    hintText: 'Chọn tour',
                                    hintStyle: TextStyles.defaultStyle,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 246, 243, 243),
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
                                      child: Text(tour.tourName!,
                                          style: TextStyles.defaultStyle),
                                    );
                                  }).toList(),
                                  onChanged: (Tour? newValue) {
                                    try {
                                      setState(() {
                                        rescheduleTour = newValue!;
                                      });
                                    } catch (e) {
                                      print(e.toString());
                                    }
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
                                                    Text('Khởi hành: ',
                                                        style: TextStyles
                                                            .defaultStyle
                                                            .subTitleTextColor),
                                                    Text(
                                                        rescheduleTour
                                                                    ?.departureDate !=
                                                                null
                                                            ? rescheduleTour!
                                                                .departureDate!
                                                                .substring(
                                                                    11, 19)
                                                            : "",
                                                        style: TextStyles
                                                            .defaultStyle),
                                                  ],
                                                ),
                                                const SizedBox(
                                                    width:
                                                        kDefaultIconSize / 2),
                                                const Text(' - ',
                                                    style: TextStyles
                                                        .defaultStyle),
                                                const SizedBox(
                                                    width:
                                                        kDefaultIconSize / 2),
                                                Row(
                                                  children: [
                                                    Text('Kết thúc: ',
                                                        style: TextStyles
                                                            .defaultStyle
                                                            .subTitleTextColor),
                                                    Text(
                                                        rescheduleTour
                                                                    ?.endDate !=
                                                                null
                                                            ? rescheduleTour!
                                                                .endDate!
                                                                .substring(
                                                                    11, 19)
                                                            : "",
                                                        style: TextStyles
                                                            .defaultStyle),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                                height: kDefaultIconSize / 4),
                                            const Divider(),
                                            const SizedBox(
                                                height: kDefaultIconSize / 4),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text('Tuyến: ',
                                                    style: TextStyles
                                                        .defaultStyle
                                                        .subTitleTextColor),
                                                Text(
                                                    rescheduleTour?.tourRoute !=
                                                            null
                                                        ? rescheduleTour!
                                                            .tourRoute!
                                                            .routeName!
                                                        : "",
                                                    style: TextStyles
                                                        .defaultStyle),
                                              ],
                                            ),
                                            const SizedBox(
                                                height: kDefaultIconSize / 4),
                                            const Divider(),
                                            const SizedBox(
                                                height: kDefaultIconSize / 4),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text('Biển số xe: ',
                                                    style: TextStyles
                                                        .defaultStyle
                                                        .subTitleTextColor),
                                                Text(
                                                    rescheduleTour?.tourBus !=
                                                            null
                                                        ? rescheduleTour!
                                                            .tourBus!.busPlate!
                                                        : "",
                                                    style: TextStyles
                                                        .defaultStyle),
                                              ],
                                            ),
                                            const SizedBox(
                                                height: kDefaultIconSize / 4),
                                            const Divider(),
                                            const SizedBox(
                                                height: kDefaultIconSize / 4),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text('Ngày khởi hành: ',
                                                    style: TextStyles
                                                        .defaultStyle
                                                        .subTitleTextColor),
                                                Text(
                                                    rescheduleTour
                                                                ?.departureDate !=
                                                            null
                                                        ? rescheduleTour!
                                                            .departureDate!
                                                            .substring(0, 10)
                                                        : "",
                                                    style: TextStyles
                                                        .defaultStyle),
                                              ],
                                            ),
                                            const SizedBox(
                                                height: kDefaultIconSize / 4),
                                            const Divider(),
                                            const SizedBox(
                                                height: kDefaultIconSize / 4),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text('Hướng dẫn viên: ',
                                                    style: TextStyles
                                                        .defaultStyle
                                                        .subTitleTextColor),
                                                Text(
                                                    rescheduleTour?.tourGuide !=
                                                            null
                                                        ? rescheduleTour!
                                                            .tourGuide!.name!
                                                        : "",
                                                    style: TextStyles
                                                        .defaultStyle),
                                              ],
                                            ),
                                            const SizedBox(
                                                height: kDefaultIconSize / 2),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text('Email: ',
                                                    style: TextStyles
                                                        .defaultStyle
                                                        .subTitleTextColor),
                                                Text(
                                                    rescheduleTour?.tourGuide !=
                                                            null
                                                        ? rescheduleTour!
                                                            .tourGuide!.email!
                                                        : "",
                                                    style: TextStyles
                                                        .defaultStyle),
                                              ],
                                            ),
                                            const SizedBox(
                                                height: kDefaultIconSize / 4),
                                            const Divider(),
                                            const SizedBox(
                                                height: kDefaultIconSize / 4),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text('Tài xế: ',
                                                    style: TextStyles
                                                        .defaultStyle
                                                        .subTitleTextColor),
                                                Text(
                                                    rescheduleTour?.driver !=
                                                            null
                                                        ? rescheduleTour!
                                                            .driver!.name!
                                                        : "",
                                                    style: TextStyles
                                                        .defaultStyle),
                                              ],
                                            ),
                                            const SizedBox(
                                                height: kDefaultIconSize / 2),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text('Email: ',
                                                    style: TextStyles
                                                        .defaultStyle
                                                        .subTitleTextColor),
                                                Text(
                                                    rescheduleTour?.driver !=
                                                            null
                                                        ? rescheduleTour!
                                                            .driver!.email!
                                                        : "",
                                                    style: TextStyles
                                                        .defaultStyle),
                                              ],
                                            ),
                                            const SizedBox(
                                                height: kDefaultIconSize / 4),
                                            const Divider(),
                                            const SizedBox(
                                                height: kDefaultIconSize / 4),
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Text('Mô tả',
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
                                                    ? rescheduleTour!
                                                        .description!
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
                                              title: 'Gửi đơn',
                                              ontap: () {
                                                sharedPreferences.getString(
                                                            "role_name") ==
                                                        "TourGuide"
                                                    ? showConfirmDialog(
                                                        rescheduleTour!.tourId!,
                                                        rescheduleTour!
                                                            .tourGuide!.id!)
                                                    : showConfirmDialog(
                                                        rescheduleTour!.tourId!,
                                                        rescheduleTour!
                                                            .driver!.id!);
                                              },
                                              color: ColorPalette.primaryColor,
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
}
