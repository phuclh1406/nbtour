import 'package:flutter/material.dart';
import 'package:nbtour/constant/colors.dart';
import 'package:nbtour/helper/asset_helper.dart';
import 'package:nbtour/helper/image_helper.dart';
import 'package:nbtour/helper/shared_prefs.dart';
import 'package:nbtour/screens/location/turn_by_turn.dart';

Widget reviewRideBottomSheet(
    BuildContext context, String distance, String routeName) {
  // Get source and destination addresses from sharedPreferences
  // String sourceAddress = getSourceAndDestinationPlaceText('source');
  // String destAddress = getSourceAndDestinationPlaceText('destination');

  return Positioned(
    bottom: 0,
    child: SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(routeName,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.black)),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    tileColor: Colors.grey[200],
                    leading: ImageHelper.loadFromAsset(AssetHelper.sportCar),
                    title: const Text('Tour length',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        )),
                    trailing: Text('$distance m',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                ),
                ElevatedButton(
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const TurnByTurn())),
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(20),
                        backgroundColor: ColorPalette.primaryColor),
                    child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Start tour now',
                              style: TextStyle(color: Colors.white)),
                        ])),
              ]),
        ),
      ),
    ),
  );
}
