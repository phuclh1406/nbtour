import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nbtour/constant/colors.dart';
import 'package:nbtour/constant/dimension.dart';
import 'package:nbtour/constant/text_style.dart';
import 'package:nbtour/helper/asset_helper.dart';
import 'package:nbtour/helper/image_helper.dart';
import 'package:nbtour/models/season_model.dart';
import 'package:nbtour/models/tour_model.dart';
import 'package:nbtour/screens/filter_screen.dart';
import 'package:nbtour/screens/tour_guide/tour_detail_screen.dart';
import 'package:nbtour/widgets/tour_list_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/schedule_model.dart';
import '../../services/schedule_service.dart';

String userId = '';
String tourId = '';

class TourGuideTourScreen extends StatefulWidget {
  const TourGuideTourScreen({super.key});
  @override
  State<TourGuideTourScreen> createState() => _TourGuideTourScreenState();
}

late Schedules scheduleTour;

class _TourGuideTourScreenState extends State<TourGuideTourScreen> {
  bool isSearching = false;
  List<Schedules> filteredSchedule = [];
  String _searchValue = '';
  List<Schedules> listTour = [];
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

  List<Schedules> filteredTours = []; // Store the filtered tours

  List<Season> selectedCategories = [];
  Widget loadScheduledTour() {
    return FutureBuilder<List<Schedules>?>(
      future: ScheduleService.getScheduleToursByTourGuideId(userId),
      builder:
          (BuildContext context, AsyncSnapshot<List<Schedules>?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: Padding(
            padding: EdgeInsets.only(top: kMediumPadding),
            child: CircularProgressIndicator(
              color: ColorPalette.primaryColor,
            ),
          ));
        } else if (snapshot.hasData) {
          List<Schedules>? listScheduledTour = snapshot.data!;
          List<Schedules> filteredSchedule = listScheduledTour
              .where((schedule) => schedule.scheduleTour!.tourName!
                  .toLowerCase()
                  .contains(_searchValue.toLowerCase()))
              .toList();

          print(filteredSchedule);
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
                    onTap: () {
                      setState(() {
                        isSearching = false;
                        filteredSchedule = listScheduledTour;
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => TourGuideTourDetailScreen(
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
                                    : const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Center(
                                            child: CircularProgressIndicator(
                                                color:
                                                    ColorPalette.primaryColor),
                                          ),
                                        ],
                                      ),
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
                    departureDate:
                        filteredSchedule[i].scheduleTour!.departureDate != null
                            ? filteredSchedule[i]
                                .scheduleTour!
                                .departureDate!
                                .toString()
                            : "",
                    startTime: filteredSchedule[i].startTime != null
                        ? filteredSchedule[i].startTime!
                        : "",
                    endTime: filteredSchedule[i].endTime != null
                        ? filteredSchedule[i].endTime!
                        : "",
                  ),
                const SizedBox(
                  height: kDefaultPadding / 2,
                ),
              ],
            );
          } else {
            return const Center(child: Text('No schedules found.'));
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
                style:
                    const TextStyle(color: Colors.black), // Change text color
                decoration: const InputDecoration(
                  icon: Icon(Icons.search, color: Colors.black),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: ColorPalette.primaryColor)),
                  // icon: Icon(
                  //   Icons.search,
                  //   color: Colors.black, // Change icon color
                  // ),
                  hintText: "Search by tour name...",
                  hintStyle:
                      TextStyle(color: Colors.black), // Change hint text color
                ),
              )
            : Text(
                'Tour Screen',
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
      body: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: seasonList
                  .map((season) => FilterChip(
                        label: Text(season.seasonTitle),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              selectedCategories.add(season);
                            } else {
                              selectedCategories.removeWhere((selectedSeason) =>
                                  selectedSeason.id == season.id);
                            }
                            print('Selected Categories: $selectedCategories');
                          });
                        },
                      ))
                  .toList(),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: loadScheduledTour(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
