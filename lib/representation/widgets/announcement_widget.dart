import 'package:flutter/material.dart';
import 'package:nbtour/utils/constant/colors.dart';
import 'package:nbtour/utils/constant/dimension.dart';

class AnnouncementWidget extends StatelessWidget {
  const AnnouncementWidget(
      {super.key,
      required this.onTap,
      required this.announcementImage,
      required this.title,
      required this.author,
      required this.dateOfPublic});

  final void Function() onTap;
  // final String announcementImage;
  final Widget announcementImage;
  final String title;
  final String author;
  final String dateOfPublic;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
              padding: const EdgeInsets.symmetric(
                vertical: kDefaultIconSize / 3,
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(kItemPadding)),
              child: Container(
                width: kMediumPadding * 10,
                padding: const EdgeInsets.symmetric(
                    horizontal: kMediumPadding / 2,
                    vertical: kMediumPadding / 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kItemPadding),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(kMediumPadding / 2),
                      child: announcementImage,
                    ),
                    const SizedBox(
                      height: kItemPadding,
                    ),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: kItemPadding,
                    ),
                    Row(
                      children: [
                        const Text(
                          'Author:',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 13,
                              color: ColorPalette.primaryColor,
                              fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          width: kDefaultPadding / 2,
                        ),
                        Text(
                          author,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Date of public:',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 13,
                              color: ColorPalette.subTitleColor,
                              fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          width: kDefaultPadding / 2,
                        ),
                        Text(
                          dateOfPublic,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    )
                  ],
                ),
              )
              // child: Image.network(announcementImage,
              //     width: kMediumPadding * 3, height: kMediumPadding * 2)),

              ),
        ],
      ),
    );
  }
}
