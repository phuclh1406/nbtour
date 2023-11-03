import 'package:flutter/material.dart';
import 'package:nbtour/utils/constant/colors.dart';
import 'package:nbtour/utils/constant/dimension.dart';
import 'package:nbtour/utils/constant/text_style.dart';

import 'package:timeline_tile/timeline_tile.dart';

class TimelinesWidget extends StatelessWidget {
  const TimelinesWidget(
      {super.key,
      required this.isFirst,
      required this.stationName,
      required this.stationDescription,
      required this.isLast,
      required this.isPast});
  final bool isFirst;
  final bool isLast;
  final String stationName;
  final String stationDescription;
  final bool isPast;

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      isFirst: isFirst,
      isLast: isLast,
      beforeLineStyle: LineStyle(
          color: isPast
              ? ColorPalette.primaryColor
              : const Color.fromARGB(255, 228, 226, 226)),
      indicatorStyle: IndicatorStyle(
          width: 20,
          color: isPast
              ? ColorPalette.primaryColor
              : const Color.fromARGB(255, 228, 226, 226)),
      endChild: Container(
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              stationName,
              style: TextStyles.defaultStyle.bold,
            ),
            const SizedBox(
              height: kDefaultIconSize / 2,
            ),
            Text(
              stationDescription,
              style: TextStyles.defaultStyle,
            ),
          ],
        ),
      ),
    );
  }
}
