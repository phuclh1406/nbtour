import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nbtour/services/api/schedule_service.dart';
import 'package:nbtour/services/models/tour_schedule_model.dart';
import 'package:nbtour/utils/constant/colors.dart';
import 'package:nbtour/utils/constant/dimension.dart';
import 'package:nbtour/utils/constant/text_style.dart';
import 'package:nbtour/utils/helper/asset_helper.dart';
import 'package:nbtour/utils/helper/image_helper.dart';
import 'package:nbtour/services/models/season_model.dart';
import 'package:nbtour/representation/screens/tour_detail_screen.dart';
import 'package:nbtour/representation/widgets/tour_list_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

String userId = '';
String tourId = '';

class DriverTourScreen extends StatefulWidget {
  const DriverTourScreen({super.key});
  @override
  State<DriverTourScreen> createState() => _DriverTourScreenState();
}

late TourSchedule scheduleTour;

class _DriverTourScreenState extends State<DriverTourScreen> {
  bool isSearching = false;
  bool isLoading = true;
  List<TourSchedule> filteredSchedule = [];
  String _searchValue = '';
  List<TourSchedule> listTour = [];
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();
  final List<Season> seasonList = [
    Season(
        id: 1,
        seasonTitle: 'Spring',
        DateTime(DateTime.now().year, 1, 1, 0, 0, 0),
        DateTime(DateTime.now().year, 4, 1, 0, 0, 0)),
    Season(
        id: 2,
        seasonTitle: 'Summer',
        DateTime(DateTime.now().year, 4, 1, 0, 0, 0),
        DateTime(DateTime.now().year, 7, 1, 0, 0, 0)),
    Season(
        id: 3,
        seasonTitle: 'Fall',
        DateTime(DateTime.now().year, 7, 1, 0, 0, 0),
        DateTime(DateTime.now().year, 10, 1, 0, 0, 0)),
    Season(
        id: 4,
        seasonTitle: 'Winter',
        DateTime(DateTime.now().year, 10, 1, 0, 0, 0),
        DateTime(DateTime.now().year, 1, 1, 0, 0, 0)),
  ];

  @override
  initState() {
    super.initState();
    fetchUserId();
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

  bool isRightTime(TourSchedule schedule) {
    DateTime departureDate =
        DateTime.parse(schedule.departureDate!.replaceAll('Z', '000'));
    DateTime endDate = DateTime.parse(schedule.endDate!.replaceAll('Z', '000'));
    DateTime now = DateTime.now();

    if (now.isAfter(departureDate.subtract(const Duration(minutes: 30))) &&
        now.isBefore(endDate)) {
      return true;
    } else {
      return false;
    }
  }

  List<TourSchedule> filteredTours = []; // Store the filtered tours

  List<Season> selectedCategories = [];
  Widget loadScheduledTour() {
    return FutureBuilder<List<TourSchedule>?>(
      future: ScheduleService.getSchedulesByDriverId(userId),
      builder:
          (BuildContext context, AsyncSnapshot<List<TourSchedule>?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: Padding(
            padding: EdgeInsets.only(top: kMediumPadding * 6),
            child: CircularProgressIndicator(color: ColorPalette.primaryColor),
          ));
        } else if (snapshot.hasData) {
          List<TourSchedule>? listScheduledTour = snapshot.data!;
          listScheduledTour
              .sort((a, b) => b.departureDate!.compareTo(a.departureDate!));
          listScheduledTour.sort((a, b) {
            bool isRightTimeA = isRightTime(a);
            bool isRightTimeB = isRightTime(b);

            if (isRightTimeA && !isRightTimeB) {
              return -1; // a should come before b
            } else if (!isRightTimeA && isRightTimeB) {
              return 1; // b should come before a
            } else {
              return b.departureDate!.compareTo(a.departureDate!);
            }
          });
          List<TourSchedule> filteredSchedule = listScheduledTour
              .where((schedule) => schedule.scheduleTour!.tourName!
                  .toLowerCase()
                  .contains(_searchValue.toLowerCase()))
              .toList();

          filteredSchedule;
          if (!isSearching) {
            filteredSchedule = listScheduledTour;
          }
          if (filteredSchedule.isNotEmpty) {
            return Column(
              children: [
                const SizedBox(
                  height: kDefaultPadding / 5,
                ),
                for (var i = 0; i < filteredSchedule.length; i++)
                  TourListWidget(
                    borderColor: isRightTime(filteredSchedule[i]) == true
                        ? ColorPalette.primaryColor
                        : Colors.white,
                    onTap: () {
                      setState(() {
                        isSearching = false;
                        filteredSchedule = listScheduledTour;
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => TourDetailScreen(
                                    scheduleTour: filteredSchedule[i],
                                  )));
                    },

                    announcementImage: filteredSchedule[i]
                            .scheduleTour!
                            .tourImage!
                            .isNotEmpty
                        ? Image.network(
                            filteredSchedule[i]
                                .scheduleTour!
                                .tourImage![0]
                                .image!,
                            loadingBuilder: (context, child, loadingProgress) =>
                                (loadingProgress == null)
                                    ? child
                                    : const Text(''),
                            errorBuilder: (context, error, stackTrace) =>
                                ImageHelper.loadFromAsset(
                                    AssetHelper.announcementImage,
                                    width: kMediumPadding * 3,
                                    height: kMediumPadding * 5),
                            width: kMediumPadding * 3,
                            height: kMediumPadding * 5)
                        : ImageHelper.loadFromAsset(
                            AssetHelper.announcementImage,
                            width: kMediumPadding * 3,
                            height: kMediumPadding * 5),

                    // announcementImage: Image.network(),
                    title: filteredSchedule[i].scheduleTour!.tourName!,
                    departureDate: filteredSchedule[i].departureDate != null
                        ? filteredSchedule[i].departureDate!
                        : "",
                    startTime: filteredSchedule[i].departureDate != null
                        ? filteredSchedule[i].departureDate!
                        : "",
                    endTime: filteredSchedule[i].endDate != null
                        ? filteredSchedule[i].endDate!
                        : "",
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
                snapshot.toString(),
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
    return Scaffold(
      appBar: AppBar(
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
                      borderSide: BorderSide(color: ColorPalette.primaryColor)),
                  // icon: Icon(
                  //   Icons.search,
                  //   color: Colors.black, // Change icon color
                  // ),
                  hintText: "Tìm kiếm bằng tên tour...",
                  hintStyle: TextStyles.defaultStyle, //
                  // Change hint text color
                ),
              )
            : Text(
                'Danh sách',
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
    );
  }
}
