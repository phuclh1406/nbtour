import 'package:nbtour/models/station_model.dart';

List<Routes> routesFromJson(dynamic str) =>
    List<Routes>.from((str).map((x) => Routes.fromJson(x)));

class Routes {
  Routes({
    required this.routeId,
    required this.routeName,
    required this.distance,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.routeDetail,
    required this.routePoiDetail,
  });
  late final String? routeId;
  late final String? routeName;
  late final double? distance;
  late final String? status;
  late final String? createdAt;
  late final String? updatedAt;
  late final List<RouteDetail>? routeDetail;
  late final List<RoutePoiDetail>? routePoiDetail;

  Routes.fromJson(Map<String, dynamic> json) {
    routeId = json['routeId'];
    routeName = json['routeName'];
    distance = json['distance'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    json['route_detail'] == null
        ? null
        : (json['route_detail'] as List)
            .map((i) => Routes.fromJson(i))
            .toList();
    json['route_poi_detail'] == null
        ? null
        : (json['route_poi_detail'] as List)
            .map((i) => Routes.fromJson(i))
            .toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['routeId'] = routeId;
    _data['routeName'] = routeName;
    _data['distance'] = distance;
    _data['status'] = status;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;

    if (routeDetail != null) {
      _data['route_detail'] = routeDetail!.map((x) => x.toJson()).toList();
    }

    if (routePoiDetail != null) {
      _data['route_poi_detail'] =
          routePoiDetail!.map((e) => e.toJson()).toList();
    }

    return _data;
  }
}

class RouteDetail {
  RouteDetail({
    required this.routeDetailId,
    required this.index,
    required this.stopoverTime,
    this.routeDetailStation,
    required this.routeDetailStep,
  });
  late final String? routeDetailId;
  late final int? index;
  late final String? stopoverTime;
  late final Stations? routeDetailStation;
  late final List<RouteDetailStep> routeDetailStep;

  RouteDetail.fromJson(Map<String, dynamic> json) {
    routeDetailId = json['routeDetailId'];
    index = json['index'];
    stopoverTime = json['stopoverTime'];
    routeDetailStation = null;
    routeDetailStep = List.from(json['route_detail_step'])
        .map((e) => RouteDetailStep.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['routeDetailId'] = routeDetailId;
    _data['index'] = index;
    _data['stopoverTime'] = stopoverTime;
    _data['route_detail_station'] = routeDetailStation;
    if (routeDetailStep != null) {
      _data['route_detail_step'] =
          routeDetailStep.map((e) => e.toJson()).toList();
    }

    return _data;
  }
}

class RouteDetailStep {
  RouteDetailStep({
    required this.stepId,
    required this.index,
    required this.latitude,
    required this.longitude,
    required this.routeDetailId,
  });
  late final String? stepId;
  late final int? index;
  late final String? latitude;
  late final String? longitude;
  late final String? routeDetailId;

  RouteDetailStep.fromJson(Map<String, dynamic> json) {
    stepId = json['stepId'];
    index = json['index'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    routeDetailId = json['routeDetailId'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['stepId'] = stepId;
    _data['index'] = index;
    _data['latitude'] = latitude;
    _data['longitude'] = longitude;
    _data['routeDetailId'] = routeDetailId;
    return _data;
  }
}

class RoutePoiDetail {
  RoutePoiDetail({
    required this.routepoiId,
    required this.index,
    required this.routePoiDetailPoi,
  });
  late final String routepoiId;
  late final int index;
  late final RoutePoiDetailPoi routePoiDetailPoi;

  RoutePoiDetail.fromJson(Map<String, dynamic> json) {
    routepoiId = json['routepoiId'];
    index = json['index'];
    routePoiDetailPoi =
        RoutePoiDetailPoi.fromJson(json['route_poi_detail_poi']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['routepoiId'] = routepoiId;
    _data['index'] = index;
    _data['route_poi_detail_poi'] = routePoiDetailPoi.toJson();
    return _data;
  }
}

class RoutePoiDetailPoi {
  RoutePoiDetailPoi({
    required this.poiId,
    required this.poiName,
    required this.description,
    required this.address,
    required this.latitude,
    required this.longitude,
  });
  late final String? poiId;
  late final String? poiName;
  late final String? description;
  late final String? address;
  late final String? latitude;
  late final String? longitude;

  RoutePoiDetailPoi.fromJson(Map<String, dynamic> json) {
    poiId = json['poiId'];
    poiName = json['poiName'];
    description = json['description'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['poiId'] = poiId;
    _data['poiName'] = poiName;
    _data['description'] = description;
    _data['address'] = address;
    _data['latitude'] = latitude;
    _data['longitude'] = longitude;
    return _data;
  }
}
