import 'package:flutter/material.dart';
import 'package:nbtour/constant/dimension.dart';
import 'package:nbtour/constant/text_style.dart';
import 'package:nbtour/helper/asset_helper.dart';
import 'package:nbtour/helper/image_helper.dart';
import 'package:nbtour/main.dart';
import 'package:nbtour/widgets/tour_list_widget.dart';

class TourGuideTourScreen extends StatelessWidget {
  const TourGuideTourScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Tour Screen',
            style: TextStyles.defaultStyle.bold.fontHeader,
          ),
          backgroundColor: Colors.white,
          actions: <Widget>[
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.search_outlined,
                  color: Colors.black,
                )),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.menu,
                  color: Colors.black,
                )),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: kDefaultPadding / 5,
              ),
              TourListWidget(
                onTap: () {},
                announcementImage: ImageHelper.loadFromAsset(AssetHelper.tour1,
                    width: kMediumPadding * 4, height: kMediumPadding * 6),
                title: 'Farms, Markets and Scenic Rides',
                author: 'Wed, Apr 28 - 5:30 PM',
                dateOfPublic: 'Radius Gallery - Santa Cruz, CA',
              ),
              TourListWidget(
                onTap: () {},
                announcementImage: ImageHelper.loadFromAsset(AssetHelper.tour2,
                    width: kMediumPadding * 4, height: kMediumPadding * 6),
                title: 'Ole Bolle “The Troll” comes to Tualatin Valley!',
                author: 'Sat, May 1 - 2:00 PM',
                dateOfPublic: 'Lot 13 - Oakland, CA',
              ),
              TourListWidget(
                onTap: () {},
                announcementImage: ImageHelper.loadFromAsset(AssetHelper.tour3,
                    width: kMediumPadding * 4, height: kMediumPadding * 6),
                title: 'Farm-to-Table Dinners',
                author: 'Sat, Apr 24 - 1:30 PM',
                dateOfPublic: '53 Bush St - San Francisco, CA',
              ),
              TourListWidget(
                onTap: () {},
                announcementImage: ImageHelper.loadFromAsset(AssetHelper.tour4,
                    width: kMediumPadding * 4, height: kMediumPadding * 6),
                title: 'Tualatin Valley Arts Trail is Here!',
                author: 'Wed, Apr 28 - 5:30 PM',
                dateOfPublic: 'Radius Gallery - Santa Cruz, CA',
              ),
              TourListWidget(
                onTap: () {},
                announcementImage: ImageHelper.loadFromAsset(AssetHelper.tour5,
                    width: kMediumPadding * 4, height: kMediumPadding * 6),
                title: 'Explore Tualatin Valley on Two Wheels',
                author: 'Wed, Apr 28 - 5:30 PM',
                dateOfPublic: 'Radius Gallery - Santa Cruz, CA',
              ),
              TourListWidget(
                onTap: () {},
                announcementImage: ImageHelper.loadFromAsset(AssetHelper.tour6,
                    width: kMediumPadding * 4, height: kMediumPadding * 6),
                title: 'Have a Relaxing Overnight Stay in Tualatin Valley',
                author: 'Wed, Apr 28 - 5:30 PM',
                dateOfPublic: 'Radius Gallery - Santa Cruz, CA',  
              ),
              const SizedBox(
                height: kDefaultPadding / 2,
              ),
            ],
          ),
        ));
  }
}
