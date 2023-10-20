import 'package:flutter/material.dart';

import 'package:nbtour/constant/dimension.dart';

class FilterItem extends StatelessWidget {
  const FilterItem(
      {super.key,
      required this.title,
      required this.backgroundColor,
      required this.titleColor,
      required this.onTap,
      required this.borderColor});

  final String title;
  final Color backgroundColor;
  final Color borderColor;
  final Color titleColor;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        width: kMediumPadding * 3,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.all(kMediumPadding / 2),
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(kMediumPadding / 2),
            border: Border.all(color: borderColor)),
        child: Center(
          child: Text(title,
              style: TextStyle(color: titleColor, fontSize: kDefaultIconSize)),
        ),
      ),
    );
  }
}
