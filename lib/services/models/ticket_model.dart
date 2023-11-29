import 'package:nbtour/services/models/ticket_type_model.dart';

List<Tickets> ticketsFromJson(dynamic str) =>
    List<Tickets>.from((str).map((x) => Tickets.fromJson(x)));

class Tickets {
  Tickets({
    required this.ticketId,
    required this.ticketType,
    required this.quantity,
  });

  late String? ticketId;
  late int? quantity;
  late TicketTypes? ticketType;

  Tickets.fromJson(Map<String, dynamic> json) {
    ticketId = json['ticketId'];
    quantity = json['quantity'];
    ticketType = json['ticket_type'] != null
        ? TicketTypes.fromJson(json['ticket_type'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['ticketId'] = ticketId;
    data['quantity'] = quantity;
    if (ticketType != null) {
      data['ticket_type'] = {
        'ticketTypeId': ticketType?.ticketTypeId,
        'ticketTypeName': ticketType?.ticketTypeName,
        'description': ticketType?.description,
        'status': ticketType?.status,
      };
    }

    return data;
  }
}
