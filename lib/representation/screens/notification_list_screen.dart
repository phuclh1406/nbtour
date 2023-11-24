import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:nbtour/utils/constant/text_style.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  List<RemoteMessage> _messages = [];

  @override
  void initState() {
    super.initState();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {
        _messages = [..._messages, message];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_messages.isEmpty) {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            scrolledUnderElevation: 0,
            title: Text(
              'Notification Screen',
              style: TextStyles.defaultStyle.bold.fontHeader,
            ),
          ),
          body: const Text('No messages received'));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        title: Text(
          'Notification Screen',
          style: TextStyles.defaultStyle.bold.fontHeader,
        ),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          RemoteMessage message = _messages[index];
          return ListTile(
              title: Text(
                message.notification?.title ?? 'N/D',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                  message.sentTime?.toString() ?? DateTime.now().toString()),
              trailing: const Icon(
                Icons.notifications_active,
                color: Colors.red,
              ),
              onTap: () => {
                    // switch (message.notification?.title == )
                    //     Navigator.of(context)
                    //         .push(MaterialPageRoute(builder: (ctx) => Navigator)),
                  });
        },
      ),
    );
  }
}
