import 'package:flutter/material.dart';
import 'package:nbtour/constant/dimension.dart';
import 'package:nbtour/constant/text_style.dart';
import 'package:nbtour/helper/asset_helper.dart';
import 'package:nbtour/helper/image_helper.dart';
import 'package:nbtour/main.dart';
import 'package:nbtour/models/tour_model.dart';
import 'package:nbtour/screens/tour_guide/tour_detail_screen.dart';
import 'package:nbtour/services/tour_service.dart';
import 'package:nbtour/widgets/tour_list_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/schedule_model.dart';
import '../../services/schedule_service.dart';

String userId = '';
String tourId = '';
late Schedules scheduleTour;

class TourGuideTourScreen extends StatefulWidget {
  const TourGuideTourScreen({super.key});
  @override
  State<TourGuideTourScreen> createState() => _TourGuideTourScreenState();
}

class _TourGuideTourScreenState extends State<TourGuideTourScreen> {
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

  Widget loadScheduledTour() {
    return FutureBuilder<List<Schedules>?>(
      future: ScheduleService.getScheduleToursByUserId(userId),
      builder:
          (BuildContext context, AsyncSnapshot<List<Schedules>?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: Padding(
            padding: EdgeInsets.only(top: kMediumPadding),
            child: CircularProgressIndicator(),
          ));
        } else if (snapshot.hasData) {
          List<Schedules>? listScheduledTour = snapshot.data!;

          print(listScheduledTour);
          if (listScheduledTour.isNotEmpty) {
            return Column(
              children: [
                const SizedBox(
                  height: kDefaultPadding / 5,
                ),
                for (var i = 0; i < listScheduledTour.length; i++)
                  TourListWidget(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => TourGuideTourDetailScreen(
                                      scheduleTour: listScheduledTour[i],
                                    )));
                      },
                      announcementImage: ImageHelper.loadFromAsset(
                          AssetHelper.announcementImage,
                          width: kMediumPadding * 3,
                          height: kMediumPadding * 5),
                      // announcementImage: Image.network(),
                      title: listScheduledTour[i].scheduleTour!.tourName!,
                      departureDate: listScheduledTour[i]
                          .scheduleTour!
                          .departureDate!
                          .toString(),
                      departureStation:
                          listScheduledTour[i].scheduleBus!.busPlate!),
                const SizedBox(
                  height: kDefaultPadding / 2,
                ),
              ],
            );
          } else {
            return const Text('No schedules found.');
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
          scrolledUnderElevation: 0,
          title: Text(
            'Tour Screen',
            style: TextStyles.defaultStyle.bold.fontHeader,
          ),
          backgroundColor: Colors.white,
          actions: <Widget>[
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.search_outlined,
                  color: Colors.black,
                )),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.menu,
                  color: Colors.black,
                )),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              loadScheduledTour(),
            ],
          ),
        ));
  }
}
