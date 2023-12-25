import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:nbtour/main.dart';
import 'package:nbtour/representation/screens/login_screen.dart';
import 'package:nbtour/representation/screens/notification_list_screen.dart';
import 'package:nbtour/representation/screens/profile_screen.dart';
import 'package:nbtour/representation/screens/request_screen.dart';
import 'package:nbtour/representation/screens/schedule_screen.dart';
import 'package:nbtour/representation/screens/sent_request.dart';
import 'package:nbtour/representation/screens/tour_guide/tour_screen.dart';
import 'package:nbtour/services/api/auth_service.dart';
import 'package:nbtour/services/api/notification_service.dart';
import 'package:nbtour/services/api/payment_stripe_service.dart';
import 'package:nbtour/services/models/notification.dart';
import 'package:nbtour/utils/constant/colors.dart';
import 'package:nbtour/utils/constant/dimension.dart';
import 'package:nbtour/utils/constant/text_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TourGuideHomeScreen extends StatefulWidget {
  const TourGuideHomeScreen({super.key});

  @override
  State<TourGuideHomeScreen> createState() => _TourGuideHomeScreenState();
}

class _TourGuideHomeScreenState extends State<TourGuideHomeScreen> {
  Map<String, dynamic>? paymentIntent;
  String avatar = '';
  String userName = '';
  OverlayEntry? entry;
  Timer? timer;
  List<NotificationModel> listNoti = [];
  bool isCircle = false;
  Offset offset = const Offset(14, 610);
  int notiCount = 0;
  int formCount = 0;
  String userId = sharedPreferences.getString("user_id")!;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchUserName();
    fetchNotification(userId);
  }

  Future<void> fetchNotification(String userId) async {
    try {
      List<NotificationModel>? notiList =
          await NotificationServices.getNotificationList(userId);
      if (notiList!.isNotEmpty) {
        notiList.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
        setState(() {
          listNoti = notiList;
          notiCount = notiList.length;
        });
      }
    } catch (e) {
      Text(e.toString());
    }
  }

  Future<void> fetchUserName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? fetchUserName = prefs.getString('user_name');
      if (fetchUserName != null) {
        setState(() {
          userName = fetchUserName;
        });
      }
    } catch (e) {
      setState(() {
        userName = 'Minh Huy';
      });
    }
  }

  void hideOverlay() {
    try {
      if (entry != null) {
        entry?.remove();
        entry = null;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void makePayment() async {
    try {
      paymentIntent = await PaymentStripeServices.paymentStripe("30000");
      var gPay = const PaymentSheetGooglePay(
          merchantCountryCode: "SG", currencyCode: "VND", testEnv: true);
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntent!["client_secret"],
              style: ThemeMode.dark,
              customFlow: true,
              allowsDelayedPaymentMethods: true,
              merchantDisplayName: "Phuc",
              googlePay: gPay));
      displayPaymentSheet();
    } catch (e) {
      print('FAIL');
    }
  }

  void displayPaymentSheet() async {
    // try {
    await Stripe.instance.presentPaymentSheet();
    print('Done');
    // } catch (e) {
    //   print('Fail');
    // }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    List imgSrc = [
      "assets/images/incomming_app.png",
      "assets/images/send_app.png",
      "assets/images/calendar.png",
      "assets/images/list.png"
    ];

    List titles = [
      "Đơn đến",
      "Đơn gửi",
      "Xem lịch",
      "Chuyến đi",
    ];
    return Scaffold(
        body: Container(
      color: ColorPalette.primaryColor,
      child: Column(
        children: [
          SizedBox(
              height: height * 0.25,
              width: width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 50, left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            showMenu(
                              color: Colors.white,
                              context: context,
                              elevation: 1,
                              items: [
                                PopupMenuItem(
                                  child: const Text(
                                    'Trang cá nhân',
                                    style: TextStyles.defaultStyle,
                                  ),
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (ctx) =>
                                                const ProfileScreen()));
                                  },
                                ),
                                PopupMenuItem(
                                  child: const Text(
                                    'Thanh toán',
                                    style: TextStyles.defaultStyle,
                                  ),
                                  onTap: () {
                                    makePayment();
                                  },
                                ),
                                PopupMenuItem(
                                  child: const Text('Đăng xuất',
                                      style: TextStyles.defaultStyle),
                                  onTap: () {
                                    AuthServices().googleSignOut();
                                    final fcm = FirebaseMessaging.instance;
                                    fcm.deleteToken();

                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen(),
                                        ));
                                    sharedPreferences.clear();
                                  },
                                ),
                              ],
                              position:
                                  const RelativeRect.fromLTRB(0, 0, 0, 100),
                            );
                          },
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(kMediumPadding * 2),
                            child: Image.network(
                              sharedPreferences.getString('avatar') ?? '',
                              height: 50,
                              width: 50,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) =>
                                    const NotificationListScreen()));
                          },
                          icon: notiCount != 0
                              ? Badge(
                                  backgroundColor: Colors.red,
                                  label: Text(notiCount.toString()),
                                  child: const Icon(
                                    Icons.notifications,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(
                                  Icons.notifications,
                                  color: Colors.white,
                                ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 15, left: 15, right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Xin chào nhân viên',
                          style: TextStyles
                              .regularStyle.bold.whiteTextColor.fontHeader,
                        ),
                        const SizedBox(
                          height: kDefaultIconSize / 2,
                        ),
                        Text(
                          sharedPreferences.getString('user_name') ?? '',
                          style: TextStyles.regularStyle.whiteTextColor,
                        )
                      ],
                    ),
                  )
                ],
              )),
          Expanded(
            child: Container(
              height: height * 0.75,
              width: width,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 35, left: 20, right: 15),
                    child: Text(
                      'Danh sách các tác vụ',
                      style: TextStyles.defaultStyle.bold.fontHeader,
                    ),
                  ),
                  GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.1,
                      mainAxisSpacing: 30,
                    ),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          switch (titles[index]) {
                            case "Đơn đến":
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const RequestScreen(),
                                  ));
                              break;
                            case "Đơn gửi":
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const SentRequestScreen(),
                                  ));
                              break;
                            case "Xem lịch":
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ScheduleScreen(
                                      initDate: DateTime.now(),
                                    ),
                                  ));
                              break;
                            case "Chuyến đi":
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const TourGuideTourScreen(),
                                  ));
                              break;
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black26,
                                    spreadRadius: 1,
                                    blurRadius: 6)
                              ]),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset(imgSrc[index],
                                    width: 100, height: 100),
                                Text(
                                  titles[index],
                                  style: TextStyles.defaultStyle.bold,
                                )
                              ]),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }
}
