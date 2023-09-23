import 'package:flutter/material.dart';
import 'package:nbtour/models/image_model.dart';
import 'package:nbtour/models/route_model.dart';
import 'package:nbtour/models/station_model.dart';
import 'package:nbtour/models/ticket_model.dart';

List<Tour> toursFromJson(dynamic str) =>
    List<Tour>.from((str).map((x) => Tour.fromJson(x)));

class Tour {
  Tour({
    required this.tourId,
    required this.tourName,
    required this.description,
    this.note,
    required this.beginBookingDate,
    required this.endBookingDate,
    required this.departureDate,
    required this.endDate,
    required this.tourStatus,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.tourImage,
    required this.departureStation,
    required this.tourRoute,
    required this.tourTicket,
  });
  late final String? tourId;
  late final String? tourName;
  late final String? description;
  late final String? note;
  late final String? beginBookingDate;
  late final String? endBookingDate;
  late final String? departureDate;
  late final String? endDate;
  late final String? tourStatus;
  late final String? status;
  late final String? createdAt;
  late final String? updatedAt;
  late final List<ImageModel>? tourImage;
  late final Stations? departureStation;
  late final Routes? tourRoute;
  late final List<Tickets>? tourTicket;

  Tour.fromJson(Map<String, dynamic> json) {
    tourId = json['tourId'];
    tourName = json['tourName'];
    description = json['description'];
    note = null;
    beginBookingDate = json['beginBookingDate'];
    endBookingDate = json['endBookingDate'];
    departureDate = json['departureDate'];
    endDate = json['endDate'];
    tourStatus = json['tourStatus'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['tour_image'] != null && json['tour_image'] is List) {
      tourImage = List<ImageModel>.from(
        json['tour_image'].map((x) => ImageModel.fromJson(x)),
      );
    }
    departureStation = json['departure_station'] != null
        ? Stations.fromJson(json['departure_station'])
        : null;
    tourRoute =
        json['tour_route'] != null ? Routes.fromJson(json['tour_route']) : null;
    if (json['tour_ticket'] != null && json['tour_ticket'] is List) {
      tourTicket = List<Tickets>.from(
        json['tour_ticket'].map((x) => Tickets.fromJson(x)),
      );
    }
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['tourId'] = tourId;
    _data['tourName'] = tourName;
    _data['description'] = description;
    _data['note'] = note;
    _data['beginBookingDate'] = beginBookingDate;
    _data['endBookingDate'] = endBookingDate;
    _data['departureDate'] = departureDate;
    _data['endDate'] = endDate;
    _data['tourStatus'] = tourStatus;
    _data['status'] = status;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    if (tourImage != null) {
      _data['tour_image'] = tourImage!.map((x) => x.toJson()).toList();
    }
    if (departureStation != null) {
      _data['departure_station'] = {
        'stationId': departureStation!.stationId,
        'stationName': departureStation!.stationName,
        'description': departureStation!.description,
        'address': departureStation!.address,
        'latitude': departureStation!.latitude,
        'longitude': departureStation!.longitude,
      };
    }
    if (tourRoute != null) {
      _data['departure_station'] = {
        'routeId': tourRoute!.routeId,
        'routeName': tourRoute!.routeName,
        'distance': tourRoute!.distance,
      };
    }
    if (tourTicket != null) {
      _data['tour_ticket'] = tourTicket!.map((x) => x.toJson()).toList();
    }
    return _data;
  }
}
