import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nbtour/constant/colors.dart';
import 'package:nbtour/constant/dimension.dart';
import 'package:nbtour/screens/login_screen.dart';
import 'package:nbtour/screens/qr_scanner.dart';
import 'package:nbtour/screens/splash_screen.dart';
import 'package:nbtour/screens/tab_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final theme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: ColorPalette.primaryColor,
    ),
    dividerTheme: const DividerThemeData(color: Colors.transparent),
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
