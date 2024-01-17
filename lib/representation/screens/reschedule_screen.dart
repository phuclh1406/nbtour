import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:nbtour/representation/screens/tab_screen.dart';
import 'package:nbtour/services/api/form_service.dart';
import 'package:nbtour/services/api/schedule_service.dart';
import 'package:nbtour/services/models/tour_schedule_model.dart';
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
  const RescheduleScreen({super.key, required this.schedule});
  final TourSchedule schedule;
  @override
  State<RescheduleScreen> createState() => _RescheduleScreenState();
}

TourSchedule? rescheduleSchedule;
List<TourSchedule>? thisUserSchedules;
List<TourSchedule>? otherUserSchedules;

Future<List<TourSchedule>?> loadAvailableSchedule() async {
  try {
    List<TourSchedule>? listScheduledTour =
        await ScheduleService.getAllSchedules();
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
  late Future<List<TourSchedule>?> _scheduleFuture;
  String roleName = sharedPreferences.getString('role_name')!;
  @override
  void initState() {
    super.initState();
    rescheduleSchedule = null;
    if (sharedPreferences.getString("role_name") == "TourGuide") {
      fetchScheduleOfUser(widget.schedule.tourGuide!.id!);
    } else {
      fetchScheduleOfUser(widget.schedule.driver!.id!);
    }

    _scheduleFuture = loadAvailableSchedule();
  }

  Future<List<TourSchedule>?> fetchScheduleOfOtherUser(String userId) async {
    if (sharedPreferences.getString("role_name") == "TourGuide") {
      otherUserSchedules =
          await ScheduleService.getSchedulesByTourGuideId(userId);
    } else {
      otherUserSchedules = await ScheduleService.getSchedulesByDriverId(userId);
    }
    if (otherUserSchedules!.isNotEmpty) {
      print('${otherUserSchedules!.length}');
      return otherUserSchedules;
    } else {
      return [];
    }
  }

  Future<List<TourSchedule>?> fetchScheduleOfUser(String userId) async {
    if (sharedPreferences.getString("role_name") == "TourGuide") {
      thisUserSchedules =
          await ScheduleService.getSchedulesByTourGuideId(userId);
    } else {
      thisUserSchedules = await ScheduleService.getSchedulesByDriverId(userId);
    }
    thisUserSchedules?.removeWhere(
        (schedule) => schedule.scheduleId == widget.schedule.scheduleId);
    if (thisUserSchedules!.isNotEmpty) {
      print('${thisUserSchedules!.length}');
      return thisUserSchedules;
    } else {
      return [];
    }
  }

  bool hasSchedulingConflict(
      TourSchedule selectedSchedule, TourSchedule otherSchedule) {
    // Convert the tour's departure and end times to DateTime objects
    DateTime selectedScheduleStartTime =
        DateTime.parse(selectedSchedule.departureDate!);
    DateTime selectedScheduleEndTime =
        DateTime.parse(selectedSchedule.endDate!);

    DateTime otherScheduleStartTime =
        DateTime.parse(otherSchedule.departureDate!);
    DateTime otherScheduleEndTime = DateTime.parse(otherSchedule.endDate!);

    // Check for conflicts
    if (selectedScheduleStartTime.isBefore(otherScheduleEndTime) &&
        selectedScheduleEndTime.isAfter(otherScheduleStartTime)) {
      // There is a scheduling conflict
      return true;
    }

    // No conflict
    return false;
  }

  bool isScheduleInPast(TourSchedule schedule) {
    // Convert the tour's departure and end times to DateTime objects

    DateTime tourEndTime =
        DateTime.parse(schedule.endDate!.replaceAll('Z', '000'));

    // Check for conflicts
    if (tourEndTime.isBefore(DateTime.now())) {
      // There is a scheduling conflict
      return true;
    }

    // No conflict
    return false;
  }

  void _submit(String desireSchedule, String employee) async {
    try {
      List<TourSchedule>? otherSchedules;
      bool shouldSendForm = true;
      otherSchedules = [];
      if (roleName == 'TourGuide') {
        otherSchedules =
            await ScheduleService.getSchedulesByTourGuideId(employee);
      } else {
        otherSchedules = await ScheduleService.getSchedulesByDriverId(employee);
      }

      otherSchedules
          ?.removeWhere((schedule) => schedule.scheduleId == desireSchedule);

      for (var schedule in otherSchedules!) {
        bool isSchedulingConflict =
            hasSchedulingConflict(widget.schedule, schedule);
        if (isSchedulingConflict == true) {
          showAlertFail(
              'Ca làm việc này gây trùng lịch cho một nhân viên khác. Vui lòng chọn ca khác!');
          shouldSendForm = false;
          break;
        }
      }
      if (shouldSendForm) {
        String check = await RescheduleServices.sendForm(
            widget.schedule.scheduleId, desireSchedule, employee);
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

  void showConfirmDialog(String desireSchedule, String employee) {
    AwesomeDialog(
            context: context,
            animType: AnimType.scale,
            dialogType: DialogType.question,
            title: 'Xác nhận gửi đơn',
            desc:
                'Xác nhận đã kiểm tra thông tin của tour này! Hành động này không thể hoàn tác sau khi bấm Xác nhận',
            btnOkOnPress: () {
              _submit(desireSchedule, employee);
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
    List<TourSchedule> filteredSchedule = [];
    List<String> addedScheduleId = [];
    try {
      final schedule = widget.schedule;
      return FutureBuilder<List<TourSchedule>?>(
          future: _scheduleFuture,
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
              final scheduleList = snapshot.data ?? [];

              print('${scheduleList.length} lengtthhhhhhhhhhhh');
              if (sharedPreferences.getString("role_name") == "TourGuide") {
                scheduleList.removeWhere((schedule) {
                  thisUserSchedules = thisUserSchedules ?? [];
                  return thisUserSchedules!.any((userTour) {
                    // Customize this condition based on how you want to compare the Tour objects

                    return schedule.tourGuide?.id == userTour.tourGuide?.id;

                    // Assuming tourId is unique
                  });
                });

                scheduleList.removeWhere(
                    (schedule) => schedule.scheduleStatus != "Available");
                print(scheduleList.length);
              } else {
                thisUserSchedules ?? [];
                scheduleList.removeWhere((schedule) {
                  return thisUserSchedules!.any((userSchedule) {
                    // Customize this condition based on how you want to compare the Tour objects
                    return schedule.driver?.id ==
                        userSchedule.driver?.id; // Assuming tourId is unique
                  });
                });
                scheduleList.removeWhere(
                    (schedule) => schedule.scheduleStatus != "Available");
              }
              scheduleList.removeWhere((schedule) =>
                  schedule.scheduleId == widget.schedule.scheduleId! ||
                  DateTime.parse(schedule.departureDate!.replaceAll('Z', '000'))
                      .subtract(const Duration(hours: 24))
                      .isBefore(DateTime.now()));
              if (DateTime.parse(
                      widget.schedule.departureDate!.replaceAll('Z', '000'))
                  .subtract(const Duration(hours: 24))
                  .isBefore(DateTime.now())) {
                scheduleList.clear();
              }
              for (var i = 0; i < scheduleList.length; i++) {
                bool isCurrentScheduleInPast =
                    isScheduleInPast(widget.schedule);
                bool isDesireScheduleInPast = isScheduleInPast(scheduleList[i]);
                bool isscheduleListScheduled =
                    scheduleList[i].isScheduled! != true;
                bool shouldAddSchedule = true;

                for (var j = 0; j < thisUserSchedules!.length; j++) {
                  bool isSameEmployeeId =
                      sharedPreferences.getString("role_name") == "TourGuide"
                          ? scheduleList[i].tourGuide?.id! ==
                              thisUserSchedules![j].tourGuide?.id!
                          : scheduleList[i].driver?.id! ==
                              thisUserSchedules![j].driver?.id!;
                  bool isScheduleConflictWithThisUserSchedules =
                      hasSchedulingConflict(
                          scheduleList[i], thisUserSchedules![j]);

                  if (isCurrentScheduleInPast ||
                      isscheduleListScheduled ||
                      isScheduleConflictWithThisUserSchedules ||
                      isDesireScheduleInPast ||
                      isSameEmployeeId) {
                    shouldAddSchedule = false; // Don't add this tour
                    break; // No need to check other user tours, so break the inner loop
                  }
                }

                // Add the tour to filteredSchedule if it should be added and hasn't been added before
                if (shouldAddSchedule &&
                    !addedScheduleId.contains(scheduleList[i].scheduleId)) {
                  filteredSchedule.add(scheduleList[i]);
                  addedScheduleId
                      .add(scheduleList[i].scheduleId!); // Track this tour ID
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
                      Text(schedule.scheduleTour!.tourName!,
                          style: TextStyles.regularStyle.bold),
                      const SizedBox(height: kMediumPadding),
                      Expanded(
                        child: Column(
                          children: [
                            SizedBox(
                              child: SingleChildScrollView(
                                child: DropdownButtonFormField<TourSchedule>(
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
                                  items: filteredSchedule.map((schedule) {
                                    return DropdownMenuItem<TourSchedule>(
                                      value: schedule,
                                      child: Text(
                                          schedule.scheduleTour!.tourName!,
                                          style: TextStyles.defaultStyle),
                                    );
                                  }).toList(),
                                  onChanged: (TourSchedule? newValue) {
                                    try {
                                      setState(() {
                                        rescheduleSchedule = newValue!;
                                      });
                                    } catch (e) {
                                      print(e.toString());
                                    }
                                  },
                                ),
                              ),
                            ),
                            rescheduleSchedule != null
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
                                                        rescheduleSchedule
                                                                    ?.departureDate !=
                                                                null
                                                            ? rescheduleSchedule!
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
                                                        rescheduleSchedule
                                                                    ?.endDate !=
                                                                null
                                                            ? rescheduleSchedule!
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
                                                Text('Biển số xe: ',
                                                    style: TextStyles
                                                        .defaultStyle
                                                        .subTitleTextColor),
                                                Text(
                                                    rescheduleSchedule
                                                                ?.scheduleBus !=
                                                            null
                                                        ? rescheduleSchedule!
                                                            .scheduleBus!
                                                            .busPlate!
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
                                                    rescheduleSchedule
                                                                ?.departureDate !=
                                                            null
                                                        ? rescheduleSchedule!
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
                                                    rescheduleSchedule
                                                                ?.tourGuide !=
                                                            null
                                                        ? rescheduleSchedule!
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
                                                    rescheduleSchedule
                                                                ?.tourGuide !=
                                                            null
                                                        ? rescheduleSchedule!
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
                                                    rescheduleSchedule
                                                                ?.driver !=
                                                            null
                                                        ? rescheduleSchedule!
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
                                                    rescheduleSchedule
                                                                ?.driver !=
                                                            null
                                                        ? rescheduleSchedule!
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
                                                rescheduleSchedule
                                                            ?.scheduleTour!
                                                            .description !=
                                                        null
                                                    ? rescheduleSchedule!
                                                        .scheduleTour!
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
                                                        rescheduleSchedule!
                                                            .scheduleId!,
                                                        rescheduleSchedule!
                                                            .tourGuide!.id!)
                                                    : showConfirmDialog(
                                                        rescheduleSchedule!
                                                            .scheduleId!,
                                                        rescheduleSchedule!
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
