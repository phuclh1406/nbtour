import 'package:dartz/dartz.dart';
import 'package:nbtour/utils/core/failures/failure.dart';
import 'package:nbtour/utils/core/use_case.dart';
import 'package:nbtour/services/models/vietnam_map/vietmap_place_model.dart';
import 'package:nbtour/services/models/repository/vietnam_api_repository.dart';

class GetPlaceDetailUseCase extends UseCase<VietmapPlaceModel, String> {
  final VietmapApiRepository repository;

  GetPlaceDetailUseCase(this.repository);
  @override
  Future<Either<Failure, VietmapPlaceModel>> call(String params) {
    return repository.getPlaceDetail(params);
  }
}
