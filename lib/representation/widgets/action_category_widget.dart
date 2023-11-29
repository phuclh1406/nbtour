import 'package:flutter/material.dart';
import 'package:nbtour/utils/constant/dimension.dart';

class ActionCategoryWidget extends StatelessWidget {
  const ActionCategoryWidget(
      {super.key,
      required this.icon,
      required this.onTap,
      required this.title,
      required this.count});

  final Widget icon;
  final Function() onTap;
  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            count != 0
                ? Badge(
                    backgroundColor: Colors.red,
                    label: Text(count.toString()),
                    child: Container(
                      width: kDefaultIconSize * 2,
                      height: kDefaultIconSize * 2,
                      padding: const EdgeInsets.symmetric(
                          vertical: kDefaultIconSize / 3),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 89, 0),
                          borderRadius: BorderRadius.circular(kItemPadding)),
                      child: icon,
                    ),
                  )
                : Container(
                    width: kDefaultIconSize * 2,
                    height: kDefaultIconSize * 2,
                    padding: const EdgeInsets.symmetric(
                        vertical: kDefaultIconSize / 3),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 89, 0),
                        borderRadius: BorderRadius.circular(kItemPadding)),
                    child: icon,
                  ),
            const SizedBox(
              height: kItemPadding / 2,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
