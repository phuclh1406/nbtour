import 'package:flutter/material.dart';
import 'package:nbtour/constant/colors.dart';
import 'package:nbtour/constant/dimension.dart';
import 'package:nbtour/helper/asset_helper.dart';
import 'package:nbtour/helper/image_helper.dart';

class ButtonSelectYearWidget extends StatelessWidget {
  const ButtonSelectYearWidget(
      {super.key,
      required this.title,
      required this.ontap,
      required this.color,
      required this.textStyle,
      required this.isIcon});

  final String title;
  final void Function() ontap;
  final Color color;
  final TextStyle textStyle;
  final bool isIcon;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: ontap,
      child: Stack(children: [
        Container(
          width: kMediumPadding * 3,
          padding: const EdgeInsets.symmetric(vertical: kDefaultPadding * 1.5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kDefaultPadding),
            border: Border.all(color: ColorPalette.subTitleColor),
            color: color,
          ),
          alignment: Alignment.center,
          child: Text(title, style: textStyle),
        ),
        if (isIcon)
          Positioned(
              top: kDefaultPadding + kDefaultIconSize / 6,
              right: kDefaultPadding,
              child: ImageHelper.loadFromAsset(AssetHelper.arrowRightCirlce))
      ]),
    );
  }
}
