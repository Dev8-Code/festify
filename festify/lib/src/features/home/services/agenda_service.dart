import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/agenda_model.dart';

class AgendaService {
  final _client = Supabase.instance.client;

  Future<void> bloquearData(DateTime data, {String? motivo}) async {
    final dia = DateTime(data.year, data.month, data.day); // zera a hora

    final agenda = AgendaModel(
      dataBloqueio: dia,
      motivo: motivo,
      tipo: 'manual',
      idEvento: 9999,
    );

    await _client.from('agendas').insert(agenda.toMap());
  }
  Future<List<DateTime>> buscarDatasBloqueadasManuais() async {
  final response = await _client
      .from('agendas')
      .select('data_bloq_agenda')
      .eq('id_evento', 9999999); // Só busca bloqueios manuais

  return (response as List).map<DateTime>((item) {
    final data = DateTime.parse(item['data_bloq_agenda']);
    return DateTime(data.year, data.month, data.day); // remove hora
  }).toList();
}
Future<bool> dataEhDeEvento(DateTime data) async {
  final dia = DateTime(data.year, data.month, data.day);

  final response = await _client
      .from('eventos')
      .select('data_evento')
      .eq('data_evento', dia.toIso8601String());

  return response.isNotEmpty;
}


  Future<void> desbloquearData(DateTime data) async {
    final dia = DateTime(data.year, data.month, data.day); // zera a hora

    final registros = await _client
        .from('agendas')
        .select('id_agenda, data_bloq_agenda')
        .eq('tipo_bloq_agenda', 'manual')
        .eq('id_evento', 9999);

    for (var item in registros) {
      final dataBanco = DateTime.parse(item['data_bloq_agenda']);
      if (_isSameDay(dataBanco, dia)) {
        await _client
            .from('agendas')
            .delete()
            .eq('id_agenda', item['id_agenda']);
      }
    }
  }

  Future<List<DateTime>> buscarDatasBloqueadas() async {
    final response = await _client
        .from('agendas')
        .select('data_bloq_agenda')
        .eq('tipo_bloq_agenda', 'manual')
        .eq('id_evento', 9999);

    return (response as List)
        .map((e) {
          final raw = DateTime.parse(e['data_bloq_agenda']);
          return DateTime(raw.year, raw.month, raw.day); // tira hora
        })
        .toList();
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
