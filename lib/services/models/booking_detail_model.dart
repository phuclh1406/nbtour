import 'package:nbtour/services/models/ticket_type_model.dart';
import 'package:nbtour/services/models/tour_model.dart';

class BookingDetail {
  BookingDetail({
    required this.ticketId,
    required this.ticketTour,
    required this.ticketType,
  });
  late String? ticketId;
  late Tour? ticketTour;
  late TicketTypes? ticketType;

  BookingDetail.fromJson(Map<String, dynamic> json) {
    ticketId = json['ticketId'];

    ticketTour =
        json['ticket_tour'] != null ? Tour.fromJson(json['ticket_tour']) : null;
    ticketType = json['ticket_type'] != null
        ? TicketTypes.fromJson(json['ticket_type'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['ticketId'] = ticketId;

    if (ticketTour != null) {
      data['ticket_tour'] = {
        'tourId': ticketTour?.tourId,
        'tourName': ticketTour?.tourName,
        "description": ticketTour?.description,
        "departureDate": ticketTour?.departureDate,
        "duration": ticketTour?.duration,
        "routeId": ticketTour?.tourRoute?.routeId,
        "departureStationId": ticketTour
            ?.tourRoute?.routeSegment?[0].segmentDepartureStation?.stationId,
        "tourGuideId": ticketTour?.tourGuide?.id,
        "driverId": ticketTour?.driver?.id,
        "busId": ticketTour?.tourBus?.busId,
        "tourStatus": ticketTour?.tourStatus,
        "status": ticketTour?.status,
        "tour_bus": ticketTour?.tourBus
      };
    }
    if (ticketType != null) {
      data['ticket_type'] = {
        'ticketTypeId': ticketType?.ticketTypeId,
        'ticketTypeName': ticketType?.ticketTypeName,
        'description': ticketType?.description,
      };
    }
    return data;
  }
}
