import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/database_provider.dart';
import 'tag_repository.dart';

final tagRepositoryProvider = Provider<TagRepository>((ref) {
  return TagRepository(ref.watch(databaseProvider));
});
