import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'sync_repository.dart';
import '../../core/database/database_provider.dart';

/// Botón manual para forzar un ciclo de sync (push+pull) ya mismo, además
/// del automático (al abrir la app, al volver a foreground, y periódico —
/// ver home_shell.dart). Útil para no esperar el próximo ciclo automático
/// al verificar algo en el otro dispositivo.
class SyncButton extends ConsumerStatefulWidget {
  const SyncButton({super.key});

  @override
  ConsumerState<SyncButton> createState() => _SyncButtonState();
}

class _SyncButtonState extends ConsumerState<SyncButton> {
  bool _syncing = false;

  Future<void> _sync() async {
    setState(() => _syncing = true);
    final db = ref.read(databaseProvider);
    var ok = true;
    try {
      await syncNow(db);
    } catch (_) {
      ok = false; // fallo inesperado (no de red — eso ya se aísla por tabla)
    }
    if (mounted) {
      setState(() => _syncing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ok ? 'Sincronizado' : 'Sync falló — revisá conexión'),
        ),
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
          : const Icon(Icons.sync),
      tooltip: 'Sincronizar ahora',
    );
  }
}
