import 'package:flutter/material.dart';
import 'package:nbtour/main.dart';
import 'package:nbtour/representation/widgets/item_profile_widget.dart';
import 'package:nbtour/utils/constant/dimension.dart';
import 'package:nbtour/utils/constant/text_style.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String userName = sharedPreferences.getString('user_name') ?? '';
    String email = sharedPreferences.getString('email') ?? '';
    String avatar = sharedPreferences.getString('avatar') ?? '';
    String roleName = sharedPreferences.getString('role_name') ?? '';

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Trang cá nhân',
          style: TextStyles.defaultStyle.fontHeader.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            ClipRRect(
              borderRadius: BorderRadius.circular(kMediumPadding * 2),
              child: Image.network(
                avatar,
                height: 80,
                width: 80,
              ),
            ),
            const SizedBox(height: 20),
            ItemProfileWidget(
              title: 'Họ và tên',
              subtitle: userName,
              iconData: const Icon(Icons.person_2_outlined),
            ),
            const SizedBox(height: 10),
            ItemProfileWidget(
              title: 'Email',
              subtitle: email,
              iconData: const Icon(Icons.email_outlined),
            ),
            const SizedBox(height: 10),
            ItemProfileWidget(
              title: 'Vai trò',
              subtitle: roleName == 'TourGuide' ? 'Hướng dẫn viên' : 'Tài xế',
              iconData: const Icon(Icons.list_outlined),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
