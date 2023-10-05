import 'package:flutter/material.dart';
import 'package:nbtour/constant/colors.dart';
import 'package:nbtour/constant/dimension.dart';
import 'package:nbtour/helper/asset_helper.dart';
import 'package:nbtour/helper/image_helper.dart';
import 'package:nbtour/screens/driver/home_screen.dart';
import 'package:nbtour/screens/location/search_navigation.dart';
import 'package:nbtour/screens/tour_guide/home_screen.dart';
import 'package:nbtour/screens/qr_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  String roleName = '';
  bool isTourGuide = false;

  @override
  void initState() {
    super.initState();
    // Fetch roleName from SharedPreferences when the widget is initialized
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
        activePage = const TourGuideHomeScreen();
      }
    } else {
      activePage = const DriverHomeScreen();
      if (_selectPageIndex == 1) {
        activePage = const DriverHomeScreen();
      }
    }

    return Scaffold(
      body: activePage,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Visibility(
        visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
        child: FloatingActionButton(
          backgroundColor: ColorPalette.primaryColor,
          foregroundColor: Colors.white,
          shape: const CircleBorder(),
          child: isTourGuide
              ? const Icon(Icons.qr_code_scanner)
              : const Icon(Icons.navigation_outlined),
          onPressed: () {
            if (isTourGuide) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (ctx) => const QRScanner()));
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) => const SearchNavigation()));
            }
          },
        ),
      ),
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
                  Icons.calendar_month_rounded,
                ),
                label: 'Schedule')
          ],
        ),
      ),
    );
  }
}
