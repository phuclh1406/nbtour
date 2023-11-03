List<Tracking> trackingsFromJson(dynamic str) =>
    List<Tracking>.from((str).map((x) => Tracking.fromJson(x)));

class Tracking {
  Tracking({
    required this.trackingId,
    required this.coordinates,
    required this.tourId,
    required this.busId,
    required this.status,
  });
  late String? trackingId;
  late Map<String, dynamic>? coordinates;
  late String? tourId;
  late String? busId;
  late String? status;

  Tracking.fromJson(Map<String, dynamic> json) {
    trackingId = json['trackingId'];
    coordinates = json['coordinates'];
    tourId = json['tourId'];
    busId = json['busId'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['trackingId'] = trackingId;
    data['coordinates'] = coordinates;
    data['tourId'] = tourId;
    data['busId'] = busId;
    data['status'] = status;

    return data;
  }
}
