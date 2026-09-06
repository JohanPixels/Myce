import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database_provider.dart';
import 'node_repository.dart';

final nodeRepositoryProvider = Provider<NodeRepository>((ref) {
  return NodeRepository(ref.watch(databaseProvider));
});
