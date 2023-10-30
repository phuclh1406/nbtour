import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

import 'package:lottie/lottie.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});
  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  bool isSearching = false;
  bool isLoading = true;
  String? nameOfTour;
  List<Form> filteredSchedule = [];
  String _searchValue = '';
  String userId = sharedPreferences.getString('user_id')!;
  List<Form> listTour = [];
  Tour? oldTour;
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
  }

  Future<String>? fetchRequestTour(String tourId) async {
    oldTour = await TourService.getTourByTourId(tourId);
    if (oldTour != null) {
      return oldTour!.tourName!;
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

  void _onCheckIn(id, status) {
    setState(() {
      RescheduleServices.updateRequestStatus(id, status);
    });
  }

  void _onRemove(id, status) {
    setState(() {
      RescheduleServices.updateRequestStatus(id, status);
    });
  }

  // Store the filtered tours
  Widget loadScheduledTour() {
    return FutureBuilder<List<RescheduleForm>?>(
      future: RescheduleServices.getFormList(userId),
      builder: (BuildContext context,
          AsyncSnapshot<List<RescheduleForm>?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: Padding(
            padding: const EdgeInsets.only(top: kMediumPadding),
            child: Lottie.asset('assets/animations/loading.json'),
          ));
        } else if (snapshot.hasData) {
          List<RescheduleForm>? listScheduledTour = snapshot.data!;
          listScheduledTour
              .removeWhere((schedule) => schedule.status != "Pending");
          List<RescheduleForm> filteredSchedule = listScheduledTour
              .where((schedule) => schedule.formUser!.name!
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
                  filteredSchedule[i].status == "Pending"
                      ? Slidable(
                          endActionPane: ActionPane(
                            motion: const StretchMotion(),
                            children: [
                              SlidableAction(
                                  onPressed: (context) => _onCheckIn(
                                      filteredSchedule[i].formId!, "Approved"),
                                  backgroundColor: Colors.green,
                                  icon: FontAwesomeIcons.check,
                                  label: 'Accept'),
                              SlidableAction(
                                  onPressed: (context) => _onRemove(
                                      filteredSchedule[i].formId!, "Rejected"),
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
                            tour: filteredSchedule[i].currentTour!.tourName !=
                                    null
                                ? filteredSchedule[i].currentTour!.tourName!
                                : "",
                            name: filteredSchedule[i].formUser!.name != null
                                ? filteredSchedule[i].formUser!.name!
                                : "",
                          ),
                        )
                      : const SizedBox.shrink(),
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
          return const Text(
              'No data'); // Return an empty container or widget if data is null
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
                  hintText: "Search by requester name...",
                  hintStyle:
                      TextStyle(color: Colors.black), // Change hint text color
                ),
              )
            : Text(
                'Request list',
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
        child: Expanded(
          child: SingleChildScrollView(
            child: loadScheduledTour(),
          ),
        ),
      ),
    );
  }
}
