import 'package:dartz/dartz.dart';
import 'package:nbtour/services/models/vietnam_map/vietmap_autocomplete_model.dart';
import 'package:nbtour/services/models/repository/vietnam_api_repository.dart';

import '../../../utils/core/failures/failure.dart';
import '../../../utils/core/use_case.dart';

class SearchAddressUseCase
    extends UseCase<List<VietmapAutocompleteModel>, String> {
  final VietmapApiRepository repository;

  SearchAddressUseCase(this.repository);
  @override
  Future<Either<Failure, List<VietmapAutocompleteModel>>> call(String params) {
    return repository.searchLocation(params);
  }
}
