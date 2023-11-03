import 'package:flutter/material.dart';
import 'package:nbtour/utils/constant/dimension.dart';

class ServiceAction extends StatelessWidget {
  const ServiceAction(
      {super.key,
      required this.icon,
      required this.onTap,
      required this.title});

  final Widget icon;
  final Function() onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: kDefaultIconSize * 2,
              height: kDefaultIconSize * 2,
              padding: const EdgeInsets.symmetric(
                vertical: kDefaultIconSize / 3,
              ),
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(kItemPadding)),
              child: icon,
            ),
            const SizedBox(
              height: kItemPadding / 2,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
