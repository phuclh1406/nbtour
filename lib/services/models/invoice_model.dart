import 'package:nbtour/services/models/user_model.dart';

List<Invoices> invoicesFromJson(dynamic str) =>
    List<Invoices>.from((str).map((x) => Invoices.fromJson(x)));

class Invoices {
  Invoices({
    required this.scheduleId,
    required this.paidBackPrice,
    required this.tourGuide,
  });

  late String? scheduleId;
  late int? paidBackPrice;
  late UserModel? tourGuide;

  Invoices.fromJson(Map<String, dynamic> json) {
    scheduleId = json['scheduleId'];
    paidBackPrice = json['paidBackPrice'];
    tourGuide = json['schedule_tourguide'] != null
        ? UserModel.fromJson(json['schedule_tourguide'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['scheduleId'] = scheduleId;
    data['paidBackPrice'] = paidBackPrice;
    if (tourGuide != null) {
      data['schedule_tourguide'] = {
        'userId': tourGuide?.id,
        'userName': tourGuide?.name,
      };
    }
    return data;
  }
}
