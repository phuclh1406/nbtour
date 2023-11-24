import 'package:flutter/material.dart';
import 'package:nbtour/utils/constant/colors.dart';
import 'package:nbtour/utils/constant/dimension.dart';
import 'package:intl/intl.dart';

class RequestListWidget extends StatelessWidget {
  const RequestListWidget({
    Key? key,
    required this.onTap,
    required this.announcementImage,
    required this.name,
    required this.email,
    required this.tour,
    required this.date,
    required this.status,
  }) : super(key: key);

  final void Function() onTap;
  final Widget announcementImage;
  final String name;
  final String email;
  final String tour;
  final String date;
  final String status;

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
              width: size.width - kMediumPadding / 2,
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
                                  Flexible(
                                    child: Text(
                                      name,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          overflow: TextOverflow.ellipsis),
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
                          height: kDefaultPadding,
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
                        Row(
                          children: [
                            date != ""
                                ? Row(
                                    children: [
                                      const Icon(Icons.calendar_month_outlined,
                                          size: kDefaultIconSize,
                                          color: ColorPalette.primaryColor),
                                      const SizedBox(
                                          width: kDefaultIconSize / 2),
                                      Text(
                                        DateFormat.yMMMd()
                                            .format(DateTime.parse(date)),
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
                              width: kDefaultPadding,
                            ),
                            if (status == "Pending")
                              Container(
                                  margin: const EdgeInsets.only(
                                      top: 10, bottom: 10),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: kDefaultPadding,
                                      vertical: kDefaultPadding / 2),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: const Color.fromARGB(
                                          22, 158, 158, 158)),
                                  child: Text(
                                    status,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700),
                                  )),
                            if (status == "Approved")
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: kDefaultPadding,
                                    vertical: kDefaultPadding / 2),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color:
                                        const Color.fromARGB(24, 76, 175, 79)),
                                child: Text(
                                  status,
                                  style: const TextStyle(
                                      color: Colors.green,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            if (status == "Accepted")
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: kDefaultPadding,
                                    vertical: kDefaultPadding / 2),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color:
                                        const Color.fromARGB(19, 255, 235, 59)),
                                child: Text(
                                  status,
                                  style: const TextStyle(
                                      color: Colors.yellow,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            if (status == "Rejected")
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: kDefaultPadding,
                                    vertical: kDefaultPadding / 2),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color:
                                        const Color.fromARGB(24, 244, 67, 54)),
                                child: Text(
                                  status,
                                  style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            if (status != "Pending" &&
                                status != "Approved" &&
                                status != "Rejected" &&
                                status != "Accepted")
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: kDefaultPadding,
                                    vertical: kDefaultPadding / 2),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color:
                                        const Color.fromARGB(19, 72, 59, 255)),
                                child: const Text(
                                  "Not defined",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            const SizedBox(
                              height: kDefaultIconSize / 2,
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
