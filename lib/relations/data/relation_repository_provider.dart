import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/database_provider.dart';
import 'relation_repository.dart';

final relationRepositoryProvider = Provider<RelationRepository>((ref) {
  return RelationRepository(ref.watch(databaseProvider));
});
