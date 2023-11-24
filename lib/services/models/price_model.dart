List<Price> priceFromJson(dynamic str) =>
    List<Price>.from((str).map((x) => Price.fromJson(x)));

class Price {
  late String? priceId;
  late int? amount;
  late String? day;
  late String? ticketTypeId;
  late String? status;

  Price({
    this.priceId,
    this.amount,
    this.status,
    this.day,
    this.ticketTypeId,
  });

  Price.fromJson(Map<String, dynamic> json) {
    priceId = json['priceId'];
    amount = json['amount'];
    day = json['day'];
    ticketTypeId = json['ticketTypeId'];

    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['priceId'] = priceId;
    data['amount'] = amount;
    data['day'] = day;
    data['ticketTypeId'] = ticketTypeId;
    data['status'] = status;
    return data;
  }
}
