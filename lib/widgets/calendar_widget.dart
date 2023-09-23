import 'package:flutter/material.dart';
import 'package:nbtour/constant/colors.dart';
import 'package:nbtour/models/data_source.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});
  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  CalendarController _calendarController = CalendarController();
  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      view: CalendarView.day,
      showTodayButton: true,
      initialSelectedDate: DateTime.now(),
      showDatePickerButton: true,
      firstDayOfWeek: 1,
      dataSource: MeetingDataSource(getAppointments()),
      todayHighlightColor: ColorPalette.primaryColor,
      selectionDecoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: ColorPalette.primaryColor, width: 2),
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        shape: BoxShape.rectangle,
      ),
    );
  }
}
