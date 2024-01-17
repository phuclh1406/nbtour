import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nbtour/representation/screens/report_detail.dart';
import 'package:nbtour/representation/screens/send_report_screen.dart';
import 'package:nbtour/representation/widgets/report_list_widget.dart';
import 'package:nbtour/services/api/report_service.dart';
import 'package:nbtour/services/models/report_model.dart';
import 'package:nbtour/utils/constant/colors.dart';
import 'package:nbtour/utils/constant/dimension.dart';
import 'package:nbtour/utils/constant/text_style.dart';
import 'package:nbtour/services/models/season_model.dart';
import 'package:nbtour/services/models/tour_model.dart';
import 'package:nbtour/utils/helper/asset_helper.dart';
import 'package:nbtour/utils/helper/image_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

String userId = '';
String tourId = '';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});
  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

late Tour scheduleTour;

class _ReportScreenState extends State<ReportScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Reports> allReports = [];
  List<Reports> pendingReports = [];
  List<Reports> approvedReports = [];
  List<Reports> rejectedReports = [];
  int selectedTab = 0;
  bool isSearching = false;
  bool isLoading = true;
  List<Reports> filteredSchedule = [];
  String _searchValue = '';
  List<Reports> listTour = [];
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();

  @override
  initState() {
    super.initState();
    setState(() {});
    fetchUserId();
    _tabController = TabController(length: 4, vsync: this);
  }

  Future<void> fetchUserId() async {
    final prefs = await SharedPreferences.getInstance();
    String? fetchUserId = prefs.getString('user_id');
    if (fetchUserId != null) {
      setState(() {
        userId = fetchUserId;
      });
    }
  }

  void openReportOverlay(Reports report) {
    showModalBottomSheet(
      showDragHandle: true,
      elevation: 0,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,

          // child: TimelinesScreen(route: route)),
          child: ReportDetailScreen(
            report: report,
          )),
    );
  }

  List<Reports> filteredTours = []; // Store the filtered tours

  List<Season> selectedCategories = [];
  Widget loadScheduledTour() {
    return FutureBuilder<List<Reports>?>(
      future: ReportServices.getReportListByReportUser(userId),
      builder: (BuildContext context, AsyncSnapshot<List<Reports>?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: Padding(
            padding: EdgeInsets.only(top: kMediumPadding * 6),
            child: CircularProgressIndicator(color: ColorPalette.primaryColor),
          ));
        } else if (snapshot.hasData) {
          List<Reports>? listScheduledTour = snapshot.data!;
          listScheduledTour
              .sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
          allReports = listScheduledTour;
          pendingReports = listScheduledTour
              .where((report) => report.reportStatus == 'Pending')
              .toList();
          approvedReports = listScheduledTour
              .where((report) => report.reportStatus == 'Approved')
              .toList();

          rejectedReports = listScheduledTour
              .where((report) => report.reportStatus == 'Rejected')
              .toList();

          switch (_tabController.index) {
            case 0:
              filteredSchedule = allReports
                  .where((schedule) => schedule.title!
                      .toLowerCase()
                      .contains(_searchValue.toLowerCase()))
                  .toList();
              break;
            case 1:
              filteredSchedule = pendingReports
                  .where((schedule) => schedule.title!
                      .toLowerCase()
                      .contains(_searchValue.toLowerCase()))
                  .toList();
              break;
            case 2:
              filteredSchedule = approvedReports
                  .where((schedule) => schedule.title!
                      .toLowerCase()
                      .contains(_searchValue.toLowerCase()))
                  .toList();
              break;
            case 3:
              filteredSchedule = rejectedReports
                  .where((schedule) => schedule.title!
                      .toLowerCase()
                      .contains(_searchValue.toLowerCase()))
                  .toList();
              break;
          }
          if (!isSearching) {
            switch (_tabController.index) {
              case 0:
                filteredSchedule = allReports;

                break;
              case 1:
                filteredSchedule = pendingReports;

                break;
              case 2:
                filteredSchedule = approvedReports;
                break;
              case 3:
                filteredSchedule = rejectedReports;
                break;
            }
          }
          if (filteredSchedule.isNotEmpty) {
            return Column(
              children: [
                const SizedBox(
                  height: kDefaultPadding / 5,
                ),
                for (var i = 0; i < filteredSchedule.length; i++)
                  ReportListWidget(
                    onTap: () {
                      openReportOverlay(filteredSchedule[i]);
                    },

                    // announcementImage: Image.network(),
                    title: filteredSchedule[i].title!,
                    reportedDate: filteredSchedule[i].createdAt!,
                    status: filteredSchedule[i].reportStatus!,
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
          return const SizedBox(); // Return an empty container or widget if data is null
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
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
              automaticIndicatorColorAdjustment: true,
              tabs: const [
                Tab(
                  text: 'All',
                ),
                Tab(text: 'Pending'),
                Tab(text: 'Approved'),
                Tab(text: 'Rejected')
              ]),
          automaticallyImplyLeading: false,
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
                  decoration: const InputDecoration(
                    icon: Icon(Icons.search),
                    focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: ColorPalette.primaryColor)),
                    // icon: Icon(
                    //   Icons.search,
                    //   color: Colors.black, // Change icon color
                    // ),
                    hintText: "Tìm kiếm bằng tiêu đề đơn...",
                    hintStyle: TextStyles.defaultStyle, //
                    // Change hint text color
                  ),
                )
              : Text(
                  'Trang gửi đơn',
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
