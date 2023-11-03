import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nbtour/utils/constant/colors.dart';
import 'package:nbtour/utils/constant/dimension.dart';

class UserListWidget extends StatelessWidget {
  const UserListWidget({
    Key? key,
    required this.onTap,
    required this.announcementImage,
    required this.title,
    required this.email,
    required this.departureStation,
    required this.color,
    required this.code,
  }) : super(key: key);

  final void Function() onTap;
  final Widget announcementImage;
  final String title;
  final String email;
  final String departureStation;
  final Color color;
  final String code;

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
                color: color,
                // color: const Color.fromARGB(255, 255, 255, 255),
                // color: const Color.fromARGB(113, 38, 207, 44),
                borderRadius: BorderRadius.circular(kItemPadding),
                boxShadow: const [
                  BoxShadow(
                      blurRadius: 20.0,
                      color: Color.fromARGB(255, 243, 241, 241)),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
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
                          height: kDefaultPadding / 4,
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
                          height: kDefaultPadding / 4,
                        ),
                        departureStation != ""
                            ? Row(
                                children: [
                                  const Icon(FontAwesomeIcons.busSimple,
                                      size: kDefaultIconSize,
                                      color: ColorPalette.primaryColor),
                                  const SizedBox(
                                    width: kDefaultIconSize / 2,
                                  ),
                                  Text(
                                    departureStation,
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
                          height: kDefaultPadding / 4,
                        ),
                        Row(
                          children: [
                            const Icon(Icons.email_outlined,
                                size: kDefaultIconSize,
                                color: ColorPalette.primaryColor),
                            const SizedBox(
                              width: kDefaultIconSize / 2,
                            ),
                            Flexible(
                              child: Text(
                                email != "" ? email : "Not defined",
                                style: const TextStyle(
                                    fontSize: 15,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                            const SizedBox(
                              width: kDefaultIconSize / 2,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: kDefaultPadding / 4,
                        ),
                        Row(
                          children: [
                            const Icon(FontAwesomeIcons.idBadge,
                                size: kDefaultIconSize,
                                color: ColorPalette.primaryColor),
                            const SizedBox(
                              width: kDefaultIconSize / 2,
                            ),
                            Flexible(
                              child: Text(
                                code != "" ? code : "Not defined",
                                style: const TextStyle(
                                    fontSize: 15,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                            const SizedBox(
                              width: kDefaultIconSize / 2,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: kDefaultPadding / 2,
                        )
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
