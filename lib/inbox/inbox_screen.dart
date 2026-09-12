import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/inbox_repository_provider.dart';
import '../capture/capture_sheet.dart';
import '../entities/presentation/classify_sheet.dart';

class InboxScreen extends ConsumerWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(inboxRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Inbox')),
      body: StreamBuilder(
        stream: repo.watchInbox(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snapshot.data!;
          if (items.isEmpty) {
            return const Center(child: Text('Inbox vacío 🌱'));
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, i) {
              final item = items[i];
              return ListTile(
                title: Text(item.content),
                subtitle: Text(_hace(item.createdAt)),
                onTap: () => mostrarClasificarSheet(context, ref, item.id),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => mostrarCapturaSheet(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }
}

String _hace(DateTime fecha) {
  final diff = DateTime.now().difference(fecha);
  if (diff.inMinutes < 1) return 'ahora mismo';
  if (diff.inHours < 1) return 'hace ${diff.inMinutes} min';
  if (diff.inDays < 1) return 'hace ${diff.inHours} h';
  return 'hace ${diff.inDays} d';
}
