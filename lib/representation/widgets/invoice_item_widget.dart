import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nbtour/utils/constant/colors.dart';
import 'package:nbtour/utils/constant/dimension.dart';

class InvoiceItemWidget extends StatelessWidget {
  const InvoiceItemWidget({
    Key? key,
    required this.onTap,
    required this.title,
    required this.price,
    required this.status,
  }) : super(key: key);

  final void Function() onTap;
  final String title;
  final String price;
  final String status;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
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
                children: [
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
                        price != ""
                            ? Row(
                                children: [
                                  const Icon(Icons.price_check,
                                      size: kDefaultIconSize,
                                      color: ColorPalette.primaryColor),
                                  const SizedBox(width: kDefaultIconSize / 2),
                                  Text(
                                    '$price vnđ',
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              )
                            : const Text(
                                '',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: ColorPalette.primaryColor,
                                ),
                              ),
                        const SizedBox(
                          height: kDefaultPadding / 2,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: kDefaultPadding,
                  ),
                  if (status == "Đang chờ")
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding,
                          vertical: kDefaultPadding / 2),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color.fromARGB(22, 158, 158, 158)),
                      child: Text(
                        status,
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                    ),
                  if (status == "Hoàn tất")
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding,
                          vertical: kDefaultPadding / 2),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color.fromARGB(24, 76, 175, 79)),
                      child: Text(
                        status,
                        style: const TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  if (status != "Đang chờ" && status != "Hoàn tất")
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding,
                          vertical: kDefaultPadding / 2),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color.fromARGB(19, 255, 235, 59)),
                      child: const Text(
                        "Not defined",
                        style: TextStyle(
                            color: Colors.yellow,
                            fontSize: 12,
                            fontWeight: FontWeight.w700),
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
