import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/event_service.dart';

final datasEventosProvider = FutureProvider<List<DateTime>>((ref) async {
  final eventos = await EventService.buscarEventos();
  return eventos.map((e) {
    final partes = e.dataEvento.split('-'); // yyyy-MM-dd
    return DateTime(
      int.parse(partes[0]),
      int.parse(partes[1]),
      int.parse(partes[2]),
    );
  }).toList();
});
