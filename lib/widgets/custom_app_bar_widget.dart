import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nbtour/constant/colors.dart';
import 'package:nbtour/constant/dimension.dart';
import 'package:nbtour/constant/text_style.dart';
import 'package:nbtour/helper/asset_helper.dart';
import 'package:nbtour/helper/image_helper.dart';
import 'package:nbtour/widgets/button_widget.dart';

class CustomAppBarWidget extends StatelessWidget {
  const CustomAppBarWidget(
      {super.key,
      required this.child,
      this.title,
      this.implementLeading = false,
      this.titleString,
      this.subTitleString,
      this.implementTraling = false});

  final Widget child;
  final Widget? title;
  final String? titleString;
  final String? subTitleString;
  final bool implementLeading;
  final bool implementTraling;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Stack(
        children: [
          ImageHelper.loadFromAsset(AssetHelper.tourImage1,
              width: size.width, fit: BoxFit.fitWidth),
          SizedBox(
            height: 200,
            child: AppBar(
              scrolledUnderElevation: 0,
              centerTitle: true,
              automaticallyImplyLeading: false,
              elevation: 0,
              toolbarHeight: 60,
              backgroundColor: Colors.transparent,
              title: Container(
                child: title ??
                    Row(
                      children: [
                        if (implementLeading)
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  kDefaultPadding,
                                ),
                                color: const Color.fromARGB(158, 255, 255, 255),
                              ),
                              padding: const EdgeInsets.all(14),
                              child: const Icon(
                                FontAwesomeIcons.arrowLeft,
                                size: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        const SizedBox(width: kDefaultIconSize),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    kDefaultPadding,
                                  ),
                                  color:
                                      const Color.fromARGB(158, 255, 255, 255),
                                ),
                                padding: const EdgeInsets.all(kItemPadding),
                                child: Text(
                                  titleString ?? '',
                                  style: TextStyles.defaultStyle.fontHeader,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (implementTraling)
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                kDefaultPadding,
                              ),
                              color: Colors.white,
                            ),
                            padding: const EdgeInsets.all(kItemPadding),
                            child: const Icon(
                              FontAwesomeIcons.bars,
                              size: kDefaultPadding,
                              color: Colors.black,
                            ),
                          ),
                      ],
                    ),
              ),
            ),
          ),
        ],
      ),
      Expanded(
        child: SizedBox(
          height: size.height - kMediumPadding,
          child: child,
        ),
      )
    ]));
  }
}
