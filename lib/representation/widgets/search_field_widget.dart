import 'package:flutter/material.dart';
import 'package:nbtour/utils/constant/colors.dart';
import 'package:nbtour/utils/constant/dimension.dart';
import 'package:nbtour/utils/constant/text_style.dart';

class SearchFieldWidget extends StatelessWidget {
  const SearchFieldWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kDefaultPadding * 2.5,
      child: TextField(
        enabled: true,
        autocorrect: false,
        cursorColor: ColorPalette.primaryColor,
        decoration: const InputDecoration(
          hintText: 'Search....',
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: Icon(
              Icons.search_outlined,
              color: Colors.black,
              size: kDefaultIconSize,
            ),
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(
              Radius.circular(
                kItemPadding,
              ),
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: kDefaultIconSize),
        ),
        style: TextStyles.defaultStyle,
        onChanged: (value) {},
        onSubmitted: (String submitValue) {},
      ),
    );
  }
}
