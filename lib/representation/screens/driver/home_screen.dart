import 'package:flutter/material.dart';
import 'package:nbtour/utils/constant/dimension.dart';

import 'package:nbtour/utils/helper/asset_helper.dart';
import 'package:nbtour/utils/helper/image_helper.dart';
import 'package:nbtour/representation/screens/driver/schedule_screen.dart';
import 'package:nbtour/representation/screens/driver/tour_screen.dart';

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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserName();
    fetchUserAvatar();
  }

  Future<void> fetchUserName() async {
    final prefs = await SharedPreferences.getInstance();
    String? fetchUserName = prefs.getString('user_name');
    if (fetchUserName != null) {
      setState(() {
        userName = fetchUserName;
      });
    }
    ;
  }

  Future<void> fetchUserAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    String? fetchUserAvatar = prefs.getString('avatar');
    if (fetchUserAvatar != null) {
      setState(() {
        avatar = fetchUserAvatar;
      });
    }
    ;
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
                            icon: const Icon(
                              Icons.shopping_cart_checkout_outlined,
                              size: kDefaultIconSize * 1.2,
                              color: Colors.white,
                            ),
                            onTap: () {},
                            title: 'Sell Products'),
                        const SizedBox(width: kItemPadding / 1.5),
                        ActionCategoryWidget(
                            icon: const Icon(
                              Icons.calendar_month_outlined,
                              size: kDefaultIconSize * 1.2,
                              color: Colors.white,
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const DriverScheduleScreen(),
                                  ));
                            },
                            title: 'Your Schedule'),
                        const SizedBox(width: kItemPadding / 1.5),
                        ActionCategoryWidget(
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
                            icon: const Icon(
                              Icons.history_outlined,
                              size: kDefaultIconSize * 1.2,
                              color: Colors.white,
                            ),
                            onTap: () {},
                            title: 'Tour History'),
                        const SizedBox(width: kItemPadding / 1.5),
                        ActionCategoryWidget(
                            icon: const Icon(
                              Icons.qr_code_scanner,
                              size: kDefaultIconSize * 1.2,
                              color: Colors.white,
                            ),
                            onTap: () {},
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
                        onTap: () {},
                        announcementImage: ImageHelper.loadFromAsset(
                            AssetHelper.announcementImage),
                        title: 'International Band Museum312312321312',
                        author: 'Nhan Nguyen',
                        dateOfPublic: '15/09/2023',
                      ),
                      AnnouncementWidget(
                        onTap: () {},
                        announcementImage: ImageHelper.loadFromAsset(
                            AssetHelper.announcementImage),
                        title: 'International Band Museum312312321312',
                        author: 'Nhan Nguyen',
                        dateOfPublic: '15/09/2023',
                      ),
                      AnnouncementWidget(
                        onTap: () {},
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
                        onTap: () {},
                        announcementImage:
                            ImageHelper.loadFromAsset(AssetHelper.productImage),
                        title: 'International Band Museum312312321312',
                        author: 'Nhan Nguyen',
                        dateOfPublic: '15/09/2023',
                      ),
                      AnnouncementWidget(
                        onTap: () {},
                        announcementImage:
                            ImageHelper.loadFromAsset(AssetHelper.productImage),
                        title: 'International Band Museum312312321312',
                        author: 'Nhan Nguyen',
                        dateOfPublic: '15/09/2023',
                      ),
                      AnnouncementWidget(
                        onTap: () {},
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
