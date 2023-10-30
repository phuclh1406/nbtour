import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:nbtour/constant/text_style.dart';
import 'package:nbtour/widgets/calendar_widget/calendar_widget.dart';

class TourGuideScheduleScreen extends StatefulWidget {
  const TourGuideScheduleScreen({super.key});

  @override
  State<TourGuideScheduleScreen> createState() =>
      _TourGuideScheduleScreenState();
}

class _TourGuideScheduleScreenState extends State<TourGuideScheduleScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const SafeArea(child: CalendarWidget());
  }
}
