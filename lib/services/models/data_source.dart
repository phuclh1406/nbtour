import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:nbtour/main.dart';
import 'package:nbtour/services/api/schedule_service.dart';

import 'package:nbtour/services/models/tour_model.dart';
import 'package:nbtour/services/models/tour_schedule_model.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'dart:math' as math;

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}

List<Appointment> meetings = <Appointment>[];

Future<List<Appointment>> loadScheduledTour() async {
  try {
    String role = sharedPreferences.getString("role_name")!;
    String userId = sharedPreferences.getString("user_id")!;
    meetings = [];
    if (role == "TourGuide") {
      List<TourSchedule>? listScheduledTour =
          await ScheduleService.getSchedulesByTourGuideId(userId);
      if (listScheduledTour != null && listScheduledTour.isNotEmpty) {
        for (var i = 0; i < listScheduledTour.length; i++) {
          final isAlreadyInclude = meetings.any((meetings) =>
              meetings.startTime ==
                  DateTime.parse(listScheduledTour[i].departureDate!) &&
              (meetings.endTime ==
                  DateTime.parse(listScheduledTour[i].endDate!)) &&
              meetings.subject == listScheduledTour[i].scheduleTour!.tourName);

          if (!isAlreadyInclude) {
            meetings.add(Appointment(
              startTimeZone: "SE Asia Standard Time",
              endTimeZone: "SE Asia Standard Time",
              startTime: DateTime.parse(listScheduledTour[i].departureDate!),
              endTime: DateTime.parse(listScheduledTour[i].endDate!),
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
      List<TourSchedule>? listScheduledTour =
          await ScheduleService.getSchedulesByDriverId(userId);
      print('$userId 456');
      if (listScheduledTour != null && listScheduledTour.isNotEmpty) {
        for (var i = 0; i < listScheduledTour.length; i++) {
          final isAlreadyInclude = meetings.any((meetings) =>
              meetings.startTime ==
                  DateTime.parse(listScheduledTour[i].departureDate!) &&
              (meetings.endTime ==
                  DateTime.parse(listScheduledTour[i].endDate!)) &&
              meetings.subject == listScheduledTour[i].scheduleTour!.tourName);

          if (!isAlreadyInclude) {
            meetings.add(Appointment(
              startTimeZone: "SE Asia Standard Time",
              endTimeZone: "SE Asia Standard Time",
              startTime: DateTime.parse(listScheduledTour[i].departureDate!),
              endTime: DateTime.parse(listScheduledTour[i].endDate!),
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
