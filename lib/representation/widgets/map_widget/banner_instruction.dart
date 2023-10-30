import 'package:dartz/dartz.dart';
import 'package:nbtour/models/vietnam_map/vietmap_autocomplete_model.dart';
import 'package:nbtour/repository/vietnam_api_repository.dart';

import '../../core/failures/failure.dart';
import '../../core/use_case.dart';

class SearchAddressUseCase
    extends UseCase<List<VietmapAutocompleteModel>, String> {
  final VietmapApiRepository repository;

  SearchAddressUseCase(this.repository);
  @override
  Future<Either<Failure, List<VietmapAutocompleteModel>>> call(String params) {
    return repository.searchLocation(params);
  }
}
