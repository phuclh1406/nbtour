import 'package:nbtour/models/point_of_interest_model.dart';
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
    required this.geoJson,
    required this.updatedAt,
    required this.routeSegment,
  });
  late String? routeId;
  late String? routeName;
  late String? distance;
  late String? status;
  late Map<String, dynamic>? geoJson;
  late String? createdAt;
  late String? updatedAt;
  late List<RouteSegment>? routeSegment;

  Routes.fromJson(Map<String, dynamic> json) {
    routeId = json['routeId'];
    routeName = json['routeName'];
    distance = json['distance'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    geoJson = json['geoJson'];

    if (json['route_segment'] != null && json['route_segment'] is List) {
      routeSegment = List<RouteSegment>.from(
        json['route_segment'].map((x) => RouteSegment.fromJson(x)),
      );
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['routeId'] = routeId;
    data['routeName'] = routeName;
    data['distance'] = distance;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['geoJson'] = geoJson;

    if (routeSegment != null && routeSegment!.isNotEmpty) {
      data['route_segment'] = routeSegment!.map((routeSegment) {
        return {
          'routeSegmentId': routeSegment.routeSegmentId,
          'index': routeSegment.index,
          'geoJson': routeSegment.geoJson,
          'route_detail_station': routeSegment.segmentDepartureStation,
        };
      }).toList();
    }

    return data;
  }
}

class RouteSegment {
  RouteSegment({
    required this.routeSegmentId,
    required this.index,
    required this.segmentDepartureStation,
    required this.segmentEndStation,
    required this.geoJson,
    required this.segmentRoutePoiDetail,
  });
  late final String? routeSegmentId;
  late final int? index;
  late final Stations? segmentDepartureStation;
  late final Stations? segmentEndStation;
  late final String? geoJson;
  late final List<SegmentRoutePoiDetail>? segmentRoutePoiDetail;

  RouteSegment.fromJson(Map<String, dynamic> json) {
    routeSegmentId = json['routeSegmentId'];
    index = json['index'];
    geoJson = json['geoJson'];
    segmentDepartureStation = json['segment_departure_station'] != null
        ? Stations.fromJson(json['segment_departure_station'])
        : null;
    segmentEndStation = json['segment_end_station'] != null
        ? Stations.fromJson(json['segment_end_station'])
        : null;
    print('This is route detail station $segmentDepartureStation');
    if (json['segment_route_poi_detail'] != null &&
        json['segment_route_poi_detail'] is List) {
      segmentRoutePoiDetail = List<SegmentRoutePoiDetail>.from(
        json['segment_route_poi_detail']
            .map((x) => SegmentRoutePoiDetail.fromJson(x)),
      );
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['routeSegmentId'] = routeSegmentId;
    data['index'] = index;
    if (segmentDepartureStation != null) {
      data['segment_departure_station'] = {
        'stationId': segmentDepartureStation!.stationId,
        'stationName': segmentDepartureStation!.stationName,
        'description': segmentDepartureStation!.description,
        'address': segmentDepartureStation!.address,
        'latitude': segmentDepartureStation!.latitude,
        'longitude': segmentDepartureStation!.longitude,
      };
    }
    if (segmentEndStation != null) {
      data['segment_end_station'] = {
        'stationId': segmentDepartureStation!.stationId,
        'stationName': segmentDepartureStation!.stationName,
        'description': segmentDepartureStation!.description,
        'address': segmentDepartureStation!.address,
        'latitude': segmentDepartureStation!.latitude,
        'longitude': segmentDepartureStation!.longitude,
      };
    }
    if (segmentRoutePoiDetail != null && segmentRoutePoiDetail!.isNotEmpty) {
      data['segment_route_poi_detail'] =
          segmentRoutePoiDetail!.map((segmentRoutePoiDetail) {
        return {
          'routepoiId': segmentRoutePoiDetail.routepoiId,
          'index': segmentRoutePoiDetail.index,
          'route_poi_detail_poi': segmentRoutePoiDetail.routePoiDetailPoi,
        };
      }).toList();
    }
    return data;
  }
}

class SegmentRoutePoiDetail {
  SegmentRoutePoiDetail({
    required this.routepoiId,
    required this.index,
    required this.routePoiDetailPoi,
  });
  late final String? routepoiId;
  late final int? index;
  late final String? routeSegmentId;
  late final PointOfInterest? routePoiDetailPoi;

  SegmentRoutePoiDetail.fromJson(Map<String, dynamic> json) {
    routepoiId = json['routepoiId'];
    index = json['index'];
    routeSegmentId = json['routeSegmentId'];
    routePoiDetailPoi = PointOfInterest.fromJson(json['route_poi_detail_poi']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['routepoiId'] = routepoiId;
    data['index'] = index;
    data['route_poi_detail_poi'] = routePoiDetailPoi?.toJson();
    return data;
  }
}
