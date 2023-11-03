import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:nbtour/utils/constant/text_style.dart';
import 'package:nbtour/representation/widgets/calendar_widget/calendar_widget.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key, required this.initDate});

  final DateTime initDate;

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title:
              Text('Schedule', style: TextStyles.regularStyle.fontHeader.bold),
        ),
        body: SafeArea(child: CalendarWidget(initDate: widget.initDate)));
  }
}
