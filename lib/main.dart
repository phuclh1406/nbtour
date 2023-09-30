import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:nbtour/constant/colors.dart';
import 'package:nbtour/constant/dimension.dart';
import 'package:nbtour/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

late SharedPreferences sharedPreferences;
final theme = ThemeData(
    useMaterial3: true,
    dividerColor: Colors.white,
    textTheme: GoogleFonts.latoTextTheme(),
    appBarTheme: const AppBarTheme(
        color: ColorPalette.primaryColor,
        titleTextStyle:
            TextStyle(color: Colors.white, fontSize: kMediumPadding)));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  sharedPreferences = await SharedPreferences.getInstance();

  await dotenv.load(fileName: "assets/config/.env");

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}
