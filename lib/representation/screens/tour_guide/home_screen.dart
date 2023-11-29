import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nbtour/main.dart';
import 'package:nbtour/representation/screens/notification_list_screen.dart';
import 'package:nbtour/representation/screens/sent_request.dart';
import 'package:nbtour/representation/screens/send_report_screen.dart';
import 'package:nbtour/services/api/form_service.dart';
import 'package:nbtour/services/api/notification_service.dart';
import 'package:nbtour/services/models/notification.dart';
import 'package:nbtour/services/models/reschedule_form_model.dart';
import 'package:nbtour/utils/constant/dimension.dart';
import 'package:nbtour/utils/constant/text_style.dart';
import 'package:nbtour/utils/helper/asset_helper.dart';
import 'package:nbtour/utils/helper/image_helper.dart';
import 'package:nbtour/representation/screens/login_screen.dart';
import 'package:nbtour/representation/screens/request_screen.dart';
import 'package:nbtour/representation/screens/schedule_screen.dart';
import 'package:nbtour/representation/screens/tour_guide/tour_screen.dart';
import 'package:nbtour/representation/widgets/action_category_widget.dart';
import 'package:nbtour/representation/widgets/announcement_widget.dart';
import 'package:nbtour/representation/widgets/main_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TourGuideHomeScreen extends StatefulWidget {
  const TourGuideHomeScreen({super.key});

  @override
  State<TourGuideHomeScreen> createState() => _TourGuideHomeScreenState();
}

class _TourGuideHomeScreenState extends State<TourGuideHomeScreen> {
  String avatar = '';
  String userName = '';

  int notiCount = 0;
  int formCount = 0;
  String userId = sharedPreferences.getString("user_id")!;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserName();
    fetchUserAvatar();

    fetchNotification(userId);
    fetchIncomingRequest(userId);
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

  Future<void> fetchUserAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    String? fetchUserAvatar = prefs.getString('avatar');
    if (fetchUserAvatar != null) {
      setState(() {
        avatar = fetchUserAvatar;
      });
    }
  }

  void openAddExpenseOverlay() {
    showModalBottomSheet(
      showDragHandle: true,
      elevation: 0,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: const SendReportScreen()),
    );
  }

  Future<void> fetchNotification(String userId) async {
    List<NotificationModel>? notiList =
        await NotificationServices.getNotificationList(userId);
    if (notiList!.isNotEmpty) {
      setState(() {
        notiCount = notiList.length;
      });
    }
  }

  Future<void> fetchIncomingRequest(String userId) async {
    List<RescheduleForm>? formList =
        await RescheduleServices.getFormList(userId);

    if (formList!.isNotEmpty) {
      List<RescheduleForm> pendingForms =
          formList.where((form) => form.status == "Pending").toList();
      print(pendingForms.length);
      setState(() {
        formCount = pendingForms.length;
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
              title: const Center(
                child: Text(
                  'Welcome to NBTour',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              iconTheme: const IconThemeData(color: Colors.white),
              actions: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => const NotificationListScreen()));
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
                            count: formCount,
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
                            title: 'Income Request'),
                        const SizedBox(width: kItemPadding / 1.5),
                        ActionCategoryWidget(
                            count: 0,
                            icon: const Icon(
                              Icons.send_outlined,
                              size: kDefaultIconSize * 1.2,
                              color: Colors.white,
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const SentRequestScreen(),
                                  ));
                            },
                            title: 'Sent Request'),
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
                                          const TourGuideTourScreen()));
                            },
                            title: 'Your Activity'),
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
                                    builder: (context) => const RequestScreen(),
                                  ));
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RequestScreen(),
                              ));
                        },
                        announcementImage: ImageHelper.loadFromAsset(
                            AssetHelper.announcementImage),
                        title: 'International Band Museum312312321312',
                        author: 'Nhan Nguyen',
                        dateOfPublic: '15/09/2023',
                      ),
                      AnnouncementWidget(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RequestScreen(),
                              ));
                        },
                        announcementImage: ImageHelper.loadFromAsset(
                            AssetHelper.announcementImage),
                        title: 'International Band Museum312312321312',
                        author: 'Nhan Nguyen',
                        dateOfPublic: '15/09/2023',
                      ),
                      AnnouncementWidget(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RequestScreen(),
                              ));
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RequestScreen(),
                              ));
                        },
                        announcementImage:
                            ImageHelper.loadFromAsset(AssetHelper.productImage),
                        title: 'International Band Museum312312321312',
                        author: 'Nhan Nguyen',
                        dateOfPublic: '15/09/2023',
                      ),
                      AnnouncementWidget(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RequestScreen(),
                              ));
                        },
                        announcementImage:
                            ImageHelper.loadFromAsset(AssetHelper.productImage),
                        title: 'International Band Museum312312321312',
                        author: 'Nhan Nguyen',
                        dateOfPublic: '15/09/2023',
                      ),
                      AnnouncementWidget(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RequestScreen(),
                              ));
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
