import 'package:nbtour/services/models/user_model.dart';

List<NotificationModel> notificationsFromJson(dynamic str) =>
    List<NotificationModel>.from(
        (str).map((x) => NotificationModel.fromJson(x)));

class NotificationModel {
  late String? notiId;
  late String? title;
  late String? body;
  late String? deviceToken;
  late String? notiType;
  late String? userId;
  late String? status;
  late String? createdAt;
  late UserModel? notiUser;

  NotificationModel({
    this.notiId,
    this.title,
    this.body,
    this.deviceToken,
    this.notiType,
    this.userId,
    this.status,
    this.createdAt,
    this.notiUser,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    notiId = json['notiId'];
    title = json['title'];
    body = json['body'];
    deviceToken = json['deviceToken'];
    notiType = json['notiType'];
    userId = json['userId'];
    status = json['status'];
    createdAt = json['createdAt'];
    notiUser = json['noti_user'] != null
        ? UserModel.fromJson(json['noti_user'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['notiId'] = notiId;
    data['title'] = title;
    data['body'] = body;
    data['deviceToken'] = deviceToken;
    data['notiType'] = notiType;
    data['userId'] = userId;
    data['status'] = status;
    if (notiUser != null) {
      data['noti_user'] = {
        'userId': notiUser?.id,
        'userName': notiUser?.name,
        'email': notiUser?.email,
        'user_role': notiUser?.roleModel
      };
    }
    return data;
  }
}
