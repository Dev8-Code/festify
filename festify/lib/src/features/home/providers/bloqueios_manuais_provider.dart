import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../services/agenda_service.dart'; // REMOVA esta linha
import '../services/bloqueio_manual_service.dart'; // ADICIONE esta linha

final bloqueiosManuaisProvider = StateNotifierProvider<BloqueiosManuaisNotifier, List<DateTime>>(
  (ref) => BloqueiosManuaisNotifier(),
);

class BloqueiosManuaisNotifier extends StateNotifier<List<DateTime>> {
  BloqueiosManuaisNotifier() : super([]) {
    carregar();
  }

  // Altere o serviço de AgendaService para BloqueioManualService
  final _service = BloqueioManualService(); //

  Future<void> carregar() async {
    state = await _service.buscarDatasBloqueadas(); // Use buscarDatasBloqueadas diretamente
  }

  Future<void> bloquear(DateTime data) async {
    await _service.bloquearData(data); //
    state = [...state, data];
  }

  Future<void> desbloquear(DateTime data, {BuildContext? context}) async {
    final isEvento = await _service.dataEhDeEvento(data); //
    if (isEvento) {
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Essa é uma data de evento. Não é possível desbloquear.')),
        );
      }
      return;
    }

    await _service.desbloquearData(data); //
    state = state.where((d) => !_isSameDay(d, data)).toList();
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}