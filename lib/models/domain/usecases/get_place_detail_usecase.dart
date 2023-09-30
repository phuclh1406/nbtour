import 'package:dartz/dartz.dart';
import 'package:nbtour/core/failures/failure.dart';
import 'package:nbtour/core/use_case.dart';
import 'package:nbtour/models/vietnam_map/vietmap_place_model.dart';
import 'package:nbtour/repository/vietnam_api_repository.dart';

class GetPlaceDetailUseCase extends UseCase<VietmapPlaceModel, String> {
  final VietmapApiRepository repository;

  GetPlaceDetailUseCase(this.repository);
  @override
  Future<Either<Failure, VietmapPlaceModel>> call(String params) {
    return repository.getPlaceDetail(params);
  }
}
