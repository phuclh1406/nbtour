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
    final _data = <String, dynamic>{};
    _data['ticketTypeId'] = ticketTypeId;
    _data['ticketTypeName'] = ticketTypeName;
    _data['description'] = description;
    _data['status'] = status;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    return _data;
  }
}
