import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../activities/data/task_repository_provider.dart';
import '../../core/database/database_provider.dart';
import '../../entities/data/entity_repository_provider.dart';
import '../../inbox/data/inbox_repository_provider.dart';
import '../../relations/data/relation_repository_provider.dart';
import '../../tags/data/tag_repository_provider.dart';
import 'project_repository.dart';

final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  return ProjectRepository(
    ref.watch(databaseProvider),
    ref.watch(entityRepositoryProvider),
    ref.watch(taskRepositoryProvider),
    ref.watch(relationRepositoryProvider),
    ref.watch(tagRepositoryProvider),
    ref.watch(inboxRepositoryProvider),
  );
});
