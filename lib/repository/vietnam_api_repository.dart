import 'package:nbtour/models/vietnam_map/vietmap_autocomplete_model.dart';
import 'package:nbtour/models/vietnam_map/vietmap_place_model.dart';
import 'package:nbtour/models/vietnam_map/vietmap_reverse_model.dart';

import '/core/failures/failure.dart';

import 'package:dartz/dartz.dart';

abstract class VietmapApiRepository {
  Future<Either<Failure, VietmapReverseModel>> getLocationFromLatLng(
      {required double lat, required double long});

  Future<Either<Failure, List<VietmapAutocompleteModel>>> searchLocation(
      String keySearch);

  Future<Either<Failure, VietmapPlaceModel>> getPlaceDetail(String placeId);
}
