import 'package:flutter/material.dart';
import 'package:nbtour/services/models/booking_model.dart';
import 'package:nbtour/services/models/booking_ticket_model.dart';
import 'package:nbtour/services/models/bus_model.dart';
import 'package:nbtour/services/models/image_model.dart';
import 'package:nbtour/services/models/route_model.dart';
import 'package:nbtour/services/models/station_model.dart';
import 'package:nbtour/services/models/ticket_model.dart';
import 'package:nbtour/services/models/ticket_type_model.dart';
import 'package:nbtour/services/models/tour_schedule_model.dart';
import 'package:nbtour/services/models/user_model.dart';

List<Tour> toursFromJson(dynamic str) =>
    List<Tour>.from((str).map((x) => Tour.fromJson(x)));

class Tour {
  Tour(
      {required this.tourId,
      required this.tourName,
      required this.description,
      required this.status,
      required this.createdAt,
      required this.updatedAt,
      required this.tourImage,
      required this.tourTicket,
      required this.ticket,
      required this.geoJson,
      required this.routeSegment});
  late String? tourId;
  late String? tourName;
  late String? description;
  late String? status;
  late String? createdAt;
  late String? updatedAt;
  late List<ImageModel>? tourImage;
  late List<BookingTickets>? tourTicket;
  late List<Tickets>? ticket;
  late List<TourSchedule>? tourSchedule;
  late Map<String, dynamic>? geoJson;
  late List<RouteSegment>? routeSegment;

  Tour.fromJson(Map<String, dynamic> json) {
    tourId = json['tourId'];
    tourName = json['tourName'];
    description = json['description'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    geoJson = json['geoJson'];
    if (json['tour_image'] != null && json['tour_image'] is List) {
      tourImage = List<ImageModel>.from(
        json['tour_image'].map((x) => ImageModel.fromJson(x)),
      );
    } else {
      tourImage = [];
    }

    if (json['tour_schedule'] != null && json['tour_schedule'] is List) {
      tourSchedule = List<TourSchedule>.from(
        json['tour_schedule'].map((x) => TourSchedule.fromJson(x)),
      );
    } else {
      tourSchedule = [];
    }

    if (json['tour_ticket'] != null && json['tour_ticket'] is List) {
      tourTicket = List<BookingTickets>.from(
        json['tour_ticket'].map((x) => BookingTickets.fromJson(x)),
      );
    } else {
      tourTicket = [];
    }
    if (json['tour_ticket'] != null && json['tour_ticket'] is List) {
      ticket = List<Tickets>.from(
        json['tour_ticket'].map((x) => Tickets.fromJson(x)),
      );
    } else {
      ticket = [];
    }

    if (json['route_segment'] != null && json['route_segment'] is List) {
      routeSegment = List<RouteSegment>.from(
        json['route_segment'].map((x) => RouteSegment.fromJson(x)),
      );
    } else {
      routeSegment = [];
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['tourId'] = tourId;
    data['tourName'] = tourName;
    data['description'] = description;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (tourImage != null) {
      data['tour_image'] = tourImage?.map((x) => x.toJson()).toList();
    }
    if (tourSchedule != null && tourSchedule!.isNotEmpty) {
      data['tour_schedule'] = tourSchedule!.map((schedule) {
        return {
          "scheduleId": schedule.scheduleId,
          "departureDate": schedule.departureDate,
          "endDate": schedule.departureDate,
          "isScheduled": schedule.isScheduled,
          "scheduleStatus": schedule.scheduleStatus,
          "schedule_bus": schedule.scheduleBus,
          "schedule_tourguide": schedule.tourGuide,
          "schedule_driver": schedule.driver,
          "schedule_departure_station": schedule.station,
        };
      }).toList();
    }
    if (tourTicket != null && tourTicket!.isNotEmpty) {
      data['tour_ticket'] = tourTicket!.map((ticket) {
        return {
          'ticketId': ticket.ticketId,
          'ticket_type': ticket.bookingDetailTicket,
        };
      }).toList();
    }

    if (routeSegment != null && routeSegment!.isNotEmpty) {
      data['route_segment'] = routeSegment!.map((routeSegment) {
        return {
          'routeSegmentId': routeSegment.routeSegmentId,
          'index': routeSegment.index,
          'geoJson': routeSegment.geoJson,
          'route_detail_station': routeSegment.segmentDepartureStation,
        };
      }).toList();
    }
    return data;
  }
}
