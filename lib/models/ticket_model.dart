import 'package:nbtour/models/ticket_type_model.dart';
import 'package:nbtour/models/tour_model.dart';

class Tickets {
  Tickets({
    required this.ticketId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.ticketType,
    required this.ticketTour,
  });
  late String? ticketId;
  late String? status;
  late String? createdAt;
  late String? updatedAt;
  late TicketTypes? ticketType;
  late Tour? ticketTour;

  Tickets.fromJson(Map<String, dynamic> json) {
    ticketId = json['ticketId'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    ticketType = json['ticket_type'] != null
        ? TicketTypes.fromJson(json['ticket_type'])
        : null;
    ticketTour =
        json['ticket_tour'] != null ? Tour.fromJson(json['ticket_tour']) : null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['ticketId'] = ticketId;
    _data['status'] = status;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    if (ticketType != null) {
      _data['ticket_type'] = {
        'ticketTypeId': ticketType?.ticketTypeId,
        'ticketTypeName': ticketType?.ticketTypeName,
        'description': ticketType?.description,
        'status': ticketType?.status,
      };
    }
    if (ticketTour != null) {
      _data['ticket_tour'] = {
        'tourId': ticketTour?.tourId,
        'tourName': ticketTour?.tourName,
        'description': ticketTour?.description,
        'note': ticketTour?.note,
        'beginBookingDate': ticketTour?.beginBookingDate,
        'endBookingDate': ticketTour?.endBookingDate,
        'departureDate': ticketTour?.departureDate,
        'routeId': ticketTour?.tourRoute?.routeId,
        'departureStationId': ticketTour?.departureStation?.stationName,
        'tourStatus': ticketTour?.tourStatus,
        'status': ticketTour?.status,
      };
    }
    return _data;
  }
}
