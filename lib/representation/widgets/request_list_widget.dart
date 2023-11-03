import 'package:flutter/material.dart';
import 'package:nbtour/utils/constant/colors.dart';
import 'package:nbtour/utils/constant/dimension.dart';

class RequestListWidget extends StatelessWidget {
  const RequestListWidget({
    Key? key,
    required this.onTap,
    required this.announcementImage,
    required this.name,
    required this.email,
    required this.tour,
  }) : super(key: key);

  final void Function() onTap;
  final Widget announcementImage;
  final String name;
  final String email;
  final String tour;

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
                          tour,
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
                        tour != ""
                            ? Row(
                                children: [
                                  const Icon(
                                    Icons.person_outline,
                                    size: kDefaultIconSize,
                                    color: ColorPalette.primaryColor,
                                  ),
                                  const SizedBox(width: kDefaultIconSize / 2),
                                  Text(
                                    name,
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
                                ),
                              ),
                        const SizedBox(
                          height: kDefaultPadding / 2,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.email_outlined,
                              size: kDefaultIconSize,
                              color: ColorPalette.primaryColor,
                            ),
                            const SizedBox(
                              width: kDefaultIconSize / 2,
                            ),
                            Flexible(
                              child: Text(
                                email != "" ? email : "Not defined",
                                style: const TextStyle(
                                  fontSize: 15,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: kDefaultIconSize / 2,
                            ),
                          ],
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
