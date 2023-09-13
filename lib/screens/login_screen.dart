import 'package:flutter/material.dart';
import 'package:nbtour/constant/colors.dart';
import 'package:nbtour/constant/dimension.dart';
import 'package:nbtour/constant/text_style.dart';
import 'package:nbtour/helper/asset_helper.dart';
import 'package:nbtour/helper/image_helper.dart';
import 'package:nbtour/widgets/button_with_icon.dart';
import 'package:nbtour/widgets/button_widget.dart';
import 'package:nbtour/widgets/input_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromARGB(248, 255, 255, 255),
      body: SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 48, 16, keyboardSpace + 16),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: kMediumPadding / 3),
                  ImageHelper.loadFromAsset(AssetHelper.logo,
                      width: kMediumPadding * 10, fit: BoxFit.fitWidth),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kMediumPadding / 2),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Sign in',
                                style: TextStyles.defaultStyle.fontHeader.bold),
                          ])),
                  const SizedBox(height: kMediumPadding),
                  const InputField(
                    text: 'phuclh1406@gmail.com',
                    icon: Icon(Icons.email_outlined),
                    isSecure: false,
                  ),
                  const SizedBox(height: kMediumPadding),
                  const InputField(
                    text: 'Your Password',
                    icon: Icon(Icons.lock_outline_rounded),
                    isSecure: true,
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
                  const SizedBox(height: kMediumPadding),
                  ButtonWidget(
                    isIcon: true,
                    title: 'SIGN IN',
                    ontap: () {},
                    color: ColorPalette.primaryColor,
                    textStyle: TextStyles.defaultStyle.bold.whiteTextColor,
                  ),
                  const SizedBox(height: kMediumPadding),
                  Text('OR',
                      style:
                          TextStyles.regularStyle.fontHeader.subTitleTextColor),
                  const SizedBox(height: kMediumPadding),
                  ButtonLogoWidget(
                    title: 'Login with Google',
                    ontap: () {},
                    color: Colors.white,
                    textStyle: TextStyles.regularStyle,
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
