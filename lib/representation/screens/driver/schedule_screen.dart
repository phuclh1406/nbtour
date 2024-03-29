import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nbtour/utils/constant/colors.dart';
import 'package:nbtour/utils/constant/dimension.dart';
import 'package:nbtour/utils/constant/text_style.dart';
import 'package:nbtour/representation/widgets/calendar_widget/calendar_widget.dart';

class DriverScheduleScreen extends StatefulWidget {
  const DriverScheduleScreen({super.key});

  @override
  State<DriverScheduleScreen> createState() => _DriverScheduleScreenState();
}

class _DriverScheduleScreenState extends State<DriverScheduleScreen> {
  void setupPushNotification() async {
    final fcm = FirebaseMessaging.instance;
    final notificationSettings = await fcm.requestPermission();
    notificationSettings.alert;
    final token = await fcm.getToken();
    print(token);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setupPushNotification();
  }

  @override
  Widget build(BuildContext context) {
    DateTime _selectedDate = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Thời gian biểu',
          style: TextStyles.defaultStyle.bold.fontHeader,
        ),
      ),
      body: CalendarWidget(
        initDate: DateTime.now(),
      ),
    );
  }
}
// return Scaffold(
    //   appBar: AppBar(
    //     backgroundColor: Colors.white,
    //     title: Text(
    //       'Schedule',
    //       style: TextStyles.defaultStyle.bold.fontHeader,
    //     ),
    //   ),
    //   body: Column(
    //     children: [
    //       Container(
    //         margin: const EdgeInsets.symmetric(horizontal: kMediumPadding),
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             // Row(
    //             //   children: [
    //             //     Column(
    //             //       crossAxisAlignment: CrossAxisAlignment.start,
    //             //       children: [
    //             //         Text(
    //             //           DateFormat.yMMMMd().format(DateTime.now()),
    //             //           style: TextStyles
    //             //               .defaultStyle.subTitleTextColor.bold.fontHeader,
    //             //         ),
    //             //         const SizedBox(
    //             //           height: kDefaultPadding / 2,
    //             //         ),
    //             //         Text(
    //             //           "Today",
    //             //           style: TextStyles.defaultStyle.bold.fontHeader,
    //             //         ),
    //             //       ],
    //             //     ),
    //             //     ButtonSelectYearWidget(
    //             //         title: 'Add task',
    //             //         ontap: () {},
    //             //         color: Colors.white,
    //             //         textStyle: TextStyles.defaultStyle.regular,
    //             //         isIcon: false)
    //             //   ],
    //             // ),
    //             Text(
    //               DateFormat.yMMMMd().format(DateTime.now()),
    //               style:
    //                   TextStyles.defaultStyle.subTitleTextColor.bold.fontHeader,
    //             ),
    //             const SizedBox(
    //               height: kDefaultPadding / 2,
    //             ),
    //             Text(
    //               "Today",
    //               style: TextStyles.defaultStyle.bold.fontHeader,
    //             ),
    //             const SizedBox(
    //               height: kDefaultPadding / 2,
    //             ),
    //             DatePicker(
    //               DateTime.now(),
    //               height: 100,
    //               width: 80,
    //               initialSelectedDate: DateTime.now(),
    //               selectionColor: ColorPalette.primaryColor,
    //               selectedTextColor: Colors.white,
    //               dateTextStyle: const TextStyle(
    //                 fontSize: 20,
    //                 fontWeight: FontWeight.w600,
    //                 color: Colors.grey,
    //               ),
    //               onDateChange: (date) {
    //                 _selectedDate = date;
    //               },
    //             ),
    //           ],
    //         ),
    //       ),
    //     ],
    //   ),
    // );