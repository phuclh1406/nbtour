// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nbtour/constant/colors.dart';
import 'package:nbtour/constant/dimension.dart';
import 'package:nbtour/constant/text_style.dart';
import 'package:nbtour/helper/asset_helper.dart';
import 'package:nbtour/helper/image_helper.dart';
import 'package:nbtour/screens/tab_screen.dart';
import 'package:nbtour/services/auth_service.dart';
import 'package:nbtour/widgets/button_with_icon_widget.dart';
import 'package:nbtour/widgets/button_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _firebase = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Future<String> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? roleName = prefs.getString('role_name');
    return roleName ?? ''; // Return an empty string if userName is null
  }

  Future<String> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');
    return userId ?? ''; // Return an empty string if userName is null
  }

  final _form = GlobalKey<FormState>();
  var _enteredEmail = '';
  var _enteredPassword = '';
  void _submit(BuildContext context) async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    final signInResult = await AuthServices()
        .signInWithUserNameAndPassword(_enteredEmail, _enteredPassword);

    if (signInResult == 200) {
      String roleName = await getUser();
      String userId = await getUserId();
      print('12312312321321321321321 $roleName');
      if (roleName == 'TourGuild' || roleName == 'Driver') {
        Navigator.push(
            context, MaterialPageRoute(builder: (ctx) => const TabsScreen()));
      } else {
        AuthServices().googleSignOut();
        final prefs = await SharedPreferences.getInstance();
        prefs.clear();
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'This account doesn\'t have permission to access in this application')));
      }
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Email is not existed or password is not correct')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color.fromARGB(248, 255, 255, 255),
      body: SizedBox(
        height: height,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const SizedBox(height: kMediumPadding),
            ImageHelper.loadFromAsset(AssetHelper.logo,
                width: kMediumPadding * 10, fit: BoxFit.fitWidth),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kMediumPadding / 2),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Text('Sign in',
                      style: TextStyles.defaultStyle.fontHeader.bold),
                ])),
            const SizedBox(height: kMediumPadding),
            // const InputField(
            //   text: 'phuclh1406@gmail.com',
            //   icon: Icon(Icons.email_outlined),
            //   isSecure: false,
            // ),
            Form(
              key: _form,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: kMediumPadding / 2),
                    child: TextFormField(
                      cursorColor: ColorPalette.primaryColor,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email_outlined),
                        prefixIconColor: Color.fromARGB(255, 112, 111, 111),
                        hintText: 'phuclh1406@gmail.com',
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 246, 243, 243)),
                            borderRadius: BorderRadius.all(
                                Radius.circular(kMediumPadding / 2.5))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 62, 62, 62)),
                            borderRadius: BorderRadius.all(
                                Radius.circular(kMediumPadding / 2.5))),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            !value.contains('@')) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enteredEmail = value!;
                      },
                    ),
                  ),
                  const SizedBox(height: kMediumPadding),
                  // const InputField(
                  //   text: 'Your Password',
                  //   icon: Icon(Icons.lock_outline_rounded),
                  //   isSecure: true,
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: kMediumPadding / 2),
                    child: TextFormField(
                      cursorColor: ColorPalette.primaryColor,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.lock_outline_rounded),
                        prefixIconColor: Color.fromARGB(255, 112, 111, 111),
                        hintText: 'Your Password',
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 246, 243, 243)),
                            borderRadius: BorderRadius.all(
                                Radius.circular(kMediumPadding / 2.5))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 62, 62, 62)),
                            borderRadius: BorderRadius.all(
                                Radius.circular(kMediumPadding / 2.5))),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.trim().length < 6) {
                          return 'Password must have more than 5 characters';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enteredPassword = value!;
                      },
                    ),
                  ),
                  Row(
                    children: [
                      const Spacer(),
                      TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyles.defaultStyle,
                          )),
                    ],
                  ),
                  const SizedBox(height: kMediumPadding / 5),
                  ButtonWidget(
                    isIcon: true,
                    title: 'SIGN IN',
                    ontap: () {
                      _submit(context);
                    },
                    color: ColorPalette.primaryColor,
                    textStyle: TextStyles.regularStyle.whiteTextColor,
                  ),
                ],
              ),
            ),

            const SizedBox(height: kMediumPadding / 2),
            Text('OR', style: GoogleFonts.lato().subTitleTextColor.bold),
            const SizedBox(height: kMediumPadding / 2),
            ButtonLogoWidget(
              title: 'Login with Google',
              ontap: () async {
                final signInSuccessful =
                    await AuthServices().signInWithGoogle();
                if (signInSuccessful) {
                  String roleName = await getUser();
                  String userId = await getUserId();
                  if (roleName == 'TourGuild' || roleName == 'Driver') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TabsScreen(),
                      ),
                    );
                  } else {
                    AuthServices().googleSignOut();
                    final prefs = await SharedPreferences.getInstance();
                    prefs.clear();
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            'This account doesn\'t have permission to aceess in this application')));
                  }
                } else {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('This account is not existed')));
                }
              },
              color: Colors.white,
              textStyle: TextStyles.regularStyle,
            ),
          ]),
        ),
      ),
    );
  }
}
