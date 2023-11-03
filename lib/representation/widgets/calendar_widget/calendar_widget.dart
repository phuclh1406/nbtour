import 'package:flutter/material.dart';

import 'package:nbtour/utils/constant/colors.dart';

import 'package:nbtour/services/models/data_source.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key, required this.initDate});

  final DateTime initDate;
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

  // void calendarTapped(
  //     BuildContext context, CalendarTapDetails calendarTapDetails) {
  //   if (calendarTapDetails.targetElement == CalendarElement.appointment) {
  //     String? scheduleJson = sharedPreferences.getString("schedule_tour");

  //     if (scheduleJson != null) {
  //       try {
  //         // Parsing the JSON string back to a List of Appointment objects
  //         Tour appointments = Tour.fromJson(json.decode(scheduleJson));

  //         // Find the tapped appointment based on its properties, e.g., startTime, endTime, subject
  //         final tappedAppointment = appointments;

  //         // Navigate to the detail screen with the tapped appointment data
  //         String roleName = sharedPreferences.getString("role_name")!;
  //         if (roleName.contains("TourGuide")) {
  //           Navigator.of(context).push(
  //             MaterialPageRoute(
  //               builder: (context) => TourGuideTourDetailScreen(
  //                 scheduleTour: tappedAppointment,
  //               ),
  //             ),
  //           );
  //         } else {
  //           Navigator.of(context).push(
  //             MaterialPageRoute(
  //               builder: (context) => DriverTourDetailScreen(
  //                 scheduleTour: tappedAppointment,
  //               ),
  //             ),
  //           );
  //         }

  //         // Remove the stored data from SharedPreferences (if needed)
  //         sharedPreferences.remove("appointments");
  //       } catch (e) {
  //         print('Error decoding JSON: $e');
  //       }
  //     }
  //   }
  // }

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
              view: CalendarView.month,
              showTodayButton: true,
              monthViewSettings: const MonthViewSettings(
                  appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
                  showAgenda: true),
              timeSlotViewSettings: const TimeSlotViewSettings(
                timeInterval:
                    Duration(hours: 1), // Set your desired time interval
                timeFormat: 'HH', // Set the time format to 24-hour
              ),
              initialSelectedDate: widget.initDate,
              showDatePickerButton: true,
              firstDayOfWeek: 1,
              dataSource: MeetingDataSource(appointments),
              todayHighlightColor: ColorPalette.primaryColor,

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
              child: Text(''),
            );
          }
        });
  }
}
