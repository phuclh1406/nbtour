import 'package:nbtour/services/models/user_model.dart';

List<Reports> reportsFromJson(dynamic str) =>
    List<Reports>.from((str).map((x) => Reports.fromJson(x)));

class Reports {
  Reports({
    required this.reportId,
    required this.title,
    required this.description,
    required this.response,
    required this.reportStatus,
    required this.status,
    required this.createdAt,
    required this.reportUser,
    required this.responseUser,
  });

  late String? reportId;
  late String? title;
  late String? description;
  late String? response;
  late String? reportStatus;
  late String? status;
  late String? createdAt;
  late UserModel? reportUser;
  late UserModel? responseUser;

  Reports.fromJson(Map<String, dynamic> json) {
    reportId = json['reportId'];
    title = json['title'];
    description = json['description'];
    response = json['response'];
    reportStatus = json['reportStatus'];
    status = json['status'];
    createdAt = json['createdAt'];
    reportUser = json['report_user'] != null
        ? UserModel.fromJson(json['report_user'])
        : null;
    responseUser = json['response_user'] != null
        ? UserModel.fromJson(json['response_user'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['reportId'] = reportId;
    data['title'] = title;
    data['description'] = description;
    data['response'] = response;
    data['reportStatus'] = reportStatus;
    data['status'] = status;
    data['createdAt'] = createdAt;
    if (reportUser != null) {
      data['report_user'] = {
        'userId': reportUser?.id,
        'userName': reportUser?.name,
        'user_role': reportUser?.roleModel,
      };
    }
    if (responseUser != null) {
      data['response_user'] = {
        'userId': responseUser?.id,
        'userName': responseUser?.name,
        'user_role': responseUser?.roleModel,
      };
    }
    return data;
  }
}
