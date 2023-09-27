import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nbtour/constant/colors.dart';
import 'package:nbtour/constant/dimension.dart';
import 'package:nbtour/main.dart';
import 'package:nbtour/models/schedule_model.dart';
import 'package:nbtour/services/schedule_service.dart';
import 'package:nbtour/widgets/tour_list_widget.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'dart:math' as math;
import '../screens/tour_guide/tour_detail_screen.dart';

String userId = sharedPreferences.getString("user_id")!;

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> appointments) {
    appointments = appointments;
  }

  Appointment getAppointment(int index) => appointments![index] as Appointment;
}

List<Appointment> meetings = <Appointment>[];

Future<List<Appointment>> loadScheduledTour() async {
  String role = sharedPreferences.getString("role_name")!;
  try {
    if (role == "Driver") {
      List<Schedules>? listScheduledTour =
          await ScheduleService.getScheduleToursByDriverId(userId);
      if (listScheduledTour != null && listScheduledTour.isNotEmpty) {
        for (var i = 0; i < listScheduledTour.length; i++) {
          sharedPreferences.setString("schedule_tour",
              json.encode(listScheduledTour[i].scheduleTour!.toJson()));
          final isAlreadyInclude = meetings.any((meetings) =>
              meetings.startTime ==
                  DateTime.parse(listScheduledTour[i].startTime!) &&
              (meetings.endTime ==
                  DateTime.parse(listScheduledTour[i].endTime!)) &&
              meetings.subject == listScheduledTour[i].scheduleTour!.tourName);

          if (!isAlreadyInclude) {
            meetings.add(Appointment(
              startTime: DateTime.parse(listScheduledTour[i].startTime!),
              endTime: DateTime.parse(listScheduledTour[i].endTime!),
              subject: listScheduledTour[i].scheduleTour!.tourName!,
              color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                  .withOpacity(1.0),
            ));
          }
        }

        return meetings;
      } else {
        // Return an empty list when there are no scheduled tours.
        return [];
      }
    } else {
      List<Schedules>? listScheduledTour =
          await ScheduleService.getScheduleToursByTourGuideId(userId);
      if (listScheduledTour != null && listScheduledTour.isNotEmpty) {
        for (var i = 0; i < listScheduledTour.length; i++) {
          sharedPreferences.setString("schedule_tour",
              json.encode(listScheduledTour[i].scheduleTour!.toJson()));
          final isAlreadyInclude = meetings.any((meetings) =>
              meetings.startTime ==
                  DateTime.parse(listScheduledTour[i].startTime!) &&
              (meetings.endTime ==
                  DateTime.parse(listScheduledTour[i].endTime!)) &&
              meetings.subject == listScheduledTour[i].scheduleTour!.tourName);

          if (!isAlreadyInclude) {
            meetings.add(Appointment(
              startTime: DateTime.parse(listScheduledTour[i].startTime!),
              endTime: DateTime.parse(listScheduledTour[i].endTime!),
              subject: listScheduledTour[i].scheduleTour!.tourName!,
              color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                  .withOpacity(1.0),
            ));
          }
        }

        return meetings;
      } else {
        // Return an empty list when there are no scheduled tours.
        return [];
      }
    }
  } catch (error) {
    // Handle the error gracefully, e.g., log it.
    print('An error occurred: $error');
    return []; // Return an empty list in case of an error.
  }
}

// Future<void> getAppointments() {
//   return loadScheduledTour();
// }

Future<List<Appointment>> getAppointments() async {
  return await loadScheduledTour();
}
