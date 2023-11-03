import 'package:nbtour/services/models/booking_ticket_model.dart';
import 'package:nbtour/services/models/station_model.dart';

import 'package:nbtour/services/models/user_model.dart';

List<Booking> bookingsFromJson(dynamic str) =>
    List<Booking>.from((str).map((x) => Booking.fromJson(x)));

class Booking {
  Booking({
    required this.bookingId,
    required this.bookingDate,
    required this.bookingCode,
    required this.totalPrice,
    required this.bookingStatus,
    required this.status,
    required this.isAttended,
    required this.bookingUser,
    required this.bookingDepartureStation,
    required this.tickets,
  });
  late String? bookingId;
  late String? bookingDate;
  late String? bookingCode;
  late int? totalPrice;
  late String? bookingStatus;
  late bool? isAttended;
  late String? status;
  late UserModel? bookingUser;
  late Stations? bookingDepartureStation;
  late List<BookingTickets>? tickets;

  Booking.fromJson(Map<String, dynamic> json) {
    bookingId = json['bookingId'];
    bookingDate = json['bookingDate'];
    bookingCode = json['bookingCode'];
    totalPrice = json['totalPrice'];
    isAttended = json['isAttended'];
    bookingStatus = json['bookingStatus'];
    status = json['status'];
    bookingUser = json['booking_user'] != null
        ? UserModel.fromJson(json['booking_user'])
        : null;
    bookingDepartureStation = json['booking_departure_station'] != null
        ? Stations.fromJson(json['booking_departure_station'])
        : null;
    if (json['tickets'] != null && json['tickets'] is List) {
      tickets = List<BookingTickets>.from(
        json['tickets'].map((x) => BookingTickets.fromJson(x)),
      );
    } else {
      tickets = [];
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    data['bookingId'] = bookingId;
    data['bookingDate'] = bookingDate;
    data['bookingCode'] = bookingCode;
    data['totalPrice'] = totalPrice;
    data['isAttended'] = isAttended;
    data['bookingStatus'] = bookingStatus;
    data['status'] = status;
    if (bookingUser != null) {
      data['booking_user'] = {
        'userId': bookingUser?.id,
        'userName': bookingUser?.name,
        'email': bookingUser?.email
      };
    }
    if (bookingDepartureStation != null) {
      data['booking_departure_station'] = {
        'stationId': bookingDepartureStation?.stationId,
        'stationName': bookingDepartureStation?.stationName,
      };
    }

    if (tickets != null && tickets!.isNotEmpty) {
      data['tickets'] = tickets!.map((ticket) {
        return {
          'quantity': ticket.quantity,
          'booking_detail_ticket': ticket.bookingDetailTicket,
        };
      }).toList();
    }

    return data;
  }
}
