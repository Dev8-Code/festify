import 'package:supabase_flutter/supabase_flutter.dart';

class BloqueioManualService {
  final _client = Supabase.instance.client;

  Future<void> bloquearData(DateTime data, {String? motivo}) async {
    final dia = DateTime(data.year, data.month, data.day);
    await _client.from('bloqueios_manuais').insert({
      'data_bloqueio': dia.toIso8601String(),
      'motivo': motivo,
      'tipo': 'manual',
    });
  }

  Future<void> desbloquearData(DateTime data) async {
    final dia = DateTime(data.year, data.month, data.day);
    await _client
        .from('bloqueios_manuais')
        .delete()
        .eq('data_bloqueio', dia.toIso8601String());
  }

  Future<List<DateTime>> buscarDatasBloqueadas() async {
    final response = await _client
        .from('bloqueios_manuais')
        .select('data_bloqueio');

    return (response as List).map<DateTime>((item) {
      final data = DateTime.parse(item['data_bloqueio']);
      return DateTime(data.year, data.month, data.day);
    }).toList();
  }
}
