import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/database_provider.dart';
import 'entity_repository.dart';

final entityRepositoryProvider = Provider<EntityRepository>((ref) {
  return EntityRepository(ref.watch(databaseProvider));
});
