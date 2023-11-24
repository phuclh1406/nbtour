import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nbtour/services/api/booking_service.dart';
import 'package:nbtour/utils/constant/colors.dart';
import 'package:nbtour/utils/constant/dimension.dart';
import 'package:nbtour/utils/constant/text_style.dart';
import 'package:nbtour/utils/helper/asset_helper.dart';
import 'package:nbtour/utils/helper/image_helper.dart';
import 'package:nbtour/services/models/booking_model.dart';
import 'package:nbtour/services/models/season_model.dart';
import 'package:nbtour/services/models/tour_model.dart';
import 'package:nbtour/representation/screens/qr_scanner.dart';
import 'package:nbtour/representation/widgets/user_list_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';

String userId = '';
String tourId = '';

class BookingListCustomerScreen extends StatefulWidget {
  const BookingListCustomerScreen({super.key, required this.tourId});

  final String? tourId;

  @override
  State<BookingListCustomerScreen> createState() =>
      _BookingListCustomerScreenState();
}

late Tour scheduleTour;

class _BookingListCustomerScreenState extends State<BookingListCustomerScreen> {
  bool isSearching = false;
  bool isLoading = true;
  List<Booking> filteredSchedule = [];
  List<Booking> listScheduledTour = [];
  String _searchValue = '';
  List<Tour> listTour = [];
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();
  Stream<List<Booking>?>? bookingStream;
  @override
  initState() {
    super.initState();
    fetchUserId();
    bookingStream = Stream.periodic(const Duration(seconds: 10), (_) {
      return fetchBooking();
    }).asyncMap((_) => fetchBooking());
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

  Future<List<Booking>?> fetchBooking() async {
    try {
      final updatedBookingList =
          await BookingServices.getUserList(widget.tourId!);

      return updatedBookingList;
    } catch (e) {
      // Handle error as needed
      return null;
    }
  }

  void sortBookingsByAttendance(List<Booking> bookings) {
    // Sort the list based on the isAttended property
    bookings.sort((a, b) {
      // If a isAttended is true and b isAttended is false, a comes first
      if (a.isAttended == true && b.isAttended == false) {
        return -1;
      }
      // If b isAttended is true and a isAttended is false, b comes first
      else if (b.isAttended == true && a.isAttended == false) {
        return 1;
      }
      // If both have the same isAttended value, keep their original order
      return 0;
    });
  }

  void _onCheckIn(i, id) async {
    await BookingServices.checkInCustomer(id);

    // Update the local state after a successful API call
    setState(() {
      filteredSchedule[i].isAttended = true;
    });
  }

  // void _onRemoveCheckIn(i, id, isAttended) async {
  //   await BookingServices.checkInCustomer(id);

  //   // Update the local state after a successful API call
  //   setState(() {
  //     filteredSchedule[i].isAttended = false;
  //   });
  // }

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

    return isInSeason; // Return isInSeason after the loop has completed
  }

  Widget loadScheduledTour() {
    return StreamBuilder<List<Booking>?>(
      stream: bookingStream,
      builder: (BuildContext context, AsyncSnapshot<List<Booking>?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: Padding(
            padding: EdgeInsets.only(top: kMediumPadding * 6),
            child: CircularProgressIndicator(color: ColorPalette.primaryColor),
          ));
        } else if (snapshot.hasData) {
          listScheduledTour = snapshot.data!;

          filteredSchedule = listScheduledTour
              .where((schedule) => schedule.bookingUser!.name!
                  .toLowerCase()
                  .contains(_searchValue.toLowerCase()))
              .toList();
          filteredSchedule;
          if (!isSearching) {
            filteredSchedule = listScheduledTour;
          }

          if (filteredSchedule.isNotEmpty) {
            sortBookingsByAttendance(filteredSchedule);
            return Column(
              children: [
                const SizedBox(
                  height: kDefaultPadding / 5,
                ),
                for (var i = 0; i < filteredSchedule.length; i++)
                  filteredSchedule[i].isAttended != true
                      ? Slidable(
                          endActionPane: ActionPane(
                            motion: const StretchMotion(),
                            children: [
                              SlidableAction(
                                  onPressed: (context) => _onCheckIn(
                                      i, filteredSchedule[i].bookingId!),
                                  backgroundColor: Colors.green,
                                  icon: FontAwesomeIcons.check,
                                  label: 'Check-in')
                            ],
                          ),
                          child: UserListWidget(
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

                            color: filteredSchedule[i].isAttended == true
                                ? const Color.fromARGB(113, 38, 207, 44)
                                : const Color.fromARGB(255, 255, 255, 255),
                            announcementImage: ImageHelper.loadFromAsset(
                                AssetHelper.user,
                                width: kMediumPadding * 3,
                                height: kMediumPadding * 5),
                            // announcementImage: Image.network(),
                            title: filteredSchedule[i].bookingUser!.name!,
                            departureStation: filteredSchedule[i]
                                        .bookingDepartureStation!
                                        .stationName !=
                                    null
                                ? filteredSchedule[i]
                                    .bookingDepartureStation!
                                    .stationName!
                                : "",
                            email:
                                filteredSchedule[i].bookingUser!.email != null
                                    ? filteredSchedule[i].bookingUser!.email!
                                    : "",
                            code: filteredSchedule[i].bookingCode != null
                                ? filteredSchedule[i].bookingCode!
                                : "",
                          ),
                        )
                      : UserListWidget(
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

                          color: filteredSchedule[i].isAttended == true
                              ? const Color.fromARGB(113, 38, 207, 44)
                              : const Color.fromARGB(255, 255, 255, 255),
                          announcementImage: ImageHelper.loadFromAsset(
                              AssetHelper.user,
                              width: kMediumPadding * 3,
                              height: kMediumPadding * 5),
                          // announcementImage: Image.network(),
                          title: filteredSchedule[i].bookingUser!.name!,
                          departureStation: filteredSchedule[i]
                                      .bookingDepartureStation!
                                      .stationName !=
                                  null
                              ? filteredSchedule[i]
                                  .bookingDepartureStation!
                                  .stationName!
                              : "",
                          email: filteredSchedule[i].bookingUser!.email != null
                              ? filteredSchedule[i].bookingUser!.email!
                              : "",
                          code: filteredSchedule[i].bookingCode != null
                              ? filteredSchedule[i].bookingCode!
                              : "",
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
                  hintText: "Search by customer name...",
                  hintStyle:
                      TextStyle(color: Colors.black), // Change hint text color
                ),
              )
            : Text(
                'User list',
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
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (ctx) => const QRScanner()));
            },
            icon: const Icon(
              Icons.qr_code_scanner,
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
    );
  }
}
