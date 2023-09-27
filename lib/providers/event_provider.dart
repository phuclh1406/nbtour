import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nbtour/data/dummyData.dart';

final mealsProvider = Provider((ref) {
  return availableCategories;
});
