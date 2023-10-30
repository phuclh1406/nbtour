// import 'package:nbtour/models/station_model.dart';
// import 'package:nbtour/models/ticket_type_model.dart';
// import 'package:nbtour/models/user_model.dart';

// class BookingDetail {
//   BookingDetail({
//     required this.bookingId,
//     required this.bookingDate,
//     required this.bookingCode,
//     required this.totalPrice,
//     required this.bookingStatus,
//     required this.status,
//     required this.isAttended,
//     required this.bookingUser,
//     required this.bookingDepartureStation,
//   });
//   late String? bookingId;
//   late String? bookingDate;
//   late String? bookingCode;
//   late int? totalPrice;
//   late String? bookingStatus;
//   late bool? isAttended;
//   late String? status;
//   late UserModel? bookingUser;
//   late TicketTypes? ticketType;
//   late Stations? bookingDepartureStation;

//   BookingDetail.fromJson(Map<String, dynamic> json) {
//     bookingId = json['bookingId'];
//     bookingDate = json['bookingDate'];
//     bookingCode = json['bookingCode'];
//     totalPrice = json['totalPrice'];
//     isAttended = json['isAttended'];
//     bookingStatus = json['bookingStatus'];
//     status = json['status'];
//     bookingUser = json['booking_user'] != null
//         ? UserModel.fromJson(json['booking_user'])
//         : null;
//     bookingDepartureStation = json['booking_departure_station'] != null
//         ? Stations.fromJson(json['booking_departure_station'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final data = <String, dynamic>{};
//     data['bookingId'] = bookingId;
//     data['bookingDate'] = bookingDate;
//     data['bookingCode'] = bookingCode;
//     data['totalPrice'] = totalPrice;
//     data['isAttended'] = isAttended;
//     data['bookingStatus'] = bookingStatus;
//     data['status'] = status;
//     if (bookingUser != null) {
//       data['booking_user'] = {
//         'userId': bookingUser?.id,
//         'userName': bookingUser?.name,
//       };
//     }
//     if (bookingDepartureStation != null) {
//       data['booking_departure_station'] = {
//         'stationId': bookingDepartureStation?.stationId,
//         'stationName': bookingDepartureStation?.stationName,
//       };
//     }
//     return data;
//   }
// }
