import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart';
import 'package:nbtour/services/api/tour_service.dart';
import 'package:nbtour/services/api/tracking_service.dart';
import 'package:nbtour/services/models/tracking_model.dart';
import 'package:nbtour/services/models/tracking_station_model.dart';
import 'package:nbtour/utils/constant/colors.dart';
import 'package:nbtour/utils/constant/dimension.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nbtour/representation/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

late SharedPreferences sharedPreferences;

final theme = ThemeData(
    textSelectionTheme: const TextSelectionThemeData(
        selectionHandleColor: ColorPalette.primaryColor,
        selectionColor: Color.fromARGB(103, 255, 89, 0),
        cursorColor: ColorPalette.primaryColor),
    useMaterial3: true,
    bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.white, modalBackgroundColor: Colors.white),
    dividerColor: Colors.transparent,
    textTheme: GoogleFonts.latoTextTheme(),
    splashColor: Colors.grey,
    highlightColor: Colors.grey,
    appBarTheme: const AppBarTheme(
        color: ColorPalette.primaryColor,
        titleTextStyle:
            TextStyle(color: Colors.white, fontSize: kMediumPadding)));

void initializeLocationAndSave() async {
  // Ensure all permissions are collected for Locations

  Location location = Location();
  bool? serviceEnabled;
  PermissionStatus? permissionGranted;
  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
  }

  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
  }

  // Get the current user location
  LocationData locationData = await location.getLocation();
  // Get the current user address

  // Store the user location in sharedPreferences
  sharedPreferences.setDouble('latitude', locationData.latitude!);
  sharedPreferences.setDouble('longitude', locationData.longitude!);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  try {
    await dotenv.load(fileName: "assets/config/.env");
    runApp(const App());
    Timer.periodic(const Duration(seconds: 3), (timer) {
      fetchLoginUser();
    });
  } catch (e) {
    "error";
  }
}

void fetchLoginUser() async {
  try {
    sharedPreferences = await SharedPreferences.getInstance();
    String? roleName = sharedPreferences.getString('role_name');
    if (roleName != null && roleName == "Driver") {
      String userId = sharedPreferences.getString("user_id")!;
      var tour =
          await TourService.getTourByTourStatusAndDriverId(userId, "Started");

      bool newIsRunning = tour!.isNotEmpty;
      // Only update shared preferences if the value of isRunning changes
      if (newIsRunning) {
        sharedPreferences.setString('isRunning', newIsRunning.toString());
        sharedPreferences.setString('running_tour_name', tour[0].tourName!);
        sharedPreferences.setString('running_tour_id', tour[0].tourId!);
      }

      if (newIsRunning) {
        print('Tour is running, show overlay and start location checks.');
        checkLocation(tour[0].tourId!);
        checkLocationCoordinates(tour[0].tourId!);
      }
    }
  } catch (e) {
    print('Error in fetchLoginUser: $e');
  }
}

void checkLocationCoordinates(String toudId) async {
  try {
    var location = await Geolocator.getCurrentPosition();

    print('tracking 1');
    Tracking? tracking = await TrackingServices.getTrackingByTourId(toudId);
    if (tracking != null) {
      print('tracking2 ');
      await TrackingServices.updateTrackingWithCoordinates(tracking.trackingId!,
          location.latitude, location.longitude, "Active");
    } else {
      await TrackingServices.trackingWithCoordinates(
          toudId, location.latitude, location.longitude, "Active");
    }
  } catch (e) {
    "Error";
  }
}

void checkLocation(String tourId) async {
  try {
    var location = await Geolocator.getCurrentPosition();

    List<TrackingStations>? trackingList =
        await TrackingServices.getTrackingStationsByTourId(tourId) ?? [];

    for (var i = 0; i < trackingList.length; i++) {
      if (trackingList[i].tourDetail!.tourStatus == "Started") {
        if (i <= 0
            ? trackingList[i].status == "NotArrived"
            : trackingList[i - 1].status == "Arrived") {
          double distance = Geolocator.distanceBetween(
              double.parse(trackingList[i].tourDetailStation!.latitude!),
              double.parse(trackingList[i].tourDetailStation!.longitude!),
              location.latitude,
              location.longitude);

          if (distance <= 100) {
            await TrackingServices.trackingStations(
                trackingList[i].tourDetailId!);
          }
        }
      }
    }
  } catch (e) {
    "Error";
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}
