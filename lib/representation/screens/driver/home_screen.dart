import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nbtour/main.dart';
import 'package:nbtour/representation/screens/request_screen.dart';
import 'package:nbtour/representation/screens/schedule_screen.dart';
import 'package:nbtour/representation/screens/tour_detail_screen.dart';
import 'package:nbtour/services/api/tour_service.dart';
import 'package:nbtour/services/models/tour_model.dart';
import 'package:nbtour/utils/constant/dimension.dart';
import 'package:nbtour/utils/constant/text_style.dart';

import 'package:nbtour/utils/helper/asset_helper.dart';
import 'package:nbtour/utils/helper/image_helper.dart';
import 'package:nbtour/representation/screens/driver/tour_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:nbtour/representation/widgets/action_category_widget.dart';
import 'package:nbtour/representation/widgets/announcement_widget.dart';
import 'package:nbtour/representation/widgets/main_drawer.dart';

import 'package:shared_preferences/shared_preferences.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  String avatar = '';
  String userName = '';
  OverlayEntry? entry;
  Timer? timer;
  bool isCircle = false;
  Offset offset = const Offset(14, 610);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserName();
    fetchUserAvatar();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      checkRunningStatus();
    });
  }

  Future<void> checkRunningStatus() async {
    if (sharedPreferences.getString("isRunning") != null) {
      bool isRunning = bool.parse(sharedPreferences.getString("isRunning")!);
      print(isRunning);

      setState(() {
        if (isRunning) {
          print('isRunning = true');
          showRunningTourOverlay();
        } else {
          print('isRunning = false');
          hideOverlay();
        }
      });
    }
  }

  Future<void> fetchUserName() async {
    final prefs = await SharedPreferences.getInstance();
    String? fetchUserName = prefs.getString('user_name');
    if (fetchUserName != null) {
      setState(() {
        userName = fetchUserName;
      });
    }
  }

  void hideOverlay() {
    print('hide function');
    if (entry != null) {
      entry?.remove();
      entry = null;
      print('OverlayEntry removed');
    }
  }

  void showRunningTourOverlay() {
    print('show function');
    if (entry == null) {
      entry = OverlayEntry(
        builder: (context) => isCircle
            ? Positioned(
                left: offset.dx,
                top: offset.dy,
                child: GestureDetector(
                    onPanUpdate: (details) {
                      final Size screenSize = MediaQuery.of(context).size;

                      // Calculate the new position of the overlay
                      double newLeft = offset.dx + details.delta.dx;
                      double newTop = offset.dy + details.delta.dy;

                      // Calculate the bounds to ensure the overlay stays within the screen
                      double maxWidth = screenSize.width - kMediumPadding / 2;
                      double maxHeight = screenSize.height - 70;

                      // Limit the movement within the bounds
                      newLeft = newLeft.clamp(
                          -(maxWidth - kMediumPadding / 2) / 2,
                          (maxWidth - kMediumPadding / 2) / 2);
                      newTop = newTop.clamp(0, maxHeight);

                      // Update the offset
                      offset = Offset(newLeft, newTop);

                      // Rebuild the overlay
                      entry!.markNeedsBuild();
                    },
                    onLongPress: () {
                      setState(() {
                        isCircle = !isCircle;
                        // Update the existing overlay entry
                        entry!.markNeedsBuild();
                      });
                    },
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          fixedSize: Size(
                              MediaQuery.of(context).size.width -
                                  kMediumPadding / 2,
                              70)),
                      onPressed: () async {
                        String tourId =
                            sharedPreferences.getString("running_tour_id") ??
                                '';
                        var tour = await TourService.getTourByTourId(tourId);
                        if (tour != null) {
                          if (context.mounted) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) =>
                                    TourDetailScreen(scheduleTour: tour)));
                          }
                        }
                      },
                      child: Lottie.asset(
                        'assets/animations/loading.json',
                        height: kMediumPadding * 3,
                        width: kMediumPadding * 3,
                      ),
                    )),
              )
            : Positioned(
                left: 6,
                right: 6,
                bottom: 60,
                child: GestureDetector(
                  onLongPress: () {
                    setState(() {
                      isCircle = !isCircle;
                      // Update the existing overlay entry
                      entry!.markNeedsBuild();
                    });
                  },
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        fixedSize: Size(
                            MediaQuery.of(context).size.width - kMediumPadding,
                            70)),
                    onPressed: () async {
                      String tourId =
                          sharedPreferences.getString("running_tour_id") ?? '';
                      var tour = await TourService.getTourByTourId(tourId);
                      if (tour != null) {
                        if (context.mounted) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) =>
                                  TourDetailScreen(scheduleTour: tour)));
                        }
                      }
                    },
                    child: Row(
                      children: [
                        const SizedBox(
                          width: kDefaultIconSize / 2,
                        ),
                        Lottie.asset(
                          'assets/animations/loading.json',
                          height: kMediumPadding * 3,
                          width: kMediumPadding * 3,
                        ),
                        const SizedBox(
                          width: kDefaultIconSize / 2,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Đang trên đường di chuyển',
                              style: TextStyles.defaultStyle.bold,
                            ),
                            const SizedBox(
                              height: kDefaultIconSize / 2,
                            ),
                            Flexible(
                              child: Text(
                                sharedPreferences
                                        .getString('running_tour_name') ??
                                    "",
                                style: TextStyles.defaultStyle,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      );
      final overlay = Overlay.of(context);
      overlay.insert(entry!);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if the current route is not an instance of DriverHomeScreen
    if (ModalRoute.of(context)?.settings.arguments != this) {
      hideOverlay();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    hideOverlay();
    entry?.dispose();
    super.dispose();
  }

  Future<void> fetchUserAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    String? fetchUserAvatar = prefs.getString('avatar');
    if (fetchUserAvatar != null) {
      setState(() {
        avatar = fetchUserAvatar;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      drawer: MainDrawer(
        userName: userName,
        avatar: avatar,
        onSelectScreen: (ex) {},
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool isScrolled) {
          return [
            SliverAppBar(
              title: Center(
                child: Column(
                  children: [
                    const Text(
                      'Xin chào',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(sharedPreferences.getString('user_name') ?? '',
                        style: const TextStyle(fontSize: 16))
                  ],
                ),
              ),
              iconTheme: const IconThemeData(color: Colors.white),
              actions: <Widget>[
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.notifications,
                    color: Colors.white,
                  ),
                )
              ],
            )
          ];
        },
        floatHeaderSlivers: true,
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: screenWidth - kItemPadding * 2,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(kDefaultPadding),
                          bottomRight: Radius.circular(kDefaultPadding)),
                    ),
                    padding: const EdgeInsets.all(kDefaultPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ActionCategoryWidget(
                            count: 0,
                            icon: const Icon(
                              Icons.calendar_month_outlined,
                              size: kDefaultIconSize * 1.2,
                              color: Colors.white,
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (ctx) => ScheduleScreen(
                                      initDate: DateTime.now())));
                            },
                            title: 'View Schedule'),
                        const SizedBox(width: kItemPadding / 1.5),
                        ActionCategoryWidget(
                            count: 0,
                            icon: const Icon(
                              FontAwesomeIcons.clipboard,
                              size: kDefaultIconSize * 1.2,
                              color: Colors.white,
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const RequestScreen(),
                                  ));
                            },
                            title: 'Your Request'),
                        const SizedBox(width: kItemPadding / 1.5),
                        ActionCategoryWidget(
                            count: 0,
                            icon: const Icon(
                              Icons.work_history_outlined,
                              size: kDefaultIconSize * 1.2,
                              color: Colors.white,
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) =>
                                          const DriverTourScreen()));
                            },
                            title: 'Your Activity'),
                        const SizedBox(width: kItemPadding / 1.5),
                        ActionCategoryWidget(
                            count: 0,
                            icon: const Icon(
                              Icons.history_outlined,
                              size: kDefaultIconSize * 1.2,
                              color: Colors.white,
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) =>
                                          const DriverTourScreen()));
                            },
                            title: 'Tour History'),
                        const SizedBox(width: kItemPadding / 1.5),
                        ActionCategoryWidget(
                            count: 0,
                            icon: const Icon(
                              Icons.qr_code_scanner,
                              size: kDefaultIconSize * 1.2,
                              color: Colors.white,
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) =>
                                          const DriverTourScreen()));
                            },
                            title: 'QR Scanner'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: kMediumPadding / 2),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  child: Text('Announcement',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                ),
                const SizedBox(height: kMediumPadding / 2),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      AnnouncementWidget(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) =>
                                  ScheduleScreen(initDate: DateTime.now())));
                        },
                        announcementImage: ImageHelper.loadFromAsset(
                            AssetHelper.announcementImage),
                        title: 'International Band Museum312312321312',
                        author: 'Nhan Nguyen',
                        dateOfPublic: '15/09/2023',
                      ),
                      AnnouncementWidget(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) =>
                                  ScheduleScreen(initDate: DateTime.now())));
                        },
                        announcementImage: ImageHelper.loadFromAsset(
                            AssetHelper.announcementImage),
                        title: 'International Band Museum312312321312',
                        author: 'Nhan Nguyen',
                        dateOfPublic: '15/09/2023',
                      ),
                      AnnouncementWidget(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) =>
                                  ScheduleScreen(initDate: DateTime.now())));
                        },
                        announcementImage: ImageHelper.loadFromAsset(
                            AssetHelper.announcementImage),
                        title: 'International Band Museum312312321312',
                        author: 'Nhan Nguyen',
                        dateOfPublic: '15/09/2023',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: kMediumPadding / 2),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  child: Text('New Product',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                ),
                const SizedBox(height: kMediumPadding / 2),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      AnnouncementWidget(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) =>
                                  ScheduleScreen(initDate: DateTime.now())));
                        },
                        announcementImage:
                            ImageHelper.loadFromAsset(AssetHelper.productImage),
                        title: 'International Band Museum312312321312',
                        author: 'Nhan Nguyen',
                        dateOfPublic: '15/09/2023',
                      ),
                      AnnouncementWidget(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) =>
                                  ScheduleScreen(initDate: DateTime.now())));
                        },
                        announcementImage:
                            ImageHelper.loadFromAsset(AssetHelper.productImage),
                        title: 'International Band Museum312312321312',
                        author: 'Nhan Nguyen',
                        dateOfPublic: '15/09/2023',
                      ),
                      AnnouncementWidget(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) =>
                                  ScheduleScreen(initDate: DateTime.now())));
                        },
                        announcementImage: Container(
                            child: ImageHelper.loadFromAsset(
                                AssetHelper.productImage)),
                        title: 'International Band Museum312312321312',
                        author: 'Nhan Nguyen',
                        dateOfPublic: '15/09/2023',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: kMediumPadding),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
