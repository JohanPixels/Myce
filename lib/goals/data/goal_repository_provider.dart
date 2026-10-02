import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/database_provider.dart';
import '../../projects/data/project_repository_provider.dart';
import 'goal_repository.dart';

final goalRepositoryProvider = Provider<GoalRepository>((ref) {
  return GoalRepository(
    ref.watch(databaseProvider),
    ref.watch(projectRepositoryProvider),
  );
});
