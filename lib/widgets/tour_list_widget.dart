import 'package:flutter/material.dart';
import 'package:nbtour/constant/colors.dart';
import 'package:nbtour/constant/dimension.dart';

class TourListWidget extends StatelessWidget {
  const TourListWidget({
    Key? key,
    required this.onTap,
    required this.announcementImage,
    required this.title,
    required this.author,
    required this.dateOfPublic,
  }) : super(key: key);

  final void Function() onTap;
  final Widget announcementImage;
  final String title;
  final String author;
  final String dateOfPublic;

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
                  announcementImage,
                  const SizedBox(
                    width: kItemPadding * 2,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: kDefaultPadding,
                        ),
                        Text(
                          author,
                          style: const TextStyle(
                            fontSize: 15,
                            color: ColorPalette.primaryColor,
                          ),
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
                          height: kItemPadding / 2,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_pin,
                              color: ColorPalette.subTitleColor,
                            ),
                            const SizedBox(
                              width: kDefaultIconSize / 5,
                            ),
                            Flexible(
                              child: Text(
                                dateOfPublic,
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: ColorPalette.subTitleColor,
                                    overflow: TextOverflow.ellipsis),
                              ),
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
