import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nbtour/main.dart';
import 'package:nbtour/representation/screens/driver/schedule_screen.dart';
import 'package:nbtour/representation/screens/driver/tour_screen.dart';
import 'package:nbtour/representation/screens/login_screen.dart';
import 'package:nbtour/representation/screens/notification_list_screen.dart';
import 'package:nbtour/representation/screens/profile_screen.dart';
import 'package:nbtour/representation/screens/request_screen.dart';
import 'package:nbtour/representation/screens/sent_request.dart';
import 'package:nbtour/representation/screens/tour_detail_screen.dart';
import 'package:nbtour/services/api/auth_service.dart';
import 'package:nbtour/services/api/notification_service.dart';
import 'package:nbtour/services/api/schedule_service.dart';
import 'package:nbtour/services/models/notification.dart';
import 'package:nbtour/services/models/reschedule_form_model.dart';
import 'package:nbtour/utils/constant/colors.dart';
import 'package:nbtour/utils/constant/dimension.dart';
import 'package:nbtour/utils/constant/text_style.dart';
import 'package:nbtour/utils/helper/asset_helper.dart';
import 'package:nbtour/utils/helper/image_helper.dart';
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
  List<NotificationModel> listNoti = [];
  bool isCircle = false;
  Offset offset = const Offset(14, 610);
  int notiCount = 0;
  int formCount = 0;
  String userId = sharedPreferences.getString("user_id")!;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchUserName();
    fetchNotification(userId);
    startTimer();
  }

  Future<void> fetchNotification(String userId) async {
    try {
      List<NotificationModel>? notiList =
          await NotificationServices.getNotificationList(userId);
      if (notiList!.isNotEmpty) {
        notiList.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
        setState(() {
          listNoti = notiList;
          notiCount = notiList.length;
        });
      }
    } catch (e) {
      Text(e.toString());
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      checkRunningStatus();
    });
  }

  Future<void> checkRunningStatus() async {
    try {
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
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> fetchUserName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? fetchUserName = prefs.getString('user_name');
      if (fetchUserName != null) {
        setState(() {
          userName = fetchUserName;
        });
      }
    } catch (e) {
      setState(() {
        userName = 'Minh Huy';
      });
    }
  }

  void hideOverlay() {
    try {
      if (entry != null) {
        entry?.remove();
        entry = null;
        entry?.markNeedsBuild();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void showRunningTourOverlay() {
    try {
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
                          String scheduleId = sharedPreferences
                                  .getString("running_schedule_id") ??
                              '';
                          var schedule =
                              await ScheduleService.getScheduleByScheduleId(
                                  scheduleId);
                          if (schedule != null) {
                            if (context.mounted) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (ctx) => TourDetailScreen(
                                      scheduleTour: schedule)));
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
                              MediaQuery.of(context).size.width -
                                  kMediumPadding,
                              70)),
                      onPressed: () async {
                        String scheduleId = sharedPreferences
                                .getString("running_schedule_id") ??
                            '';
                        var schedule =
                            await ScheduleService.getScheduleByScheduleId(
                                scheduleId);
                        if (schedule != null) {
                          if (context.mounted) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) =>
                                    TourDetailScreen(scheduleTour: schedule)));
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
                          Flexible(
                            child: Column(
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
                                Text(
                                  sharedPreferences
                                          .getString('running_tour_name') ??
                                      "",
                                  style: TextStyles.defaultStyle,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        );
        final overlay = Overlay.of(context);
        overlay.insert(entry!);
      } else {
        entry!.markNeedsBuild();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if the current route is not an instance of DriverDriverHomeScreen
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

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    List imgSrc = [
      "assets/images/incomming_app.png",
      "assets/images/send_app.png",
      "assets/images/calendar.png",
      "assets/images/list.png"
    ];

    List titles = [
      "Đơn đến",
      "Đơn gửi",
      "Xem lịch",
      "Chuyến đi",
    ];
    return Scaffold(
        body: Container(
      color: ColorPalette.primaryColor,
      child: Column(
        children: [
          SizedBox(
              height: height * 0.25,
              width: width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 50, left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            showMenu(
                              color: Colors.white,
                              context: context,
                              elevation: 1,
                              items: [
                                PopupMenuItem(
                                  child: const Text(
                                    'Trang cá nhân',
                                    style: TextStyles.defaultStyle,
                                  ),
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (ctx) =>
                                                const ProfileScreen()));
                                  },
                                ),
                                PopupMenuItem(
                                  child: const Text('Đăng xuất',
                                      style: TextStyles.defaultStyle),
                                  onTap: () {
                                    AuthServices().googleSignOut();
                                    final fcm = FirebaseMessaging.instance;
                                    fcm.deleteToken();

                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen(),
                                        ));
                                    sharedPreferences.clear();
                                  },
                                ),
                              ],
                              position:
                                  const RelativeRect.fromLTRB(0, 0, 0, 100),
                            );
                          },
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(kMediumPadding * 2),
                            child: Image.network(
                              sharedPreferences.getString('avatar') ?? '',
                              height: 50,
                              width: 50,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) =>
                                    const NotificationListScreen()));
                          },
                          icon: notiCount != 0
                              ? Badge(
                                  backgroundColor: Colors.red,
                                  label: Text(notiCount.toString()),
                                  child: const Icon(
                                    Icons.notifications,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(
                                  Icons.notifications,
                                  color: Colors.white,
                                ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 15, left: 15, right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Xin chào nhân viên',
                          style: TextStyles
                              .regularStyle.bold.whiteTextColor.fontHeader,
                        ),
                        const SizedBox(
                          height: kDefaultIconSize / 2,
                        ),
                        Text(
                          sharedPreferences.getString('user_name') ?? '',
                          style: TextStyles.regularStyle.whiteTextColor,
                        )
                      ],
                    ),
                  )
                ],
              )),
          Expanded(
            child: Container(
              height: height * 0.75,
              width: width,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 35, left: 20, right: 15),
                    child: Text(
                      'Danh sách các tác vụ',
                      style: TextStyles.defaultStyle.bold.fontHeader,
                    ),
                  ),
                  GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.1,
                      mainAxisSpacing: 30,
                    ),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          switch (titles[index]) {
                            case "Đơn đến":
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const RequestScreen(),
                                  ));
                              break;
                            case "Đơn gửi":
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const SentRequestScreen(),
                                  ));
                              break;
                            case "Xem lịch":
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const DriverScheduleScreen(),
                                  ));
                              break;
                            case "Chuyến đi":
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const DriverTourScreen(),
                                  ));
                              break;
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black26,
                                    spreadRadius: 1,
                                    blurRadius: 6)
                              ]),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset(imgSrc[index],
                                    width: 100, height: 100),
                                Text(
                                  titles[index],
                                  style: TextStyles.defaultStyle.bold,
                                )
                              ]),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }
}
