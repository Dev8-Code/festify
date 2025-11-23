import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/event_agenda_model.dart';

class EventAgendaService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Event>> fetchAllEvents() async {
    try {
      final response = await _supabase
          .from('eventos')
          .select('*, clientes(nome_razao_social), locais(endereco_local)')
          .order('data_evento', ascending: true);

      // Supabase .select() for multiple rows returns a List
      final List<dynamic> data = response as List<dynamic>;
      return data.map((json) => Event.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Falha ao carregar todos os eventos do Supabase: $e');
    }
  }

  Future<Event> fetchEventDetails(int eventId) async {
    try {
      final response =
          await _supabase
              .from('eventos')
              .select('*, clientes(nome_razao_social), locais(endereco_local)')
              .eq('id_evento', eventId)
              .single();

      return Event.fromJson(response);
    } catch (e) {
      throw Exception(
        'Falha ao carregar os detalhes do evento do Supabase: $e',
      );
    }
  }
}
