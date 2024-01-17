import 'package:flutter/material.dart';
import 'package:nbtour/services/api/form_service.dart';
import 'package:nbtour/services/api/schedule_service.dart';
import 'package:nbtour/services/models/tour_schedule_model.dart';
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

class SentRequestScreen extends StatefulWidget {
  const SentRequestScreen({super.key});
  @override
  State<SentRequestScreen> createState() => _SentRequestScreenState();
}

class _SentRequestScreenState extends State<SentRequestScreen>
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
  TourSchedule? oldSchedule;
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();
  Stream<List<RescheduleForm>?>? requestStream;

  @override
  initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    requestStream = Stream.periodic(const Duration(seconds: 3), (_) {
      return fetchRequest();
    }).asyncMap((_) => fetchRequest());
  }

  Future<List<RescheduleForm>?> fetchRequest() async {
    try {
      final updatedBookingList = await RescheduleServices.getSentForm(userId);
      print(updatedBookingList!.length);
      return updatedBookingList;
    } catch (e) {
      // Handle error as needed
      return null;
    }
  }

  Future<String>? fetchRequestSchedule(String scheduleId) async {
    oldSchedule = await ScheduleService.getScheduleByScheduleId(scheduleId);
    if (oldSchedule != null) {
      return oldSchedule!.scheduleTour!.tourName!;
    } else {
      return "";
    }
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

  // Store the filtered tours
  Widget loadScheduledTour() {
    return StreamBuilder<List<RescheduleForm>?>(
      stream: requestStream,
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
                      RequestListWidget(
                        onTap: () {
                          setState(() {
                            isSearching = false;
                            filteredSchedule = listScheduledTour;
                          });
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
                        tour: filteredSchedule[i].currentSchedule != null
                            ? filteredSchedule[i]
                                .currentSchedule!
                                .scheduleTour!
                                .tourName!
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
            return const Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Không có dữ liệu'),
              ],
            ));
          }
        } else if (snapshot.hasError) {
          // Display an error message if the future completed with an error
          return Text('Error: ${snapshot.error}');
        } else {
          return const Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Không có dữ liệu'),
            ],
          ));
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
              splashFactory: NoSplash.splashFactory,
              labelStyle: TextStyles.defaultStyle,
              automaticIndicatorColorAdjustment: true,
              tabs: const [
                Tab(
                  text: 'All',
                ),
                Tab(text: 'Đang chờ'),
                Tab(text: 'Chấp nhận'),
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
                    hintText: "Tìm kiếm bằng tên người gửi...",
                    hintStyle: TextStyles.defaultStyle, //Change hint text color
                  ),
                )
              : Text(
                  'Đơn của tôi',
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
