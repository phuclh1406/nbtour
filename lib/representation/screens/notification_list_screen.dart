import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nbtour/main.dart';
import 'package:nbtour/representation/screens/request_screen.dart';
import 'package:nbtour/services/api/notification_service.dart';
import 'package:nbtour/services/models/notification.dart';
import 'package:nbtour/utils/constant/colors.dart';
import 'package:nbtour/utils/constant/dimension.dart';
import 'package:nbtour/utils/constant/text_style.dart';
import 'package:nbtour/utils/helper/asset_helper.dart';
import 'package:nbtour/utils/helper/image_helper.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  List<NotificationModel>? _messages = [];
  Stream<List<NotificationModel>?>? notificationStream;

  @override
  void initState() {
    super.initState();
    notificationStream = Stream.periodic(const Duration(seconds: 10), (_) {
      return fetchNotifications();
    }).asyncMap((_) => fetchNotifications());
  }

  Future<List<NotificationModel>?> fetchNotifications() async {
    try {
      var userId = sharedPreferences.getString('user_id')!;
      _messages = await NotificationServices.getNotificationList(userId);
      return _messages;
    } catch (e) {
      print(e.toString());
    }
  }

  void onRemoveNotification(String notiId) async {
    try {
      String check = await NotificationServices.removeNotification(notiId);
      if (check == 'Delete successfully') {
        if (context.mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Đã đọc')));
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đánh dấu đã đọc thất bại')));
          }
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Widget loadNotifications() {
    try {
      return StreamBuilder<List<NotificationModel>?>(
        stream: notificationStream,
        builder: (BuildContext context,
            AsyncSnapshot<List<NotificationModel>?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: Padding(
              padding: EdgeInsets.only(top: kMediumPadding * 3),
              child:
                  CircularProgressIndicator(color: ColorPalette.primaryColor),
            ));
          } else if (snapshot.hasData) {
            _messages = snapshot.data!;

            if (_messages!.isEmpty) {
              return const Text('Chưa có thông báo');
            }

            return ListView.builder(
              shrinkWrap: true,
              itemCount: _messages!.length,
              itemBuilder: (context, index) {
                NotificationModel message = _messages![index];
                return Dismissible(
                  key: ValueKey(_messages![index]),
                  onDismissed: (direction) {
                    onRemoveNotification(message.notiId!);
                  },
                  child: ListTile(
                      title: Text(
                        message.title ?? 'N/D',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message.body!,
                          ),
                          Text(
                            '${DateFormat.yMMMd().format(DateTime.parse(message.createdAt!))} at ${DateFormat.Hms().format(DateTime.parse(message.createdAt!))}',
                            style: const TextStyle(
                                color: ColorPalette.subTitleColor),
                          ),
                        ],
                      ),
                      trailing: const Icon(
                        Icons.notifications_active,
                        color: Colors.red,
                      ),
                      onLongPress: () {},
                      onTap: () => {
                            if (message.title == "Đổi ca")
                              {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (ctx) => const RequestScreen()))
                              }
                          }),
                );
              },
            );
          } else if (snapshot.hasError) {
            // Display an error message if the future completed with an error
            return Text('Error: ${snapshot.error}');
          } else {
            return const SizedBox(); // Return an empty container or widget if data is null
          }
        },
      );
    } catch (e) {
      return Center(
          child: Column(
        children: [
          ImageHelper.loadFromAsset(AssetHelper.error),
          const SizedBox(height: 10),
          Text(
            e.toString(),
            style: TextStyles.regularStyle,
          )
        ],
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
          title: Text(
            'Thông báo',
            style: TextStyles.defaultStyle.bold.fontHeader,
          ),
        ),
        body: loadNotifications());
  }
}
