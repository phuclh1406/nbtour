import 'package:nbtour/services/models/ticket_model.dart';
import 'package:nbtour/services/models/ticket_type_model.dart';

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
  late TicketTypes? bookingDetailTicket;

  BookingTickets.fromJson(Map<String, dynamic> json) {
    quantity = json['quantity'];
    ticketId = json['ticketId'];
    bookingDetailTicket = json['ticket_type'] != null
        ? TicketTypes.fromJson(json['ticket_type'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['quantity'] = quantity;
    data['ticketId'] = ticketId;
    if (bookingDetailTicket != null) {
      data['ticket_type'] = {
        'ticketTypeId': bookingDetailTicket?.ticketTypeId,
        'ticketTypeName': bookingDetailTicket?.ticketTypeName,
        'description': bookingDetailTicket?.description,
        'price': bookingDetailTicket?.price
      };
    }

    return data;
  }
}
