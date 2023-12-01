import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nbtour/representation/screens/form_detail.dart';
import 'package:nbtour/representation/screens/tab_screen.dart';
import 'package:nbtour/services/api/form_service.dart';
import 'package:nbtour/services/api/tour_service.dart';
import 'package:nbtour/utils/constant/colors.dart';
import 'package:nbtour/utils/constant/dimension.dart';
import 'package:nbtour/utils/constant/text_style.dart';
import 'package:nbtour/utils/helper/asset_helper.dart';
import 'package:nbtour/utils/helper/image_helper.dart';
import 'package:nbtour/main.dart';
import 'package:nbtour/services/models/reschedule_form_model.dart';
import 'package:nbtour/services/models/season_model.dart';
import 'package:nbtour/services/models/tour_model.dart';
import 'package:nbtour/representation/widgets/request_list_widget.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});
  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<RescheduleForm> allForms = [];
  List<RescheduleForm> acceptedForms = [];
  List<RescheduleForm> pendingForms = [];
  List<RescheduleForm> approvedForms = [];
  List<RescheduleForm> rejectedForms = [];
  List<RescheduleForm> myApplication = [];
  int selectedTab = 0;
  bool isSearching = false;
  bool isLoading = true;
  String? nameOfTour;
  List<RescheduleForm> filteredSchedule = [];
  String _searchValue = '';
  String userId = sharedPreferences.getString('user_id')!;
  Tour? oldTour;
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();

  @override
  initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  Future<String>? fetchRequestTour(String tourId) async {
    try {
      oldTour = await TourService.getTourByTourId(tourId);
      if (oldTour != null) {
        return oldTour!.tourName!;
      } else {
        return "";
      }
    } catch (e) {
      return e.toString();
    }
  }

  void showAlertSuccess(String response) {
    AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.success,
      title: 'Thành công',
      desc: response,
      btnOkOnPress: () {},
      btnOkText: 'Xác nhận',
      btnCancelText: 'Về trang chủ',
      btnCancelOnPress: () {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (ctx) => const TabsScreen()));
      },
    ).show();
  }

  void showConfirmDialogAccept(String id, String status) {
    AwesomeDialog(
            context: context,
            animType: AnimType.scale,
            dialogType: DialogType.question,
            title: 'Chấp nhận?',
            desc:
                'Bạn không thể hoàn tác hành động này sau khi đã nhấn Xác nhận!',
            btnOkOnPress: () {
              _onCheckIn(id, status);
            },
            btnOkText: 'Xác nhận',
            btnCancelText: 'Quay lại',
            btnCancelOnPress: () {})
        .show();
  }

  void showConfirmDialogReject(String id, String status) {
    AwesomeDialog(
            context: context,
            animType: AnimType.scale,
            dialogType: DialogType.question,
            title: 'Từ chối?',
            desc:
                'Bạn không thể hoàn tác hành động này sau khi đã nhấn Xác nhận!',
            btnOkOnPress: () {
              _onRemove(id, status);
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
      title: 'Thất bại',
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

  bool isDateInSeason({
    required DateTime date,
    required List<Season> seasons,
  }) {
    bool isInSeason = false; // Initialize isInSeason outside of the loop

    for (Season season in seasons) {
      // Update isInSeason inside the loop if the date is in the season
      if (date.isAfter(season.startDate) && date.isBefore(season.endDate)) {
        isInSeason = true;
        break; // You can exit the loop early since you found a match
      }
    }

    print(isInSeason);
    return isInSeason; // Return isInSeason after the loop has completed
  }

  void _onCheckIn(id, status) async {
    try {
      String check = await RescheduleServices.updateRequestStatus(id, status);
      if (check == "Update request success") {
        showAlertSuccess("Đã chấp nhận đề nghị chuyển lịch làm việc");
      } else {
        showAlertFail("Chấp nhận đề nghị chuyển lịch làm việc thất bại");
      }
    } catch (e) {
      showAlertFail(e.toString());
    }
  }

  void _onRemove(id, status) async {
    try {
      String check = await RescheduleServices.updateRequestStatus(id, status);
      if (check == "Update request success") {
        showAlertSuccess("Đã từ chối đề nghị chuyển lịch làm việc");
      } else {
        showAlertFail("Từ chối đề nghị chuyển lịch làm việc thất bại");
      }
    } catch (e) {
      showAlertFail(e.toString());
    }
  }

  // void openFormOverlay(RescheduleForm form) {
  //   showModalBottomSheet(
  //     showDragHandle: true,
  //     elevation: 0,
  //     backgroundColor: Colors.white,
  //     isScrollControlled: true,
  //     context: context,
  //     builder: (ctx) => SizedBox(
  //         height: MediaQuery.of(context).size.height * 0.8,

  //         // child: TimelinesScreen(route: route)),
  //         child: RescheduleFormDetailScreen(
  //           form: form,
  //         )),
  //   );
  // }

  // Store the filtered tours
  Widget loadScheduledTour() {
    return FutureBuilder<List<RescheduleForm>?>(
      future: RescheduleServices.getFormList(userId),
      builder: (BuildContext context,
          AsyncSnapshot<List<RescheduleForm>?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: Padding(
            padding: EdgeInsets.only(top: kMediumPadding * 6),
            child: CircularProgressIndicator(color: ColorPalette.primaryColor),
          ));
        } else if (snapshot.hasData) {
          List<RescheduleForm>? listScheduledTour = snapshot.data!;
          listScheduledTour
              .sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
          allForms = listScheduledTour;
          pendingForms = listScheduledTour
              .where((form) => form.status == 'Pending')
              .toList();
          approvedForms = listScheduledTour
              .where((form) => form.status == 'Approved')
              .toList();
          acceptedForms = listScheduledTour
              .where((form) => form.status == 'Accepted')
              .toList();
          rejectedForms = listScheduledTour
              .where((form) => form.status == 'Rejected')
              .toList();

          switch (_tabController.index) {
            case 0:
              filteredSchedule = allForms
                  .where((schedule) => schedule.formUser!.name!
                      .toLowerCase()
                      .contains(_searchValue.toLowerCase()))
                  .toList();
              break;
            case 1:
              filteredSchedule = pendingForms
                  .where((schedule) => schedule.formUser!.name!
                      .toLowerCase()
                      .contains(_searchValue.toLowerCase()))
                  .toList();
              break;
            case 2:
              filteredSchedule = acceptedForms
                  .where((schedule) => schedule.formUser!.name!
                      .toLowerCase()
                      .contains(_searchValue.toLowerCase()))
                  .toList();
              break;
            case 3:
              filteredSchedule = approvedForms
                  .where((schedule) => schedule.formUser!.name!
                      .toLowerCase()
                      .contains(_searchValue.toLowerCase()))
                  .toList();
              break;
            case 4:
              filteredSchedule = rejectedForms
                  .where((schedule) => schedule.formUser!.name!
                      .toLowerCase()
                      .contains(_searchValue.toLowerCase()))
                  .toList();
              break;
          }

          filteredSchedule;

          if (!isSearching) {
            switch (_tabController.index) {
              case 0:
                filteredSchedule = allForms;

                break;
              case 1:
                filteredSchedule = pendingForms;

                break;
              case 2:
                filteredSchedule = acceptedForms;
                break;
              case 3:
                filteredSchedule = approvedForms;
                break;
              case 4:
                filteredSchedule = rejectedForms;
            }
          }

          if (filteredSchedule.isNotEmpty) {
            return Column(
              children: [
                const SizedBox(
                  height: kDefaultPadding / 5,
                ),
                for (var i = 0; i < filteredSchedule.length; i++)
                  Column(
                    children: [
                      filteredSchedule[i].status == "Pending"
                          ? Slidable(
                              endActionPane: ActionPane(
                                motion: const StretchMotion(),
                                children: [
                                  SlidableAction(
                                      onPressed: (context) =>
                                          showConfirmDialogAccept(
                                              filteredSchedule[i].formId!,
                                              "Accepted"),
                                      backgroundColor: Colors.green,
                                      icon: FontAwesomeIcons.check,
                                      label: 'Accept'),
                                  SlidableAction(
                                      onPressed: (context) =>
                                          showConfirmDialogReject(
                                              filteredSchedule[i].formId!,
                                              "Rejected"),
                                      backgroundColor: Colors.red,
                                      icon: FontAwesomeIcons.trash,
                                      label: 'Reject')
                                ],
                              ),
                              child: RequestListWidget(
                                onTap: () {
                                  // setState(() {
                                  //   isSearching = false;
                                  //   filteredSchedule = listScheduledTour;
                                  // });
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (ctx) => TourGuideTourDetailScreen(
                                  //               scheduleTour: filteredSchedule[i],
                                  //             )));
                                },

                                announcementImage: ImageHelper.loadFromAsset(
                                    AssetHelper.request,
                                    width: kMediumPadding * 3,
                                    height: kMediumPadding * 5),

                                // announcementImage: Image.network(),
                                email: filteredSchedule[i].formUser!.email!,
                                tour: filteredSchedule[i]
                                            .currentTour!
                                            .tourName !=
                                        null
                                    ? filteredSchedule[i].currentTour!.tourName!
                                    : "",
                                name: filteredSchedule[i].formUser!.name != null
                                    ? filteredSchedule[i].formUser!.name!
                                    : "",
                                status: filteredSchedule[i].status != null
                                    ? filteredSchedule[i].status!
                                    : "",
                                date: filteredSchedule[i].createdAt != null
                                    ? filteredSchedule[i].createdAt!
                                    : "",
                              ),
                            )
                          : RequestListWidget(
                              onTap: () {
                                // setState(() {
                                //   isSearching = false;
                                //   filteredSchedule = listScheduledTour;
                                // });
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (ctx) => TourGuideTourDetailScreen(
                                //               scheduleTour: filteredSchedule[i],
                                //             )));
                              },

                              announcementImage: ImageHelper.loadFromAsset(
                                  AssetHelper.request,
                                  width: kMediumPadding * 3,
                                  height: kMediumPadding * 5),

                              // announcementImage: Image.network(),
                              email: filteredSchedule[i].formUser!.email!,
                              tour: filteredSchedule[i].currentTour!.tourName !=
                                      null
                                  ? filteredSchedule[i].currentTour!.tourName!
                                  : "",
                              name: filteredSchedule[i].formUser!.name != null
                                  ? filteredSchedule[i].formUser!.name!
                                  : "",
                              status: filteredSchedule[i].status != null
                                  ? filteredSchedule[i].status!
                                  : "",
                              date: filteredSchedule[i].createdAt != null
                                  ? filteredSchedule[i].createdAt!
                                  : "",
                            ),
                    ],
                  ),
                const SizedBox(
                  height: kDefaultPadding / 2,
                ),
              ],
            );
          } else {
            return Padding(
              padding: const EdgeInsets.only(top: kMediumPadding * 5),
              child: Center(
                  child: ImageHelper.loadFromAsset(AssetHelper.noData,
                      width: 300, fit: BoxFit.fitWidth)),
            );
          }
        } else if (snapshot.hasError) {
          // Display an error message if the future completed with an error
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
          return Padding(
            padding: const EdgeInsets.only(top: kMediumPadding * 5),
            child: Center(
                child: ImageHelper.loadFromAsset(AssetHelper.noData,
                    width: 300, fit: BoxFit.fitWidth)),
          ); // Return an empty container or widget if data is null
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
              isScrollable: true,
              onTap: (int index) {
                setState(() {
                  selectedTab = index;
                  _tabController.index =
                      index; // Set the index of _tabController
                });
              },
              labelColor: ColorPalette.primaryColor,
              indicatorColor: ColorPalette.primaryColor,
              labelStyle: TextStyles.defaultStyle,
              splashFactory: NoSplash.splashFactory,
              automaticIndicatorColorAdjustment: true,
              tabs: const [
                Tab(
                  text: 'All',
                ),
                Tab(
                  text: 'Đang chờ',
                ),
                Tab(text: 'Chấp thuận'),
                Tab(text: 'Đã duyệt'),
                Tab(text: 'Từ chối')
              ]),
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
          title: isSearching
              ? TextField(
                  cursorColor: ColorPalette.primaryColor,
                  onChanged: (value) {
                    setState(() {
                      _searchValue = value;
                    });
                  },
                  style:
                      const TextStyle(color: Colors.black), // Change text color
                  decoration: const InputDecoration(
                    icon: Icon(Icons.search, color: Colors.black),
                    focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: ColorPalette.primaryColor)),
                    // icon: Icon(
                    //   Icons.search,
                    //   color: Colors.black, // Change icon color
                    // ),
                    hintText: "tìm kiếm bằng tên người gửi...",
                    hintStyle:
                        TextStyles.defaultStyle, //// Change hint text color
                  ),
                )
              : Text(
                  'Danh sách đơn đến',
                  style: TextStyles.defaultStyle.bold.fontHeader,
                ),
          actions: <Widget>[
            isSearching
                ? IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () {
                      setState(() {
                        isSearching = false;
                        _searchValue = "";
                      });
                    },
                  )
                : IconButton(
                    onPressed: () {
                      setState(() {
                        isSearching = true;
                        _searchValue = "";
                      });
                    },
                    icon: const Icon(
                      Icons.search_outlined,
                      color: Colors.black,
                    ),
                  ),
          ],
        ),
        body: SizedBox(
          child: SingleChildScrollView(
            child: loadScheduledTour(),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
