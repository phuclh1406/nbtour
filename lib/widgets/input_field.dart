import 'package:flutter/material.dart';
import 'package:nbtour/constant/dimension.dart';

class InputField extends StatelessWidget {
  const InputField(
      {super.key,
      required this.text,
      required this.icon,
      required this.isSecure});

  final String text;
  final Icon icon;
  final bool isSecure;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kMediumPadding / 2),
      child: TextFormField(
        decoration: InputDecoration(
          prefixIcon: icon,
          prefixIconColor: const Color.fromARGB(255, 112, 111, 111),
          hintText: text,
          border: const OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 246, 243, 243)),
              borderRadius:
                  BorderRadius.all(Radius.circular(kMediumPadding / 2.5))),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 62, 62, 62)),
              borderRadius:
                  BorderRadius.all(Radius.circular(kMediumPadding / 2.5))),
        ),
        keyboardType: TextInputType.emailAddress,
        autocorrect: false,
        textCapitalization: TextCapitalization.none,
        obscureText: isSecure,
      ),
    );
  }
}
