import 'package:nbtour/services/models/tour_model.dart';
import 'package:nbtour/services/models/user_model.dart';

List<RescheduleForm> rescheduleFormsFromJson(dynamic str) =>
    List<RescheduleForm>.from((str).map((x) => RescheduleForm.fromJson(x)));

class RescheduleForm {
  RescheduleForm({
    required this.formId,
    required this.userId,
    required this.changeEmployee,
    required this.currentTour,
    required this.desireTour,
    required this.status,
    required this.formUser,
  });
  late String? formId;
  late String? userId;
  late String? changeEmployee;
  late Tour? currentTour;
  late Tour? desireTour;
  late String? status;
  late UserModel? formUser;

  RescheduleForm.fromJson(Map<String, dynamic> json) {
    formId = json['formId'];
    userId = json['userId'];
    changeEmployee = json['changeEmployee'];
    currentTour =
        json['currentTour'] != null ? Tour.fromJson(json['currentTour']) : null;
    desireTour =
        json['desireTour'] != null ? Tour.fromJson(json['desireTour']) : null;
    status = json['status'];
    formUser = json['form_user'] != null
        ? UserModel.fromJson(json['form_user'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['formId'] = formId;
    data['userId'] = userId;
    data['changeEmployee'] = changeEmployee;
    if (currentTour != null) {
      data['form_user'] = {
        'tourId': currentTour?.tourId,
        'tourName': currentTour?.tourName,
        'description': currentTour?.description,
        'note': currentTour?.note,
        'beginBookingDate': currentTour?.beginBookingDate,
        'endBookingDate': currentTour?.endBookingDate,
        'departureDate': currentTour?.departureDate,
        'duration': currentTour?.duration,
        'routeId': currentTour?.tourRoute?.routeId,
        'departureStationId': currentTour?.departureStation?.stationId,
        'tourGuideId': currentTour?.tourGuide?.id,
        'driverId': currentTour?.driver?.id,
        'busId': currentTour?.tourBus?.busId,
        'tourStatus': currentTour?.tourStatus,
        'status': currentTour?.status,
      };
    }
    if (desireTour != null) {
      data['form_user'] = {
        'tourId': desireTour?.tourId,
        'tourName': desireTour?.tourName,
        'description': desireTour?.description,
        'note': desireTour?.note,
        'beginBookingDate': desireTour?.beginBookingDate,
        'endBookingDate': desireTour?.endBookingDate,
        'departureDate': desireTour?.departureDate,
        'duration': desireTour?.duration,
        'routeId': desireTour?.tourRoute?.routeId,
        'departureStationId': desireTour?.departureStation?.stationId,
        'tourGuideId': desireTour?.tourGuide?.id,
        'driverId': desireTour?.driver?.id,
        'busId': desireTour?.tourBus?.busId,
        'tourStatus': desireTour?.tourStatus,
        'status': desireTour?.status,
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

    return data;
  }
}
