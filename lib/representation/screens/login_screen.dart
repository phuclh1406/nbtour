// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nbtour/services/api/auth_service.dart';
import 'package:nbtour/utils/constant/colors.dart';
import 'package:nbtour/utils/constant/dimension.dart';
import 'package:nbtour/utils/constant/text_style.dart';
import 'package:nbtour/utils/helper/asset_helper.dart';
import 'package:nbtour/utils/helper/image_helper.dart';
import 'package:nbtour/representation/screens/tab_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nbtour/representation/widgets/button_widget/button_widget.dart';
import 'package:nbtour/representation/widgets/button_widget/button_with_icon_widget.dart';
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
      if (roleName == 'TourGuide' || roleName == 'Driver') {
        Navigator.push(
            context, MaterialPageRoute(builder: (ctx) => const TabsScreen()));
      } else {
        AuthServices().googleSignOut();
        final prefs = await SharedPreferences.getInstance();
        prefs.clear();
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Tài khoản này chưa được cấp phép truy cập vào hệ thống')));
      }
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Địa chỉ email không hợp lệ hoặc không đúng')));
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  Text('Đăng nhập',
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
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email_outlined),
                        prefixIconColor:
                            const Color.fromARGB(255, 112, 111, 111),
                        hintText: 'phuclh1406@gmail.com',
                        hintStyle: TextStyles.defaultStyle.subTitleTextColor,
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 246, 243, 243)),
                            borderRadius: BorderRadius.all(
                                Radius.circular(kMediumPadding / 2.5))),
                        focusedBorder: const OutlineInputBorder(
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
                          return 'Địa chỉ email không hợp lệ';
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
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        prefixIconColor:
                            const Color.fromARGB(255, 112, 111, 111),
                        hintText: 'Mật khẩu của bạn',
                        hintStyle: TextStyles.defaultStyle.subTitleTextColor,
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 246, 243, 243)),
                            borderRadius: BorderRadius.all(
                                Radius.circular(kMediumPadding / 2.5))),
                        focusedBorder: const OutlineInputBorder(
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
                          return 'Mật khẩu phải có ít nhất 6 kí tự';
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
                            'Quên mật khẩu?',
                            style: TextStyles.defaultStyle,
                          )),
                    ],
                  ),
                  const SizedBox(height: kMediumPadding / 5),
                  ButtonWidget(
                    isIcon: false,
                    title: 'Đăng nhập',
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
              title: 'Đăng nhập bằng Google',
              ontap: () async {
                final signInSuccessful =
                    await AuthServices().signInWithGoogle();
                if (signInSuccessful) {
                  String roleName = await getUser();
                  if (roleName == 'TourGuide' || roleName == 'Driver') {
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
