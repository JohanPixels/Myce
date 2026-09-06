import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'sync_repository.dart';
import '../../nodes/data/database_provider.dart'; // ajusta esta ruta a donde tengas database.dart

class SyncTestButton extends ConsumerStatefulWidget {
  const SyncTestButton({super.key});

  @override
  ConsumerState<SyncTestButton> createState() => _SyncTestButtonState();
}

class _SyncTestButtonState extends ConsumerState<SyncTestButton> {
  bool _syncing = false;

  Future<void> _sync() async {
    setState(() => _syncing = true);
    final db = ref.read(
      databaseProvider,
    ); // ajusta al nombre real de tu provider
    await pushDirtyNodes(db);
    if (mounted) {
      setState(() => _syncing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sync intentado — revisa Supabase')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _syncing ? null : _sync,
      icon: _syncing
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.cloud_upload_outlined),
      tooltip: 'Sincronizar ahora (prueba)',
    );
  }
}
