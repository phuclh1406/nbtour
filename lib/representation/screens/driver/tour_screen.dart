import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nbtour/services/api/tour_service.dart';
import 'package:nbtour/utils/constant/colors.dart';
import 'package:nbtour/utils/constant/dimension.dart';
import 'package:nbtour/utils/constant/text_style.dart';
import 'package:nbtour/utils/helper/asset_helper.dart';
import 'package:nbtour/utils/helper/image_helper.dart';
import 'package:nbtour/services/models/season_model.dart';
import 'package:nbtour/services/models/tour_model.dart';
import 'package:nbtour/representation/screens/driver/tour_detail_screen.dart';
import 'package:nbtour/representation/widgets/tour_list_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

String userId = '';
String tourId = '';

class DriverTourScreen extends StatefulWidget {
  const DriverTourScreen({super.key});
  @override
  State<DriverTourScreen> createState() => _DriverTourScreenState();
}

late Tour scheduleTour;

class _DriverTourScreenState extends State<DriverTourScreen> {
  bool isSearching = false;
  List<Tour> filteredSchedule = [];
  String _searchValue = '';
  List<Tour> listTour = [];
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

  List<Tour> filteredTours = []; // Store the filtered tours

  List<Season> selectedCategories = [];
  Widget loadScheduledTour() {
    return FutureBuilder<List<Tour>?>(
      future: TourService.getToursByDriverId(userId),
      builder: (BuildContext context, AsyncSnapshot<List<Tour>?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: Padding(
            padding: EdgeInsets.only(top: kMediumPadding),
            child: CircularProgressIndicator(
              color: ColorPalette.primaryColor,
            ),
          ));
        } else if (snapshot.hasData) {
          List<Tour>? listScheduledTour = snapshot.data!;
          List<Tour> filteredSchedule = listScheduledTour
              .where((schedule) => schedule.tourName!
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
                    onTap: () {
                      setState(() {
                        isSearching = false;
                        filteredSchedule = listScheduledTour;
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => DriverTourDetailScreen(
                                    scheduleTour: filteredSchedule[i],
                                  )));
                    },

                    announcementImage: filteredSchedule[i].tourImage!.isNotEmpty
                        ? Image.network(
                            filteredSchedule[i].tourImage![0].image!,
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
                    title: filteredSchedule[i].tourName!,
                    departureDate: filteredSchedule[i].departureDate != null
                        ? filteredSchedule[i].departureDate!.toString()
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
