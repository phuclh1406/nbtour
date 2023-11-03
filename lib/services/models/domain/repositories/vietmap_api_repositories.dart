import 'dart:io';

import 'package:nbtour/utils/core/failures/api_server_failure.dart';
import 'package:nbtour/utils/core/failures/api_timeout_failure.dart';
import 'package:nbtour/utils/core/failures/exception_failure.dart';
import 'package:nbtour/utils/core/failures/failure.dart';
import 'package:nbtour/services/models/vietnam_map/vietmap_autocomplete_model.dart';
import 'package:nbtour/services/models/vietnam_map/vietmap_place_model.dart';
import 'package:nbtour/services/models/vietnam_map/vietmap_reverse_model.dart';
import 'package:nbtour/services/models/repository/vietnam_api_repository.dart';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

class VietmapApiRepositories implements VietmapApiRepository {
  late Dio _dio;
  String baseUrl = 'https://maps.vietmap.vn/api/';
  String apiKey = 'c3d0f188ff669f89042771a20656579073cffec5a8a69747';
  VietmapApiRepositories() {
    _dio = Dio(BaseOptions(baseUrl: baseUrl));

    if (kDebugMode) {
      (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
    }
  }

  @override
  Future<Either<Failure, VietmapReverseModel>> getLocationFromLatLng(
      {required double lat, required double long}) async {
    try {
      var res = await _dio.get('reverse/v3',
          queryParameters: {'apikey': apiKey, 'lat': lat, 'lng': long});

      if (res.statusCode == 200 && res.data.length > 0) {
        var data = VietmapReverseModel.fromJson(res.data[0]);
        return Right(data);
      } else {
        return const Left(ApiServerFailure('Có lỗi xảy ra'));
      }
    } on DioException catch (ex) {
      if (ex.type == DioExceptionType.receiveTimeout) {
        return Left(ApiTimeOutFailure());
      } else {
        return Left(ExceptionFailure(ex));
      }
    }
  }

  @override
  Future<Either<Failure, List<VietmapAutocompleteModel>>> searchLocation(
      String keySearch) async {
    try {
      var res = await _dio.get('autocomplete/v3',
          queryParameters: {'apikey': apiKey, 'text': keySearch});

      if (res.statusCode == 200) {
        var data = List<VietmapAutocompleteModel>.from(
            res.data.map((e) => VietmapAutocompleteModel.fromJson(e)));
        return Right(data);
      } else {
        return const Left(ApiServerFailure('Có lỗi xảy ra'));
      }
    } on DioException catch (ex) {
      if (ex.type == DioExceptionType.receiveTimeout) {
        return Left(ApiTimeOutFailure());
      } else {
        return Left(ExceptionFailure(ex));
      }
    }
  }

  @override
  Future<Either<Failure, VietmapPlaceModel>> getPlaceDetail(
      String placeId) async {
    try {
      var res = await _dio.get('place/v3',
          queryParameters: {'apikey': apiKey, 'refid': placeId});

      if (res.statusCode == 200) {
        var data = VietmapPlaceModel.fromJson(res.data);
        return Right(data);
      } else {
        return const Left(ApiServerFailure('Có lỗi xảy ra'));
      }
    } on DioException catch (ex) {
      if (ex.type == DioExceptionType.receiveTimeout) {
        return Left(ApiTimeOutFailure());
      } else {
        return Left(ExceptionFailure(ex));
      }
    }
  }
}
