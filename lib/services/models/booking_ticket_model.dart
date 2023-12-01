import 'package:nbtour/services/models/booking_detail_model.dart';

List<BookingTickets> bookingTicketsFromJson(dynamic str) =>
    List<BookingTickets>.from((str).map((x) => BookingTickets.fromJson(x)));

class BookingTickets {
  BookingTickets({
    required this.quantity,
    required this.ticketId,
    required this.bookingDetailTicket,
  });
  late String? ticketId;
  late int? quantity;
  late BookingDetail? bookingDetailTicket;

  BookingTickets.fromJson(Map<String, dynamic> json) {
    quantity = json['quantity'];
    ticketId = json['ticketId'];
    bookingDetailTicket = json['booking_detail_ticket'] != null
        ? BookingDetail.fromJson(json['booking_detail_ticket'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['quantity'] = quantity;
    data['ticketId'] = ticketId;
    if (bookingDetailTicket != null) {
      data['booking_detail_ticket'] = {
        'ticketId': bookingDetailTicket?.ticketId,
        'ticket_type': bookingDetailTicket?.ticketType,
      };
    }

    return data;
  }
}
