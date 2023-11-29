import 'package:flutter/material.dart';
import 'package:nbtour/utils/constant/dimension.dart';
import 'package:nbtour/utils/helper/asset_helper.dart';
import 'package:nbtour/utils/helper/image_helper.dart';

class ButtonLogoWidget extends StatelessWidget {
  const ButtonLogoWidget({
    super.key,
    required this.title,
    required this.ontap,
    required this.color,
    required this.textStyle,
  });

  final String title;
  final void Function() ontap;
  final Color color;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: ontap,
      child: Stack(children: [
        Container(
          width: width - kMediumPadding,
          padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: const Color.fromARGB(148, 0, 0, 0)),
            color: color,
          ),
          alignment: Alignment.center,
          child: Text(title, style: textStyle),
        ),
        Positioned(
            top: kDefaultPadding / 2,
            right: width / 2 + kMediumPadding * 3.5,
            child: ImageHelper.loadFromAsset(AssetHelper.googleLogo,
                width: kDefaultIconSize * 2, fit: BoxFit.fitWidth)),
      ]),
    );
  }
}
