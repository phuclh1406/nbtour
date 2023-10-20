import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nbtour/constant/colors.dart';
import 'package:nbtour/constant/dimension.dart';
import 'package:nbtour/constant/text_style.dart';
import 'package:nbtour/main.dart';
import 'package:nbtour/models/data_source.dart';
import 'package:nbtour/models/tour_model.dart';
import 'package:nbtour/screens/driver/tour_detail_screen.dart';
import 'package:nbtour/screens/tour_guide/tour_detail_screen.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});
  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

Future<List<Appointment>>? _appointments;

class _CalendarWidgetState extends State<CalendarWidget> {
  Future<void> _loadAppointments() async {
    try {
      final appointments = await loadScheduledTour();
      setState(() {
        _appointments = Future.value(appointments);
      });
      print('This is appointmentsssssssssssssssssssss $_appointments');
    } catch (error) {
      // Handle any errors that occur during loading.
      print('Error loading appointments: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Widget appointmentBuilder(
    BuildContext context,
    CalendarAppointmentDetails calendarAppointmentDetails,
  ) {
    final Appointment appointment =
        calendarAppointmentDetails.appointments.first;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            width: calendarAppointmentDetails.bounds.width,
            height: calendarAppointmentDetails.bounds.height / 2,
            color: appointment.color,
            child: const Center(
              child: Icon(
                Icons.group,
                color: Colors.black,
              ),
            )),
        Container(
          width: calendarAppointmentDetails.bounds.width,
          height: calendarAppointmentDetails.bounds.height / 2,
          color: appointment.color,
          child: Column(
            children: [
              Text(
                appointment.subject,
                textAlign: TextAlign.center,
                style: TextStyles.defaultStyle.bold.fontCaption,
              ),
              const SizedBox(
                height: kDefaultIconSize,
              ),
              Text(
                '${DateFormat(' (hh:mm a').format(appointment.startTime)}-${DateFormat('hh:mm a)').format(appointment.endTime)}',
                textAlign: TextAlign.center,
                style: TextStyles.defaultStyle.bold.fontCaption,
              ),
            ],
          ),
        )
      ],
    );
  }

  void calendarTapped(
      BuildContext context, CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.targetElement == CalendarElement.appointment) {
      String? scheduleJson = sharedPreferences.getString("schedule_tour");

      if (scheduleJson != null) {
        try {
          // Parsing the JSON string back to a List of Appointment objects
          Tour appointments = Tour.fromJson(json.decode(scheduleJson));

          // Find the tapped appointment based on its properties, e.g., startTime, endTime, subject
          final tappedAppointment = appointments;

          // Navigate to the detail screen with the tapped appointment data
          String roleName = sharedPreferences.getString("role_name")!;
          if (roleName.contains("TourGuide")) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => TourGuideTourDetailScreen(
                  scheduleTour: tappedAppointment,
                ),
              ),
            );
          } else {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DriverTourDetailScreen(
                  scheduleTour: tappedAppointment,
                ),
              ),
            );
          }

          // Remove the stored data from SharedPreferences (if needed)
          sharedPreferences.remove("appointments");
        } catch (e) {
          print('Error decoding JSON: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Appointment>>(
        future: _appointments,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child:
                  CircularProgressIndicator(color: ColorPalette.primaryColor),
            );
          } else if (snapshot.hasData) {
            final appointments = snapshot.data!;
            print('This is appointment $appointments');
            return SfCalendar(
              // onTap: (details) => calendarTapped(context, details),
              view: CalendarView.day,
              showTodayButton: true,
              timeSlotViewSettings: const TimeSlotViewSettings(
                timeInterval:
                    Duration(hours: 1), // Set your desired time interval
                timeFormat: 'HH', // Set the time format to 24-hour
              ),
              initialSelectedDate: DateTime.now(),
              showDatePickerButton: true,
              firstDayOfWeek: 1,
              dataSource: MeetingDataSource(appointments),
              todayHighlightColor: ColorPalette.primaryColor,
              appointmentBuilder: appointmentBuilder,
              selectionDecoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: ColorPalette.primaryColor, width: 2),
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                shape: BoxShape.rectangle,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return const Center(
              child: Text('No appointments found.'),
            );
          }
        });
  }
}
