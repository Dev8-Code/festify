import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/event_model.dart';

class EventService {
  static final _supabase = Supabase.instance.client;

  static Future<int?> salvarEvento(Evento evento) async {
    try {
      final eventoMap = evento.toMap();
      print('[EventService] Salvando evento: $eventoMap');

      final response =
          await _supabase
              .from('eventos')
              .insert(eventoMap)
              .select('id_evento')
              .single();

      print('[EventService] Evento salvo com sucesso. Response: $response');
      return response['id_evento'] as int?;
    } catch (e) {
      print('[EventService] Erro ao salvar evento: $e');
      return null;
    }
  }

  static Future<List<Evento>> buscarEventos() async {
    try {
      final response = await _supabase
          .from('eventos')
          .select()
          .order('id_evento', ascending: false);

      return response.map<Evento>((map) => Evento.fromMap(map)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<Evento?> buscarEventoPorId(int id) async {
    try {
      final response =
          await _supabase.from('eventos').select().eq('id_evento', id).single();

      return Evento.fromMap(response);
    } catch (e) {
      return null;
    }
  }

  static Future<bool> atualizarEvento(
    int id,
    Map<String, dynamic> dados,
  ) async {
    try {
      await _supabase.from('eventos').update(dados).eq('id_evento', id);

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> excluirEvento(int id) async {
    try {
      await _supabase.from('eventos').delete().eq('id_evento', id);

      return true;
    } catch (e) {
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
  required String nomeBeneficiario,
  required String beneficiario,
  required int idCliente,
}) async {
  final evento = Evento(
    NomeBeneficiario: nomeBeneficiario,
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
