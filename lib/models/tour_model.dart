import 'package:flutter/material.dart';
import 'package:nbtour/models/bus_model.dart';
import 'package:nbtour/models/image_model.dart';
import 'package:nbtour/models/route_model.dart';
import 'package:nbtour/models/station_model.dart';
import 'package:nbtour/models/ticket_model.dart';
import 'package:nbtour/models/user_model.dart';

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
    required this.departureStation,
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
  late Stations? departureStation;
  late Buses? tourBus;
  late String? duration;
  late Routes? tourRoute;
  late List<Tickets>? tourTicket;
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
    departureStation = json['departure_station'] != null
        ? Stations.fromJson(json['departure_station'])
        : null;
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
      tourTicket = List<Tickets>.from(
        json['tour_ticket'].map((x) => Tickets.fromJson(x)),
      );
    } else {
      tourTicket = [];
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
    _data['duration'] = duration;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    if (tourImage != null) {
      _data['tour_image'] = tourImage?.map((x) => x.toJson()).toList();
    }
    if (departureStation != null) {
      _data['departure_station'] = {
        'stationId': departureStation?.stationId,
        'stationName': departureStation?.stationName,
        'description': departureStation?.description,
        'address': departureStation?.address,
        'latitude': departureStation?.latitude,
        'longitude': departureStation?.longitude,
      };
    }
    if (tourBus != null) {
      _data['departure_station'] = {
        'busId': tourBus?.busId,
        'busPlate': tourBus?.busPlate,
        'numberSeat': tourBus?.numberSeat,
        'isDoubleDecker': tourBus?.isDoubleDecker,
      };
    }
    if (tourRoute != null) {
      _data['tour_route'] = {
        'routeId': tourRoute?.routeId,
        'routeName': tourRoute?.routeName,
        'distance': tourRoute?.distance,
        'geoJson': tourRoute?.geoJson
      };
    }
    if (tourGuide != null) {
      _data['tour_tourguide'] = {
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
      _data['tour_driver'] = {
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
    if (tourTicket != null) {
      _data['tour_ticket'] = tourTicket!.map((x) => x.toJson()).toList();
    }
    return _data;
  }
}
