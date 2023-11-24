import 'package:flutter/material.dart';
import 'package:nbtour/services/models/booking_model.dart';
import 'package:nbtour/services/models/booking_ticket_model.dart';
import 'package:nbtour/services/models/bus_model.dart';
import 'package:nbtour/services/models/image_model.dart';
import 'package:nbtour/services/models/route_model.dart';
import 'package:nbtour/services/models/station_model.dart';
import 'package:nbtour/services/models/ticket_model.dart';
import 'package:nbtour/services/models/user_model.dart';

List<Tour> toursFromJson(dynamic str) =>
    List<Tour>.from((str).map((x) => Tour.fromJson(x)));

class Tour {
  Tour({
    required this.tourId,
    required this.tourName,
    required this.description,
    required this.note,
    required this.beginBookingDate,
    required this.endBookingDate,
    required this.departureDate,
    required this.endDate,
    required this.tourStatus,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.tourImage,
    required this.tourRoute,
    required this.tourTicket,
    required this.tourGuide,
  });
  late String? tourId;
  late String? tourName;
  late String? description;
  late String? note;
  late String? beginBookingDate;
  late String? endBookingDate;
  late String? departureDate;
  late String? endDate;
  late String? tourStatus;
  late String? status;
  late String? createdAt;
  late String? updatedAt;
  late List<ImageModel>? tourImage;
  late Buses? tourBus;
  late String? duration;
  late Routes? tourRoute;
  late List<BookingTickets>? tourTicket;
  late UserModel? tourGuide;
  late UserModel? driver;

  Tour.fromJson(Map<String, dynamic> json) {
    tourId = json['tourId'];
    tourName = json['tourName'];
    description = json['description'];
    note = json['note'];

    beginBookingDate = json['beginBookingDate'];
    endBookingDate = json['endBookingDate'];
    departureDate = json['departureDate'];
    endDate = json['endDate'];
    tourStatus = json['tourStatus'];
    duration = json['duration'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['tour_image'] != null && json['tour_image'] is List) {
      tourImage = List<ImageModel>.from(
        json['tour_image'].map((x) => ImageModel.fromJson(x)),
      );
    } else {
      tourImage = [];
    }

    tourGuide = json['tour_tourguide'] != null
        ? UserModel.fromJson(json['tour_tourguide'])
        : null;
    driver = json['tour_driver'] != null
        ? UserModel.fromJson(json['tour_driver'])
        : null;
    tourBus =
        json['tour_bus'] != null ? Buses.fromJson(json['tour_bus']) : null;
    tourRoute =
        json['tour_route'] != null ? Routes.fromJson(json['tour_route']) : null;
    if (json['tour_ticket'] != null && json['tour_ticket'] is List) {
      tourTicket = List<BookingTickets>.from(
        json['tour_ticket'].map((x) => BookingTickets.fromJson(x)),
      );
    } else {
      tourTicket = [];
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['tourId'] = tourId;
    data['tourName'] = tourName;
    data['description'] = description;
    data['note'] = note;
    data['beginBookingDate'] = beginBookingDate;
    data['endBookingDate'] = endBookingDate;
    data['departureDate'] = departureDate;
    data['endDate'] = endDate;
    data['tourStatus'] = tourStatus;
    data['status'] = status;
    data['duration'] = duration;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (tourImage != null) {
      data['tour_image'] = tourImage?.map((x) => x.toJson()).toList();
    }

    if (tourBus != null) {
      data['departure_station'] = {
        'busId': tourBus?.busId,
        'busPlate': tourBus?.busPlate,
        'numberSeat': tourBus?.numberSeat,
        'isDoubleDecker': tourBus?.isDoubleDecker,
      };
    }
    if (tourRoute != null) {
      data['tour_route'] = {
        'routeId': tourRoute?.routeId,
        'routeName': tourRoute?.routeName,
        'distance': tourRoute?.distance,
        'geoJson': tourRoute?.geoJson
      };
    }
    if (tourGuide != null) {
      data['tour_tourguide'] = {
        'userId': tourGuide?.id,
        'userName': tourGuide?.name,
        'email': tourGuide?.email,
        'birthday': tourGuide?.yob,
        'avatar': tourGuide?.avatar,
        'address': tourGuide?.address,
        'phone': tourGuide?.phone,
        'maxTour': tourGuide?.maxTour,
        'roleId': tourGuide?.roleModel?.roleId,
        'accessChangePassword': tourGuide?.accessChangePassword,
      };
    }

    if (driver != null) {
      data['tour_driver'] = {
        'userId': driver?.id,
        'userName': driver?.name,
        'email': driver?.email,
        'birthday': driver?.yob,
        'avatar': driver?.avatar,
        'address': driver?.address,
        'phone': driver?.phone,
        'maxTour': driver?.maxTour,
        'roleId': driver?.roleModel?.roleId,
        'accessChangePassword': driver?.accessChangePassword,
      };
    }
    if (tourTicket != null && tourTicket!.isNotEmpty) {
      data['tour_ticket'] = tourTicket!.map((ticket) {
        return {
          'ticketId': ticket.ticketId,
          'ticket_type': ticket.bookingDetailTicket,
        };
      }).toList();
    }
    return data;
  }
}
