import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/event_agenda_model.dart';

class EventAgendaService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Event>> fetchAllEvents() async {
    try {
      final response = await _supabase
          .from('eventos')
          // Change 'nome_cliente' to 'nome_razao_social' here
          .select('*, clientes(nome_razao_social), locais(endereco_local)')
          .order('data_evento', ascending: true);

      if (response != null && response is List) {
        return response.map((json) => Event.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Error fetching all events: $e');
      throw Exception('Falha ao carregar todos os eventos do Supabase: $e');
    }
  }

  Future<Event> fetchEventDetails(int eventId) async {
    try {
      final response = await _supabase
          .from('eventos')
          // Change 'nome_cliente' to 'nome_razao_social' here
          .select('*, clientes(nome_razao_social), locais(endereco_local)')
          .eq('id_evento', eventId)
          .single();

      return Event.fromJson(response);
    } catch (e) {
      print('Error fetching single event details: $e');
      throw Exception('Falha ao carregar os detalhes do evento do Supabase: $e');
    }
  }
}