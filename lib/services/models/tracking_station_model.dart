import 'package:nbtour/services/models/station_model.dart';
import 'package:nbtour/services/models/tour_model.dart';
import 'package:nbtour/services/models/tour_schedule_model.dart';

List<TrackingStations> trackingStationsFromJson(dynamic str) =>
    List<TrackingStations>.from((str).map((x) => TrackingStations.fromJson(x)));

class TrackingStations {
  TrackingStations({
    required this.tourDetailId,
    required this.status,
    required this.detailSchedule,
    required this.tourDetailStation,
  });
  late String? tourDetailId;
  late String? status;
  late TourSchedule? detailSchedule;
  late Stations? tourDetailStation;

  TrackingStations.fromJson(Map<String, dynamic> json) {
    tourDetailId = json['tourDetailId'];
    status = json['status'];
    detailSchedule = json['detail_schedule'] != null
        ? TourSchedule.fromJson(json['detail_schedule'])
        : null;
    tourDetailStation = json['tour_detail_station'] != null
        ? Stations.fromJson(json['tour_detail_station'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['tourDetailId'] = tourDetailId;
    data['status'] = status;
    if (detailSchedule != null) {
      data['detail_tour'] = {
        'scheduleId': detailSchedule?.scheduleId,
        'departureDate': detailSchedule?.departureDate,
        'endDate': detailSchedule?.endDate,
        'isScheduled': detailSchedule?.isScheduled,
        'tourId': detailSchedule?.tourId,
        'tourGuideId': detailSchedule?.tourGuide?.id,
        'driverId': detailSchedule?.driver?.id,
        'busId': detailSchedule?.scheduleBus?.busId,
        'scheduleStatus': detailSchedule?.scheduleStatus,
        'schedule_tour': detailSchedule?.scheduleTour,
      };
    }
    if (tourDetailStation != null) {
      data['tour_detail_station'] = {
        'stationId': tourDetailStation?.stationId,
        'stationName': tourDetailStation?.stationName,
        'description': tourDetailStation?.description,
        'address': tourDetailStation?.address,
        'latitude': tourDetailStation?.latitude,
        'longitude': tourDetailStation?.longitude,
      };
    }
    return data;
  }
}
