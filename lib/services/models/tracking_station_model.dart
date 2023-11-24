import 'package:nbtour/services/models/station_model.dart';
import 'package:nbtour/services/models/tour_model.dart';

List<TrackingStations> trackingStationsFromJson(dynamic str) =>
    List<TrackingStations>.from((str).map((x) => TrackingStations.fromJson(x)));

class TrackingStations {
  TrackingStations({
    required this.tourDetailId,
    required this.status,
    required this.tourDetail,
    required this.tourDetailStation,
  });
  late String? tourDetailId;
  late String? status;
  late Tour? tourDetail;
  late Stations? tourDetailStation;

  TrackingStations.fromJson(Map<String, dynamic> json) {
    tourDetailId = json['tourDetailId'];
    status = json['status'];
    tourDetail =
        json['detail_tour'] != null ? Tour.fromJson(json['detail_tour']) : null;
    tourDetailStation = json['tour_detail_station'] != null
        ? Stations.fromJson(json['tour_detail_station'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['tourDetailId'] = tourDetailId;
    data['status'] = status;
    if (tourDetail != null) {
      data['detail_tour'] = {
        'tourId': tourDetail?.tourId,
        'tourName': tourDetail?.tourName,
        'description': tourDetail?.description,
        'beginBookingDate': tourDetail?.beginBookingDate,
        'endBookingDate': tourDetail?.endBookingDate,
        'departureDate': tourDetail?.departureDate,
        'duration': tourDetail?.duration,
        'routeId': tourDetail?.tourRoute?.routeId,
        'tourGuideId': tourDetail?.tourGuide?.id,
        'driverId': tourDetail?.driver?.id,
        'busId': tourDetail?.tourBus?.busId,
        'tourStatus': tourDetail?.tourStatus,
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
