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

    if (json['route_detail'] != null && json['route_detail'] is List) {
      routeDetail = List<RouteDetail>.from(
        json['route_detail'].map((x) => RouteDetail.fromJson(x)),
      );
    }

    if (json['route_poi_detail'] != null && json['route_poi_detail'] is List) {
      routePoiDetail = List<RoutePoiDetail>.from(
        json['route_poi_detail'].map((x) => RoutePoiDetail.fromJson(x)),
      );
    }
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['routeId'] = routeId;
    _data['routeName'] = routeName;
    _data['distance'] = distance;
    _data['status'] = status;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;

    if (routeDetail != null && routeDetail!.isNotEmpty) {
      _data['route_detail'] = routeDetail!.map((routeDetail) {
        return {
          'routeDetailId': routeDetail.routeDetailId,
          'index': routeDetail.index,
          'stopoverTime': routeDetail.stopoverTime,
          'route_detail_station': routeDetail.routeDetailStation,
          'route_detail_step': routeDetail.routeDetailStep,
        };
      }).toList();
    }

    if (routePoiDetail != null && routePoiDetail!.isNotEmpty) {
      _data['route_poi_detail'] = routePoiDetail!.map((routePoiDetail) {
        return {
          'routepoiId': routePoiDetail.routepoiId,
          'index': routePoiDetail.index,
          'route_poi_detail_poi': routePoiDetail.routePoiDetailPoi,
        };
      }).toList();
    }

    return _data;
  }
}

class RouteDetail {
  RouteDetail({
    required this.routeDetailId,
    required this.index,
    required this.stopoverTime,
    required this.routeDetailStation,
    required this.routeDetailStep,
  });
  late final String? routeDetailId;
  late final int? index;
  late final String? stopoverTime;
  late final Stations? routeDetailStation;
  late final List<RouteDetailStep>? routeDetailStep;

  RouteDetail.fromJson(Map<String, dynamic> json) {
    routeDetailId = json['routeDetailId'];
    index = json['index'];
    stopoverTime = json['stopoverTime'];
    routeDetailStation = json['route_detail_station'] != null
        ? Stations.fromJson(json['route_detail_station'])
        : null;
    print('This is route detail station $routeDetailStation');
    if (json['route_detail_step'] != null &&
        json['route_detail_step'] is List) {
      routeDetailStep = List<RouteDetailStep>.from(
        json['route_detail_step'].map((x) => RouteDetailStep.fromJson(x)),
      );
    }
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['routeDetailId'] = routeDetailId;
    _data['index'] = index;
    _data['stopoverTime'] = stopoverTime;
    if (routeDetailStation != null) {
      _data['route_detail_station'] = {
        'stationId': routeDetailStation!.stationId,
        'stationName': routeDetailStation!.stationName,
        'description': routeDetailStation!.description,
        'address': routeDetailStation!.address,
        'latitude': routeDetailStation!.latitude,
        'longitude': routeDetailStation!.longitude,
      };
    }
    if (routeDetailStep != null) {
      _data['route_detail_step'] =
          routeDetailStep!.map((e) => e.toJson()).toList();
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
