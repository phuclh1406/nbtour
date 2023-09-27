List<Stations> stationsFromJson(dynamic str) =>
    List<Stations>.from((str).map((x) => Stations.fromJson(x)));

class Stations {
  Stations({
    required this.stationId,
    required this.stationName,
    required this.description,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.status,
  });
  late final String? stationId;
  late final String? stationName;
  late final String? description;
  late final String? address;
  late final String? latitude;
  late final String? longitude;
  late final String? status;

  Stations.fromJson(Map<String, dynamic> json) {
    stationId = json['stationId'];
    stationName = json['stationName'];
    description = json['description'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['stationId'] = stationId;
    _data['stationName'] = stationName;
    _data['description'] = description;
    _data['address'] = address;
    _data['latitude'] = latitude;
    _data['longitude'] = longitude;
    _data['status'] = status;
    return _data;
  }
}
