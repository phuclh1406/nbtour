class TicketTypes {
  TicketTypes({
    required this.ticketTypeId,
    required this.ticketTypeName,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
  late final String? ticketTypeId;
  late final String? ticketTypeName;
  late final String? description;
  late final String? status;
  late final String? createdAt;
  late final String? updatedAt;

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
