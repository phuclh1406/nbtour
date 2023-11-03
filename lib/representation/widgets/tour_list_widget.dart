import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:nbtour/utils/constant/colors.dart';
import 'package:nbtour/utils/constant/dimension.dart';

class TourListWidget extends StatelessWidget {
  const TourListWidget({
    Key? key,
    required this.onTap,
    required this.announcementImage,
    required this.title,
    required this.departureDate,
    required this.startTime,
    required this.endTime,
  }) : super(key: key);

  final void Function() onTap;
  final Widget announcementImage;
  final String title;
  final String departureDate;
  final String startTime;
  final String endTime;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              width: size.width - kMediumPadding,
              margin: const EdgeInsets.symmetric(
                  horizontal: kDefaultPadding / 2,
                  vertical: kDefaultPadding / 4),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(kItemPadding),
                boxShadow: const [
                  BoxShadow(
                      blurRadius: 20.0,
                      color: Color.fromARGB(255, 243, 241, 241)),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(child: announcementImage),
                    ],
                  ),
                  const SizedBox(
                    width: kItemPadding * 2,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: kDefaultPadding / 2,
                        ),
                        Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: kDefaultPadding / 2,
                        ),
                        departureDate != ""
                            ? Row(
                                children: [
                                  const Icon(Icons.calendar_month_outlined,
                                      size: kDefaultIconSize,
                                      color: ColorPalette.primaryColor),
                                  const SizedBox(width: kDefaultIconSize / 2),
                                  Text(
                                    DateFormat.yMMMd()
                                        .format(DateTime.parse(departureDate)),
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              )
                            : const Text(
                                'Not defined',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: ColorPalette.primaryColor,
                                ),
                              ),
                        const SizedBox(
                          height: kDefaultPadding / 2,
                        ),
                        Row(
                          children: [
                            const Icon(
                              FontAwesomeIcons.clock,
                              size: kDefaultIconSize,
                              color: ColorPalette.primaryColor,
                            ),
                            const SizedBox(
                              width: kDefaultIconSize / 2,
                            ),
                            Flexible(
                              child: Text(
                                startTime != ""
                                    ? DateFormat.Hm()
                                        .format(DateTime.parse(startTime))
                                    : "Not defined",
                                style: const TextStyle(
                                    fontSize: 15,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                            const SizedBox(
                              width: kDefaultIconSize / 2,
                            ),
                            const Text(
                              '-',
                              style: TextStyle(
                                  fontSize: 15,
                                  overflow: TextOverflow.ellipsis),
                            ),
                            const SizedBox(
                              width: kDefaultIconSize / 2,
                            ),
                            Flexible(
                              child: Text(
                                endTime != ""
                                    ? DateFormat.Hm()
                                        .format(DateTime.parse(endTime))
                                    : "Not defined",
                                style: const TextStyle(
                                    fontSize: 15,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: kDefaultPadding / 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
