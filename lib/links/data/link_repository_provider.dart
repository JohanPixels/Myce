import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/database_provider.dart';
import '../../entities/data/entity_repository_provider.dart';
import 'link_repository.dart';

final linkRepositoryProvider = Provider<LinkRepository>((ref) {
  return LinkRepository(
    ref.watch(databaseProvider),
    ref.watch(entityRepositoryProvider),
  );
});
