import 'package:dartz/dartz.dart';
import 'package:nbtour/utils/core/failures/failure.dart';
import 'package:nbtour/utils/core/use_case.dart';
import 'package:nbtour/services/models/vietnam_map/vietmap_reverse_model.dart';
import 'package:nbtour/services/models/repository/vietnam_api_repository.dart';

class GetLocationFromLatLngUseCase
    extends UseCase<VietmapReverseModel, LocationPoint> {
  final VietmapApiRepository repository;

  GetLocationFromLatLngUseCase(this.repository);
  @override
  Future<Either<Failure, VietmapReverseModel>> call(LocationPoint params) {
    return repository.getLocationFromLatLng(lat: params.lat, long: params.long);
  }
}

class LocationPoint {
  final double lat;
  final double long;

  LocationPoint({required this.lat, required this.long});
}
