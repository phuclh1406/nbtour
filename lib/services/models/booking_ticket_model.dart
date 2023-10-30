import 'package:nbtour/models/ticket_model.dart';
import 'package:nbtour/models/ticket_type_model.dart';

List<BookingTickets> bookingTicketsFromJson(dynamic str) =>
    List<BookingTickets>.from((str).map((x) => BookingTickets.fromJson(x)));

class BookingTickets {
  BookingTickets({
    required this.quantity,
    required this.bookingDetailTicket,
  });
  late int? quantity;
  late Tickets? bookingDetailTicket;

  BookingTickets.fromJson(Map<String, dynamic> json) {
    quantity = json['quantity'];

    bookingDetailTicket = json['booking_detail_ticket'] != null
        ? Tickets.fromJson(json['booking_detail_ticket'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['quantity'] = quantity;
    if (bookingDetailTicket != null) {
      data['booking_detail_ticket'] = {
        'ticketId': bookingDetailTicket?.ticketId,
        'ticket_tour': bookingDetailTicket?.ticketTour,
      };
    }

    return data;
  }
}
