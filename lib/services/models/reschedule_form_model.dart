import 'package:nbtour/services/models/tour_model.dart';
import 'package:nbtour/services/models/tour_schedule_model.dart';
import 'package:nbtour/services/models/user_model.dart';

List<RescheduleForm> rescheduleFormsFromJson(dynamic str) =>
    List<RescheduleForm>.from((str).map((x) => RescheduleForm.fromJson(x)));

class RescheduleForm {
  RescheduleForm({
    required this.formId,
    required this.userId,
    required this.changeEmployee,
    required this.currentSchedule,
    required this.desireSchedule,
    required this.status,
    required this.formUser,
    required this.createdAt,
  });
  late String? formId;
  late String? userId;
  late String? changeEmployee;
  late TourSchedule? currentSchedule;
  late TourSchedule? desireSchedule;
  late String? status;
  late UserModel? formUser;
  late String? createdAt;

  RescheduleForm.fromJson(Map<String, dynamic> json) {
    formId = json['formId'];
    userId = json['userId'];
    changeEmployee = json['changeEmployee'];
    currentSchedule = json['currentSchedule'] != null
        ? TourSchedule.fromJson(json['currentSchedule'])
        : null;
    desireSchedule = json['desireSchedule'] != null
        ? TourSchedule.fromJson(json['desireSchedule'])
        : null;
    status = json['status'];
    formUser = json['form_user'] != null
        ? UserModel.fromJson(json['form_user'])
        : null;
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['formId'] = formId;
    data['userId'] = userId;
    data['changeEmployee'] = changeEmployee;
    if (currentSchedule != null) {
      data['currentSchedule'] = {
        'scheduleId': currentSchedule?.scheduleId,
        'departureDate': currentSchedule?.departureDate,
        'endDate': currentSchedule?.endDate,
        'departureStation': currentSchedule?.station,
        'isScheduled': currentSchedule?.isScheduled,
        'scheduleStatus': currentSchedule?.scheduleStatus,
        'status': currentSchedule?.status,
        'schedule_tour': currentSchedule?.scheduleTour,
      };
    }
    if (desireSchedule != null) {
      data['desireSchedule'] = {
        'scheduleId': desireSchedule?.scheduleId,
        'departureDate': desireSchedule?.departureDate,
        'endDate': desireSchedule?.endDate,
        'departureStation': desireSchedule?.station,
        'isScheduled': desireSchedule?.isScheduled,
        'scheduleStatus': desireSchedule?.scheduleStatus,
        'status': desireSchedule?.status,
        'schedule_tour': desireSchedule?.scheduleTour,
      };
    }
    data['status'] = status;
    if (formUser != null) {
      data['form_user'] = {
        'userId': formUser?.id,
        'userName': formUser?.name,
        'email': formUser?.email,
        'user_role': formUser?.roleModel,
      };
    }
    data['createdAt'] = createdAt;

    return data;
  }
}
