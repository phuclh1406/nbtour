import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nbtour/representation/screens/tour_guide/booking_tour_list_screen.dart';
import 'package:nbtour/representation/screens/report_screen.dart';
import 'package:nbtour/utils/constant/colors.dart';
import 'package:nbtour/representation/screens/driver/home_screen.dart';

import 'package:nbtour/representation/screens/tour_guide/booking_list_screen.dart';
import 'package:nbtour/representation/screens/tour_guide/home_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<RemoteMessage> _messages = [];
  String roleName = '';
  bool isTourGuide = false;
  void setupPushNotification() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    final token = await fcm.getToken();
    print('This is device token $token');
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {
        _messages = [..._messages, message];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    // Fetch roleName from SharedPreferences when the widget is initialized
    setupPushNotification();
    fetchUserRole();
  }

  Future<void> fetchUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    String? fetchedRoleName = prefs.getString('role_name');
    if (fetchedRoleName != null) {
      setState(() {
        roleName = fetchedRoleName;
      });
    }
  }

  int _selectPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectPageIndex = index;
    });
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = const TourGuideHomeScreen();

    if (roleName == 'TourGuide') {
      activePage = const TourGuideHomeScreen();
      isTourGuide = true;
      if (_selectPageIndex == 1) {
        activePage = const BookingListScreen();
      }

      if (_selectPageIndex == 2) {
        activePage = const BookingTourListScreen();
      }

      if (_selectPageIndex == 3) {
        activePage = const ReportScreen();
      }
    } else {
      activePage = const DriverHomeScreen();
      if (_selectPageIndex == 1) {
        activePage = const DriverHomeScreen();
      }
    }

    return Scaffold(
      body: activePage,
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: Visibility(
      //   visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
      //   child: FloatingActionButton(
      //     backgroundColor: ColorPalette.primaryColor,
      //     foregroundColor: Colors.white,
      //     shape: const CircleBorder(),
      //     child: isTourGuide
      //         ? const Icon(FontAwesomeIcons.clipboardList)
      //         : const Icon(Icons.navigation_outlined),
      //     onPressed: () {
      //       if (isTourGuide) {
      //         Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //                 builder: (ctx) => const BookingListScreen()));
      //       } else {
      //         Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //                 builder: (ctx) => const SearchNavigation()));
      //       }
      //     },
      //   ),
      // ),
      bottomNavigationBar: Theme(
        data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          fixedColor: ColorPalette.primaryColor,
          unselectedItemColor: const Color.fromARGB(255, 202, 193, 193),
          onTap: (index) {
            _selectPage(index);
          },
          currentIndex: _selectPageIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Home',
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  FontAwesomeIcons.clipboardList,
                ),
                label: 'Check-in'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.book_online,
                ),
                label: 'Booking tour'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.report_outlined,
                ),
                label: 'Report')
          ],
        ),
      ),
    );
  }
}
