import 'package:nbtour/models/bus_model.dart';
import 'package:nbtour/models/tour_model.dart';
import 'package:nbtour/models/user_model.dart';

List<Schedules> schedulesFromJson(dynamic str) =>
    List<Schedules>.from((str).map((x) => Schedules.fromJson(x)));

class Schedules {
  Schedules({
    required this.scheduleId,
    required this.startTime,
    required this.endTime,
    required this.tourGuildId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.scheduleTour,
    required this.scheduleBus,
    required this.scheduleTourguild,
    required this.scheduleDriver,
  });
  late final String? scheduleId;
  late final String? startTime;
  late final String? endTime;
  late final String? tourGuildId;
  late final String? status;
  late final String? createdAt;
  late final String? updatedAt;
  late final Tour? scheduleTour;
  late final Buses? scheduleBus;
  late final UserModel? scheduleTourguild;
  late final UserModel? scheduleDriver;

  Schedules.fromJson(Map<String, dynamic> json) {
    scheduleId = json['scheduleId'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    tourGuildId = json['tourGuildId'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    scheduleTour = json['schedule_tour'] != null
        ? Tour.fromJson(json['schedule_tour'])
        : null;
    scheduleBus = json['schedule_bus'] != null
        ? Buses.fromJson(json['schedule_bus'])
        : null;
    scheduleTourguild = json['schedule_tourguild'] != null
        ? UserModel.fromJson(json['schedule_tourguild'])
        : null;
    scheduleDriver = json['schedule_driver'] != null
        ? UserModel.fromJson(json['schedule_driver'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['scheduleId'] = scheduleId;
    _data['startTime'] = startTime;
    _data['endTime'] = endTime;
    _data['tourGuildId'] = tourGuildId;
    _data['status'] = status;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    if (scheduleTour != null) {
      _data['schedule_tour'] = {
        'tourId': scheduleTour!.tourId,
        'tourName': scheduleTour!.tourName,
        'description': scheduleTour!.description,
        'note': scheduleTour!.note,
        'beginBookingDate': scheduleTour!.beginBookingDate,
        'endBookingDate': scheduleTour!.endBookingDate,
        'departureDate': scheduleTour!.departureDate,
        'routeId': scheduleTour!.tourRoute!.routeId,
        'departureStationId': scheduleTour!.departureStation!.stationId,
        'tourStatus': scheduleTour!.tourStatus,
      };
    }
    if (scheduleBus != null) {
      _data['schedule_bus'] = {
        'busId': scheduleBus!.busId,
        'busPlate': scheduleBus!.busPlate,
        'numberSeat': scheduleBus!.numberSeat,
        'isDoubleDecker': scheduleBus!.isDoubleDecker,
      };
    }
    if (scheduleTourguild != null) {
      _data['schedule_tourguild'] = {
        'userId': scheduleTourguild!.id,
        'userName': scheduleTourguild!.name,
        'email': scheduleTourguild!.email,
        'avatar': scheduleTourguild!.avatar,
        'phone': scheduleTourguild!.phone,
        'roleId': scheduleTourguild!.roleModel!.roleId,
      };
    }
    if (scheduleDriver != null) {
      _data['schedule_driver'] = {
        'userId': scheduleDriver!.id,
        'userName': scheduleDriver!.name,
        'email': scheduleDriver!.email,
        'avatar': scheduleDriver!.avatar,
        'phone': scheduleDriver!.phone,
        'roleId': scheduleDriver!.roleModel!.roleId,
      };
    }
    return _data;
  }
}
