import 'package:flutter/material.dart';

import 'package:nbtour/constant/dimension.dart';

class OvalButtonWidget extends StatelessWidget {
  const OvalButtonWidget(
      {super.key,
      required this.title,
      required this.ontap,
      required this.buttonColor,
      required this.textStyle,
      required this.isIcon,
      required this.borderColor,
      required this.icon});

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
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: ontap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kMediumPadding * 3),
            color: buttonColor,
            border: Border.all(color: borderColor)),
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kMediumPadding / 2),
          child: Row(
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
