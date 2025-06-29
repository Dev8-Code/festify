import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/event_model.dart';

class EventService {
  static final _supabase = Supabase.instance.client;

  // Método para salvar evento
  static Future<int?> salvarEvento(Evento evento) async {
    try {
      final response =
          await _supabase
              .from('eventos')
              .insert(evento.toMap())
              .select('id_evento')
              .single();

      return response['id_evento'] as int?;
    } catch (e) {
      print('Erro ao salvar evento: $e');
      return null;
    }
  }

  // Método para buscar eventos
  static Future<List<Evento>> buscarEventos() async {
    try {
      final response = await _supabase
          .from('eventos')
          .select()
          .order('id_evento', ascending: false);

      return response.map<Evento>((map) => Evento.fromMap(map)).toList();
    } catch (e) {
      print('Erro ao buscar eventos: $e');
      return [];
    }
  }

  // Método para buscar evento por ID
  static Future<Evento?> buscarEventoPorId(int id) async {
    try {
      final response =
          await _supabase.from('eventos').select().eq('id_evento', id).single();

      return Evento.fromMap(response);
    } catch (e) {
      print('Erro ao buscar evento: $e');
      return null;
    }
  }

  // Método para atualizar evento
  static Future<bool> atualizarEvento(
    int id,
    Map<String, dynamic> dados,
  ) async {
    try {
      await _supabase.from('eventos').update(dados).eq('id_evento', id);

      return true;
    } catch (e) {
      print('Erro ao atualizar evento: $e');
      return false;
    }
  }

  // Método para excluir evento
  static Future<bool> excluirEvento(int id) async {
    try {
      await _supabase.from('eventos').delete().eq('id_evento', id);

      return true;
    } catch (e) {
      print('Erro ao excluir evento: $e');
      return false;
    }
  }
}

// Função legada para compatibilidade (caso seja usada em outros lugares)
Future<int?> cadastrarEvento({
  required BuildContext context,
  required String tipoEvento,
  required String dataEvento,
  required String horaEvento,
  required int diasMontagem,
  required int diasDesmontagem,
  required String beneficiario,
  required int idCliente,
}) async {
  final evento = Evento(
    beneficiario: beneficiario,
    tipoEvento: tipoEvento,
    dataEvento: _formataData(dataEvento).toString().split(' ')[0],
    horaEvento: horaEvento,
    diasMontagem: diasMontagem,
    diasDesmontagem: diasDesmontagem,
    idCliente: idCliente,
  );

  return await EventService.salvarEvento(evento);
}

DateTime _formataData(String data) {
  final partes = data.split('/');
  return DateTime.parse('${partes[2]}-${partes[1]}-${partes[0]}');
}
