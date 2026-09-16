import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../activities/data/task_repository_provider.dart';
import '../../core/database/database_provider.dart';
import '../../entities/data/entity_repository_provider.dart';
import '../../tags/data/tag_repository_provider.dart';
import 'inbox_repository.dart';

final inboxRepositoryProvider = Provider<InboxRepository>((ref) {
  return InboxRepository(
    ref.watch(databaseProvider),
    ref.watch(entityRepositoryProvider),
    ref.watch(tagRepositoryProvider),
    ref.watch(taskRepositoryProvider),
  );
});
