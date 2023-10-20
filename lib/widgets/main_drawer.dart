import 'package:flutter/material.dart';
import 'package:nbtour/constant/dimension.dart';
import 'package:nbtour/constant/text_style.dart';

import 'package:nbtour/screens/login_screen.dart';
import 'package:nbtour/services/auth_service.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer(
      {super.key,
      required this.onSelectScreen,
      required this.avatar,
      required this.userName});

  final void Function(String identifier) onSelectScreen;
  final String avatar;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      surfaceTintColor: Colors.white,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        DrawerHeader(
          margin: const EdgeInsets.only(top: kMediumPadding),
          padding: const EdgeInsets.symmetric(horizontal: kMediumPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                // Use ClipRRect to apply the borderRadius to the image
                borderRadius: BorderRadius.circular(kMediumPadding * 2),
                child: Image.network(
                  avatar,
                  width: kMediumPadding * 3,
                  fit: BoxFit.fitWidth,
                ),
              ),
              const SizedBox(height: kMediumPadding / 2),
              Text(userName,
                  style:
                      Theme.of(context).textTheme.titleLarge!.copyWith().bold)
            ],
          ),
        ),
        ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: kMediumPadding),
          leading: Icon(Icons.person_outline,
              size: 26, color: Theme.of(context).colorScheme.onBackground),
          title: Text(
            'My Profile',
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 17,
                ),
          ),
          onTap: () {
            onSelectScreen('meals');
          },
        ),
        ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: kMediumPadding),
          leading: Icon(Icons.message_outlined,
              size: 26, color: Theme.of(context).colorScheme.onBackground),
          title: Text(
            'Message',
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 17,
                ),
          ),
          onTap: () {
            onSelectScreen('filters');
          },
        ),
        ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: kMediumPadding),
          leading: Icon(Icons.calendar_month_outlined,
              size: 26, color: Theme.of(context).colorScheme.onBackground),
          title: Text(
            'Calendar',
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 17,
                ),
          ),
          onTap: () {
            onSelectScreen('filters');
          },
        ),
        ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: kMediumPadding),
          leading: Icon(Icons.mail_outline,
              size: 26, color: Theme.of(context).colorScheme.onBackground),
          title: Text(
            'Contact Us',
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 17,
                ),
          ),
          onTap: () {
            onSelectScreen('filters');
          },
        ),
        ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: kMediumPadding),
          leading: Icon(Icons.settings_outlined,
              size: 26, color: Theme.of(context).colorScheme.onBackground),
          title: Text(
            'Settings',
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 17,
                ),
          ),
          onTap: () {
            onSelectScreen('filters');
          },
        ),
        ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: kMediumPadding),
          leading: Icon(Icons.question_answer_outlined,
              size: 26, color: Theme.of(context).colorScheme.onBackground),
          title: Text(
            'Helps & FAQs',
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 17,
                ),
          ),
          onTap: () {
            onSelectScreen('filters');
          },
        ),
        ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: kMediumPadding),
          leading: Icon(Icons.logout_outlined,
              size: 26, color: Theme.of(context).colorScheme.onBackground),
          title: Text(
            'Sign Out',
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 17,
                ),
          ),
          onTap: () {
            AuthServices().googleSignOut();
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ));
          },
        )
      ]),
    );
  }
}
