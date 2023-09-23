class Stations {
  Stations({
    required this.stationId,
    required this.stationName,
    required this.description,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
  late final String? stationId;
  late final String? stationName;
  late final String? description;
  late final String? address;
  late final String? latitude;
  late final String? longitude;
  late final String? status;
  late final String? createdAt;
  late final String? updatedAt;

  Stations.fromJson(Map<String, dynamic> json) {
    stationId = json['stationId'];
    stationName = json['stationName'];
    description = json['description'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
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
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    return _data;
  }
}
