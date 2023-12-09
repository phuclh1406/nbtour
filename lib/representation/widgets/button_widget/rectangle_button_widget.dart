import 'package:flutter/material.dart';

import 'package:nbtour/utils/constant/dimension.dart';

class RectangleButtonWidget extends StatelessWidget {
  const RectangleButtonWidget(
      {super.key,
      required this.width,
      required this.title,
      required this.ontap,
      required this.buttonColor,
      required this.textStyle,
      required this.isIcon,
      required this.borderColor,
      required this.icon});

  final double width;
  final String title;
  final void Function() ontap;
  final Color buttonColor;
  final Icon icon;
  final Color borderColor;
  final TextStyle textStyle;
  final bool isIcon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: const Color.fromARGB(255, 220, 216, 216),
      onTap: ontap,
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: buttonColor,
            border: Border.all(color: borderColor)),
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kMediumPadding / 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isIcon) icon,
              const SizedBox(width: kDefaultIconSize / 2),
              Text(title, style: textStyle),
            ],
          ),
        ),
      ),
    );
  }
}
