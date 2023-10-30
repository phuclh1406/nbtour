List<TicketTypes> ticketTypesFromJson(dynamic str) =>
    List<TicketTypes>.from((str).map((x) => TicketTypes.fromJson(x)));

class TicketTypes {
  TicketTypes({
    required this.ticketTypeId,
    required this.ticketTypeName,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
  late String? ticketTypeId;
  late String? ticketTypeName;
  late String? description;
  late String? status;
  late String? createdAt;
  late String? updatedAt;

  TicketTypes.fromJson(Map<String, dynamic> json) {
    ticketTypeId = json['ticketTypeId'];
    ticketTypeName = json['ticketTypeName'];
    description = json['description'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['ticketTypeId'] = ticketTypeId;
    data['ticketTypeName'] = ticketTypeName;
    data['description'] = description;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
