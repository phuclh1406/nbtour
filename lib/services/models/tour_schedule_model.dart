import 'package:nbtour/services/models/booking_ticket_model.dart';
import 'package:nbtour/services/models/bus_model.dart';
import 'package:nbtour/services/models/route_model.dart';
import 'package:nbtour/services/models/station_model.dart';
import 'package:nbtour/services/models/ticket_model.dart';
import 'package:nbtour/services/models/tour_model.dart';
import 'package:nbtour/services/models/user_model.dart';

List<TourSchedule> schedulesFromJson(dynamic str) =>
    List<TourSchedule>.from((str).map((x) => TourSchedule.fromJson(x)));

class TourSchedule {
  TourSchedule({
    required this.scheduleId,
    required this.tourId,
    required this.departureDate,
    required this.endDate,
    required this.isScheduled,
    required this.status,
    required this.scheduleStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.tourGuide,
    required this.scheduleBus,
    required this.driver,
    required this.station,
    required this.availableSeats,
    required this.scheduleTour,
    required this.routeSegment,
    required this.paidBackPrice,
  });
  late String? scheduleId;
  late String? tourId;
  late bool? isScheduled;
  late String? departureDate;
  late String? endDate;
  late String? scheduleStatus;
  late String? status;
  late String? createdAt;
  late String? updatedAt;
  late Buses? scheduleBus;
  late UserModel? tourGuide;
  late UserModel? driver;
  late Stations? station;
  late int? availableSeats;
  late Tour? scheduleTour;
  late List<RouteSegment>? routeSegment;
  late int? paidBackPrice;

  TourSchedule.fromJson(Map<String, dynamic> json) {
    scheduleId = json['scheduleId'];
    tourId = json['tourId'];
    departureDate = json['departureDate'];
    endDate = json['endDate'];
    isScheduled = json['isScheduled'];
    departureDate = json['departureDate'];
    scheduleStatus = json['scheduleStatus'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    availableSeats = json['availableSeats'];
    paidBackPrice = json['paidBackPrice'] ?? 0;

    tourGuide = json['schedule_tourguide'] != null
        ? UserModel.fromJson(json['schedule_tourguide'])
        : null;
    driver = json['schedule_driver'] != null
        ? UserModel.fromJson(json['schedule_driver'])
        : null;
    scheduleBus = json['schedule_bus'] != null
        ? Buses.fromJson(json['schedule_bus'])
        : null;
    station = json['schedule_departure_station'] != null
        ? Stations.fromJson(json['schedule_departure_station'])
        : null;
    scheduleTour = json['schedule_tour'] != null
        ? Tour.fromJson(json['schedule_tour'])
        : null;
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
    data['scheduleId'] = scheduleId;
    data['tourId'] = tourId;
    data['departureDate'] = departureDate;
    data['endDate'] = endDate;
    data['isScheduled'] = isScheduled;
    data['departureDate'] = departureDate;
    data['scheduleStatus'] = scheduleStatus;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['availableSeats'] = availableSeats;
    data['paidBackPrice'] = paidBackPrice ?? 0;

    if (scheduleBus != null) {
      data['departure_station'] = {
        'busId': scheduleBus?.busId,
        'busPlate': scheduleBus?.busPlate,
        'numberSeat': scheduleBus?.numberSeat,
        'isDoubleDecker': scheduleBus?.isDoubleDecker,
      };
    }
    if (tourGuide != null) {
      data['schedule_tourguide'] = {
        'userId': tourGuide?.id,
        'userName': tourGuide?.name,
        'email': tourGuide?.email,
        'avatar': tourGuide?.avatar,
        'phone': tourGuide?.phone,
      };
    }

    if (driver != null) {
      data['schedule_driver'] = {
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
    if (station != null) {
      data['schedule_departure_station'] = {
        'stationId': station?.stationId,
        'stationName': station?.stationName,
        'description': station?.description,
        'address': station?.address,
        'latitude': station?.latitude,
        'longitude': station?.longitude,
        'status': station?.status,
      };
    }

    if (scheduleTour != null) {
      data['schedule_tour'] = {
        'tourId': scheduleTour?.tourId,
        'tourName': scheduleTour?.tourName,
        'description': scheduleTour?.description,
        'geoJson': scheduleTour?.geoJson,
        'tour_image': scheduleTour?.tourImage,
        'tour_ticket': scheduleTour?.tourTicket
      };
    }

    if (routeSegment != null && routeSegment!.isNotEmpty) {
      data['route_segment'] = routeSegment!.map((routeSegment) {
        return {
          'routeSegmentId': routeSegment.routeSegmentId,
          'geoJson': routeSegment.geoJson,
          'segment_departure_station': routeSegment.segmentDepartureStation,
          'segment_end_station': routeSegment.segmentEndStation,
          'segment_route_poi_detail': routeSegment.segmentRoutePoiDetail,
        };
      }).toList();
    }
    return data;
  }
}
