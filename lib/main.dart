import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart';
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
    useMaterial3: true,
    bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.white, modalBackgroundColor: Colors.white),
    dividerColor: Colors.white,
    textTheme: GoogleFonts.latoTextTheme(),
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
    sharedPreferences = await SharedPreferences.getInstance();
    String? roleName = sharedPreferences.getString('role_name');
    if (roleName != null) {
      if (roleName == "Driver") {
        if (sharedPreferences.getString('tracking_tour_id') != null) {
          Timer.periodic(const Duration(seconds: 5), (Timer t) {
            checkLocation();
            checkLocationCoordinates();
          });
        }
      }
    }

    await dotenv.load(fileName: "assets/config/.env");
    runApp(const App());
  } catch (e) {
    "error";
  }
}

void checkLocationCoordinates() async {
  try {
    var location = await Geolocator.getCurrentPosition();
    var tourId = sharedPreferences.getString('tracking_tour_id')!;
    print('tracking 1');
    Tracking? tracking = await TrackingServices.getTrackingByTourId(tourId);
    if (tracking != null) {
      print('tracking2 ');
      await TrackingServices.updateTrackingWithCoordinates(tracking.trackingId!,
          location.latitude, location.longitude, "Active");
    } else {
      await TrackingServices.trackingWithCoordinates(
          tourId, location.latitude, location.longitude, "Active");
    }
  } catch (e) {
    "Error";
  }
}

void checkLocation() async {
  try {
    var location = await Geolocator.getCurrentPosition();
    String tourId = sharedPreferences.getString('tracking_tour_id')!;

    List<TrackingStations>? trackingList =
        await TrackingServices.getTrackingStationsByTourId(tourId);

    for (var i = 0; i < trackingList!.length; i++) {
      if (trackingList[i].tourDetail!.tourStatus == "Started") {
        if (i <= 0
            ? trackingList[i].status == "NotArrived"
            : trackingList[i - 1].status == "Arrived") {
          double distance = Geolocator.distanceBetween(
              double.parse(trackingList[i].tourDetailStation!.latitude!),
              double.parse(trackingList[i].tourDetailStation!.longitude!),
              location.latitude,
              location.longitude);

          if (distance <= 50) {
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
