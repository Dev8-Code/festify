import 'package:supabase_flutter/supabase_flutter.dart';

class EventoService {
  final _client = Supabase.instance.client;

  Future<List<DateTime>> buscarDatasEventos() async {
    final response = await _client.from('eventos').select('data_evento');

    return (response as List).map<DateTime>((item) {
      final data = DateTime.parse(item['data_evento']);
      return DateTime(data.year, data.month, data.day);
    }).toList();
  }
}
